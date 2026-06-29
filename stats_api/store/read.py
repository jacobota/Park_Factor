"""Read helpers for the API layer.

Every getter returns a pandas DataFrame (or None when the store has no data for that season, so
the caller can fall back to a live scrape). Connections are opened read-only and short-lived.
"""

from . import db


def _query_df(sql, params=None):
    if not db.exists():
        return None
    try:
        con = db.connect(read_only=True)
    except Exception:
        return None  # locked (e.g. mid-ingest) or unreadable → caller falls back to live
    try:
        return con.execute(sql, params or []).fetch_df()
    except Exception:
        return None
    finally:
        con.close()


def season_frame(table, season):
    """The snapshot frame for one season, or None if the store has nothing for it."""
    if not db.has_rows(table, season):
        return None
    return _query_df(f'select * from "{table}" where season = ?', [season])


def team_stats_splits(season, group):
    """Reconstruct the MLB-StatsAPI `splits` shape ([{team:{id}, stat:{...}}, ...]) that the
    team-leaderboard builders expect, from the flattened `mlb_team_stats` snapshot. None if absent."""
    if not db.has_rows("mlb_team_stats", season):
        return None
    df = _query_df(
        'select * from "mlb_team_stats" where season = ? and "group" = ?', [season, group]
    )
    if df is None or len(df) == 0:
        return None
    meta = {"season", "group", "team_id", "team_name"}
    splits = []
    for row in df.to_dict("records"):
        stat = {k: v for k, v in row.items() if k not in meta}
        splits.append({"team": {"id": int(row["team_id"]), "name": row.get("team_name")}, "stat": stat})
    return splits


def bwar_year(table, year):
    """bWAR rows for one season from the all-years snapshot table, or None if absent."""
    if not db.has_rows(table):
        return None
    return _query_df(f'select * from "{table}" where year_ID = ?', [year])


def bwar_all(table):
    """Every row of the all-years bWAR snapshot table (used to sum career WAR), or None if absent."""
    if not db.has_rows(table):
        return None
    return _query_df(f'select * from "{table}"')
