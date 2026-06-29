#!/usr/bin/env bash
#
# nightly-stats.sh — refresh the current season in the DuckDB stats store.
#
# Re-snapshots ONLY the current season (delete-then-insert) plus the all-years bWAR tables, so it's
# cheap: the immutable 2008..last-year rows are left untouched, today's numbers are brought current.
# Run this on a schedule (cron / launchd locally, or CI for a shared MotherDuck store) so the store
# tracks live games — backfill loads the current season once, this keeps it fresh thereafter.
#
#   ./scripts/nightly-stats.sh                  # refresh the current season
#   ./scripts/nightly-stats.sh --season 2024    # refresh one specific season
#
# Example crontab entry (3:30am daily), using the venv python so no activation is needed:
#   30 3 * * *  /path/to/Park_Factor/scripts/nightly-stats.sh >> /path/to/Park_Factor/.dev-logs/nightly.log 2>&1
#
# Targets MotherDuck instead of the local file if PARKFACTOR_DUCKDB is set, e.g.:
#   PARKFACTOR_DUCKDB=md:parkfactor ./scripts/nightly-stats.sh

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
exec "$PY" -m store.ingest nightly "$@"
