#!/usr/bin/env bash
#
# backfill-stats.sh — one-time historical load of the DuckDB stats store.
#
# Snapshots every season from the earliest covered year (2008 for bbref, 2015 for Savant) through
# the current season into stats_api/data/parkfactor.duckdb. Run this ONCE after cloning — the store
# is gitignored and rebuildable, so a fresh checkout has no data until you run this.
#
# Idempotent: each season is delete-then-insert and pybaseball's on-disk cache is enabled, so it's
# safe to re-run or resume a half-finished backfill. Expect this to take a while (many seasons ×
# several sources, scraped live the first time).
#
#   ./scripts/backfill-stats.sh                 # 2008 -> current season
#   ./scripts/backfill-stats.sh --start 2018    # narrower range
#   ./scripts/backfill-stats.sh --end 2024      # stop before the current season
#
# Targets MotherDuck instead of the local file if PARKFACTOR_DUCKDB is set, e.g.:
#   PARKFACTOR_DUCKDB=md:parkfactor ./scripts/backfill-stats.sh

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ -x "$ROOT/stats_api/venv/bin/python" ]; then
  PY="$ROOT/stats_api/venv/bin/python"
else
  echo "⚠️  stats_api/venv not found — falling back to system python3."
  echo "   Create it first: cd stats_api && python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt"
  PY="$(command -v python3)"
fi

cd "$ROOT/stats_api"
exec "$PY" -m store.ingest backfill "$@"
