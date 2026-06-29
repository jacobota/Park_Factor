#!/usr/bin/env bash
#
# start-dev.sh — launch the full Park Factor dev stack with one command.
#
#   1. Express API      (backend/app.js)        :3000
#   2. Flask stats API  (stats_api/app.py)      :5000   <- proxied to by Express; easy to forget
#   3. Expo / Metro     (mobile, expo start)    :8081   <- runs in the foreground
#
# The two backends run in the background with their output tee'd to .dev-logs/.
# Expo owns the terminal so its interactive menu (i = iOS, r = reload, etc.) keeps working.
# Quitting Expo (Ctrl+C / q) tears the whole stack down and frees the ports.
#
# Pass --clear (or -c) to start Metro with a wiped bundler cache — use this when a code change
# isn't showing up on the device (stale Fast Refresh bundle).

set -uo pipefail

# --- args -------------------------------------------------------------------
EXPO_CLEAR=""
for arg in "$@"; do
  case "$arg" in
    -c|--clear) EXPO_CLEAR="-c" ;;
    *) echo "Unknown option: $arg (supported: --clear/-c)"; exit 1 ;;
  esac
done

# Repo root is one level up — this script lives in scripts/.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$ROOT/.dev-logs"
mkdir -p "$LOG_DIR"

EXPRESS_PORT=3000
FLASK_PORT=5000
EXPO_PORT=8081

# --- helpers ----------------------------------------------------------------

free_port() {
  local port="$1"
  local pids
  pids="$(lsof -tiTCP:"$port" -sTCP:LISTEN 2>/dev/null || true)"
  if [ -n "$pids" ]; then
    echo "  • port $port busy (pids: $pids) — clearing"
    # shellcheck disable=SC2086
    kill $pids 2>/dev/null || true
    sleep 1
    pids="$(lsof -tiTCP:"$port" -sTCP:LISTEN 2>/dev/null || true)"
    # shellcheck disable=SC2086
    [ -n "$pids" ] && kill -9 $pids 2>/dev/null || true
  fi
}

PIDS=()
cleanup() {
  echo ""
  echo "Shutting down dev stack…"
  for pid in "${PIDS[@]:-}"; do
    [ -n "$pid" ] && kill "$pid" 2>/dev/null || true
  done
  # Belt-and-suspenders: Flask's debug reloader spawns a child, so also free by port.
  free_port "$EXPRESS_PORT"
  free_port "$FLASK_PORT"
  free_port "$EXPO_PORT"
  echo "Done."
}
trap cleanup EXIT INT TERM

# --- pre-flight: free the ports --------------------------------------------

echo "Freeing dev ports…"
free_port "$EXPRESS_PORT"
free_port "$FLASK_PORT"
free_port "$EXPO_PORT"

# --- locate the Flask interpreter ------------------------------------------

if [ -x "$ROOT/stats_api/venv/bin/python" ]; then
  FLASK_PY="$ROOT/stats_api/venv/bin/python"
else
  echo "⚠️  stats_api/venv not found — falling back to system python3."
  echo "   Run ./scripts/setup.sh once to create it (and build the DuckDB stats store)."
  FLASK_PY="$(command -v python3)"
fi

# --- start the backends (background) ---------------------------------------

echo "Starting Express API  → http://localhost:$EXPRESS_PORT   (log: .dev-logs/express.log)"
( cd "$ROOT/backend" && node app.js ) >"$LOG_DIR/express.log" 2>&1 &
PIDS+=($!)

echo "Starting Flask stats  → http://localhost:$FLASK_PORT   (log: .dev-logs/flask.log)"
( cd "$ROOT/stats_api" && "$FLASK_PY" app.py ) >"$LOG_DIR/flask.log" 2>&1 &
PIDS+=($!)

# Wait for each backend to bind. Flask warms a player-lookup table first, so it can
# take ~15s — poll rather than checking once.
wait_for_port() {
  local name="$1" port="$2" timeout="$3"
  local logname; logname="$(echo "$name" | tr '[:upper:]' '[:lower:]')"
  local i=0
  while [ "$i" -lt "$timeout" ]; do
    if lsof -tiTCP:"$port" -sTCP:LISTEN >/dev/null 2>&1; then
      echo "  ✓ $name listening on :$port"
      return 0
    fi
    sleep 1; i=$((i + 1))
  done
  echo "  ✗ $name not listening on :$port after ${timeout}s — check .dev-logs/$logname.log"
  return 1
}

wait_for_port "Express" "$EXPRESS_PORT" 15
wait_for_port "Flask"   "$FLASK_PORT"   30

# --- start Expo (foreground) -----------------------------------------------

echo ""
if [ -n "$EXPO_CLEAR" ]; then
  echo "Starting Expo (Metro) with a cleared bundler cache — press Ctrl+C here to stop everything."
else
  echo "Starting Expo (Metro) — press Ctrl+C here to stop everything.  (re-run with --clear if a change won't show)"
fi
echo "──────────────────────────────────────────────────────────────"
cd "$ROOT/mobile" && npx expo start $EXPO_CLEAR
