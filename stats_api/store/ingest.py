"""Nightly / backfill ingestion for the season-snapshot store.

Usage (from stats_api/, with the venv active):
    python -m store.ingest backfill                 # 2015 -> current season (one-time)
    python -m store.ingest backfill --start 2018    # narrower range
    python -m store.ingest nightly                  # refresh the current season only
    python -m store.ingest nightly --season 2025    # refresh one specific season

Idempotent: each season is delete-then-insert, so re-running (or resuming a half-finished
backfill) is safe and converges to the same rows. pybaseball's on-disk cache is enabled so
re-runs and the heavy backfill avoid re-downloading frames they already fetched.
"""

import argparse
import sys
import time

import requests
import pandas as pd
import pybaseball as pb

from . import db

pb.cache.enable()

# Per-source earliest season. Savant advanced frames only exist in the Statcast era (2015+).
# bbref standard stats go back further, but pybaseball's `*_stats_bref` is hard-capped at 2008
# ("Year must be 2008 or later") — which still covers every currently-active player's full career
# (e.g. Trout debuted 2011). Pre-2008 full stat lines would need another source (Lahman is broken;
# bWAR is the exception — it's already all-years, see ingest_bwar). Team leaderboards are
# leaderboard-only, no career value, so they stay Statcast-era.
STATCAST_ERA_START = 2015
BBREF_ERA_START = 2008
TEAM_STATS_START = 2015

# Season-partitioned sources: table name -> (loader(year) -> DataFrame, earliest season). Frames
# are stored RAW; per-route transforms (Lev filter, name de-mojibake, qualifier math) stay in the
# API layer.
SEASON_SOURCES = {
    "bbref_batting": (lambda y: pb.batting_stats_bref(y), BBREF_ERA_START),
    "bbref_pitching": (lambda y: pb.pitching_stats_bref(y), BBREF_ERA_START),
    "savant_batter_exitvelo": (lambda y: pb.statcast_batter_exitvelo_barrels(y), STATCAST_ERA_START),
    "savant_pitcher_exitvelo": (lambda y: pb.statcast_pitcher_exitvelo_barrels(y), STATCAST_ERA_START),
    "savant_batter_expected": (lambda y: pb.statcast_batter_expected_stats(y), STATCAST_ERA_START),
    "savant_pitcher_expected": (lambda y: pb.statcast_pitcher_expected_stats(y), STATCAST_ERA_START),
    "savant_oaa": (lambda y: pb.statcast_outs_above_average(y, "all"), STATCAST_ERA_START),
    "savant_batter_percentiles": (lambda y: pb.statcast_batter_percentile_ranks(y), STATCAST_ERA_START),
    "savant_pitcher_percentiles": (lambda y: pb.statcast_pitcher_percentile_ranks(y), STATCAST_ERA_START),
    "savant_pitch_movement": (lambda y: pb.statcast_pitcher_pitch_movement(y, minP=1, pitch_type="ALL"), STATCAST_ERA_START),
}

# Earliest season any source covers — the default start of a full backfill.
EARLIEST_SEASON = min(start for _, start in SEASON_SOURCES.values())


def _log(msg):
    print(f"[ingest] {msg}", flush=True)


def _fetch_team_stats(season):
    """Flat per-team season rows from the MLB Stats API (hitting + pitching), tagged with `group`."""
    rows = []
    for group in ("hitting", "pitching"):
        url = (
            f"https://statsapi.mlb.com/api/v1/teams/stats"
            f"?stats=season&group={group}&season={season}&sportIds=1"
        )
        try:
            splits = requests.get(url, timeout=20).json()["stats"][0]["splits"]
        except Exception as e:  # noqa: BLE001
            _log(f"  team stats {group} {season} failed: {e}")
            continue
        for sp in splits:
            row = {"group": group, "team_id": sp["team"]["id"], "team_name": sp["team"].get("name")}
            row.update(sp.get("stat", {}))
            rows.append(row)
    return pd.DataFrame(rows) if rows else None


def ingest_season(season, only=None):
    """Snapshot every season-partitioned source for one season. `only` limits to a subset of
    table names (used by tests / targeted refresh)."""
    con = db.connect()
    try:
        for table, (loader, min_season) in SEASON_SOURCES.items():
            if only and table not in only:
                continue
            if season < min_season:  # source has no data this far back (e.g. Savant pre-2015)
                continue
            t0 = time.time()
            try:
                df = loader(season)
            except Exception as e:  # noqa: BLE001
                _log(f"  {table} {season}: SKIP ({e})")
                continue
            if df is None or len(df) == 0:
                _log(f"  {table} {season}: empty, skipped")
                continue
            db.replace_season(con, table, df, season)
            _log(f"  {table} {season}: {len(df)} rows in {time.time() - t0:.1f}s")

        if (not only or "mlb_team_stats" in only) and season >= TEAM_STATS_START:
            team_df = _fetch_team_stats(season)
            if team_df is not None and len(team_df):
                db.replace_season(con, "mlb_team_stats", team_df, season)
                _log(f"  mlb_team_stats {season}: {len(team_df)} rows")
    finally:
        con.close()


def ingest_bwar():
    """bWAR comes as one all-years frame per call — snapshot whole tables (not season-partitioned)."""
    con = db.connect()
    try:
        for table, loader in (("bwar_bat", pb.bwar_bat), ("bwar_pitch", pb.bwar_pitch)):
            try:
                df = loader(return_all=True)
            except Exception as e:  # noqa: BLE001
                _log(f"  {table}: SKIP ({e})")
                continue
            db.replace_table(con, table, df)
            _log(f"  {table}: {len(df)} rows (all years)")
    finally:
        con.close()


def backfill(start, end):
    _log(f"backfill {start}..{end} -> {db.DB_PATH}")
    for season in range(start, end + 1):
        _log(f"season {season}")
        ingest_season(season)
    ingest_bwar()
    _log("backfill complete")


def nightly(season):
    _log(f"nightly refresh season {season} -> {db.DB_PATH}")
    ingest_season(season)
    ingest_bwar()  # WAR updates daily; cheap single frame
    _log("nightly complete")


def main(argv=None):
    parser = argparse.ArgumentParser(prog="store.ingest")
    sub = parser.add_subparsers(dest="cmd", required=True)

    p_back = sub.add_parser("backfill", help="one-time historical load")
    p_back.add_argument("--start", type=int, default=EARLIEST_SEASON,
                        help=f"defaults to earliest covered season ({EARLIEST_SEASON})")
    p_back.add_argument("--end", type=int, default=None, help="defaults to current season")

    p_night = sub.add_parser("nightly", help="refresh one season (default: current)")
    p_night.add_argument("--season", type=int, default=None)

    args = parser.parse_args(argv)
    current = pb.utils.most_recent_season()

    if args.cmd == "backfill":
        backfill(args.start, args.end or current)
    elif args.cmd == "nightly":
        nightly(args.season or current)
    return 0


if __name__ == "__main__":
    sys.exit(main())
