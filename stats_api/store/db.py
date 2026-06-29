"""DuckDB connection + low-level table helpers.

Single file on disk (`stats_api/data/parkfactor.duckdb`) by default. DuckDB is single-writer:
the ingest job opens read-write; the API opens short-lived `read_only=True` connections per
read. Read-only connections coexist; they cannot coexist with the writer, so the API may see a
brief error window during the nightly ingest — acceptable for local-first single-user dev, and
the read layer falls back to a live scrape if the store can't be opened (see read.py).
"""

import os
import duckdb

# Override with PARKFACTOR_DUCKDB to point at another file — or at `md:parkfactor` once we
# promote to MotherDuck (same engine/client, one-line change).
_DEFAULT_PATH = os.path.join(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "data", "parkfactor.duckdb"
)
DB_PATH = os.environ.get("PARKFACTOR_DUCKDB", _DEFAULT_PATH)

# A real local file (not the md: / :memory: forms) — used to short-circuit reads before first ingest.
_IS_FILE = not (DB_PATH.startswith("md:") or DB_PATH == ":memory:")


def exists():
    """True if the store file is present (or we're on a non-file backend like MotherDuck)."""
    return (not _IS_FILE) or os.path.exists(DB_PATH)


def connect(read_only=False):
    if not read_only and _IS_FILE:
        os.makedirs(os.path.dirname(DB_PATH), exist_ok=True)
    return duckdb.connect(DB_PATH, read_only=read_only)


def _table_exists(con, table):
    return (
        con.execute(
            "select count(*) from information_schema.tables where table_name = ?", [table]
        ).fetchone()[0]
        > 0
    )


def has_rows(table, season=None):
    """True if `table` exists and has rows (optionally for a given season). Safe if the DB is
    missing or locked — returns False so the caller falls back to a live scrape."""
    if not exists():
        return False
    try:
        con = connect(read_only=True)
    except Exception:
        return False
    try:
        if not _table_exists(con, table):
            return False
        if season is None:
            return con.execute(f'select count(*) from "{table}"').fetchone()[0] > 0
        return (
            con.execute(f'select count(*) from "{table}" where season = ?', [season]).fetchone()[0]
            > 0
        )
    except Exception:
        return False
    finally:
        con.close()


# --- write-side helpers (used by ingest) ----------------------------------------------------

_DTYPE_MAP = {
    "i": "BIGINT",
    "u": "BIGINT",
    "f": "DOUBLE",
    "b": "BOOLEAN",
    "M": "TIMESTAMP",
}


def _duckdb_type(dtype):
    return _DTYPE_MAP.get(getattr(dtype, "kind", "O"), "VARCHAR")


def _reconcile_columns(con, table, df):
    """Add any df columns missing from the table so INSERT BY NAME never fails on schema drift
    (pybaseball occasionally adds/renames a column between seasons)."""
    existing = {r[1] for r in con.execute(f'PRAGMA table_info("{table}")').fetchall()}
    for col in df.columns:
        if col not in existing:
            con.execute(f'ALTER TABLE "{table}" ADD COLUMN "{col}" {_duckdb_type(df[col].dtype)}')


def replace_season(con, table, df, season):
    """Idempotent per-season upsert: drop this season's rows, insert the fresh frame. Re-running a
    date/season yields identical contents (matches the pipeline's idempotency requirement)."""
    df = df.copy()
    df["season"] = season
    con.register("_incoming", df)
    try:
        if _table_exists(con, table):
            _reconcile_columns(con, table, df)
            con.execute(f'DELETE FROM "{table}" WHERE season = ?', [season])
            con.execute(f'INSERT INTO "{table}" BY NAME SELECT * FROM _incoming')
        else:
            con.execute(f'CREATE TABLE "{table}" AS SELECT * FROM _incoming')
    finally:
        con.unregister("_incoming")


def replace_table(con, table, df):
    """Full-table replace (for all-years frames like bWAR that aren't season-partitioned)."""
    con.register("_incoming", df)
    try:
        con.execute(f'DROP TABLE IF EXISTS "{table}"')
        con.execute(f'CREATE TABLE "{table}" AS SELECT * FROM _incoming')
    finally:
        con.unregister("_incoming")
