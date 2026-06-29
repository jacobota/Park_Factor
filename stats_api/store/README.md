# Stats store (DuckDB) — Phase 1: season snapshots

The Flask routes used to scrape bbref + Baseball Savant + the MLB Stats API **live on every
request** (multiple seconds each, behind a 30-min in-process cache that dies on restart). This
package snapshots those season frames into a local **DuckDB** file once a night, so requests read
from disk in **~0.1s** instead.

> Local-first by design. The same code points at **MotherDuck** later by setting
> `PARKFACTOR_DUCKDB=md:parkfactor` — no other change. See
> `.claude/plans/Park_Factor_Data_Switch_1.0.md`.

## Layout

| file | role |
|---|---|
| `db.py` | DuckDB connection + idempotent write helpers (`replace_season`, `replace_table`) |
| `ingest.py` | `backfill` / `nightly` CLI — fetches pybaseball/MLB-API frames and snapshots them |
| `read.py` | read helpers used by the API; return `None` when a season is absent so callers fall back to a **live** pull |

The DB file lives at `stats_api/data/parkfactor.duckdb` (gitignored — rebuild it, don't commit it).
Override the location with the `PARKFACTOR_DUCKDB` env var.

## Tables (all season-partitioned except bWAR)

`bbref_batting`, `bbref_pitching`, `savant_batter_exitvelo`, `savant_pitcher_exitvelo`,
`savant_batter_expected`, `savant_pitcher_expected`, `savant_oaa`, `savant_batter_percentiles`,
`savant_pitcher_percentiles`, `savant_pitch_movement`, `mlb_team_stats` (`group` = hitting/pitching),
and the all-years `bwar_bat` / `bwar_pitch`.

Frames are stored **raw**; per-route transforms (Lev filter, name de-mojibake, qualifier math,
team-id mapping) stay in `routes/savant_sources.py`.

### Season coverage (per-source floors — see `EARLIEST_SEASON` / `*_ERA_START` in `ingest.py`)

| Source | Earliest | Why |
|---|---|---|
| `bbref_*` | **2008** | pybaseball's `*_stats_bref` is hard-capped at 2008 ("Year must be 2008 or later"). Covers every currently-active player's full career (Trout debuted 2011). |
| `savant_*` | **2015** | Statcast didn't exist before 2015. `savant_oaa` is 2016 (OAA's own start). |
| `mlb_team_stats` | **2015** | leaderboard-only, no career value — kept Statcast-era. |
| `bwar_bat` / `bwar_pitch` | **all years (1871+)** | one all-years frame per call; WAR components only, not full stat lines. |

Pre-2008 *full stat lines* would need another source (Lahman is currently broken in pybaseball, or
a custom bbref scrape) — out of scope for now.

## Operating it

Run from `stats_api/` with the venv active:

```bash
# one-time historical load. Default start = earliest covered season (2008); each source only
# pulls seasons it actually has (Savant skips pre-2015). Idempotent + resumable.
./venv/bin/python -m store.ingest backfill

# narrower range
./venv/bin/python -m store.ingest backfill --start 2020

# nightly refresh of the current season (what cron runs)
./venv/bin/python -m store.ingest nightly
```

Each season is **delete-then-insert**, so re-running converges to the same rows. pybaseball's
on-disk cache is enabled, so re-runs and the backfill don't re-download frames they already have.

### Scheduling the nightly job

A laptop is asleep at 3am, so pick one:

- **launchd (macOS)** — a `StartCalendarInterval` agent running the `nightly` command. Only fires
  when the machine is awake; fine while this is local-only.
- **Hosted** — once the Flask service moves onto a small always-on VM (Fly.io / Railway), run
  `nightly` from that box's cron and point both at the same DuckDB file (or MotherDuck).

Until a scheduler is wired up, just run `nightly` by hand after games finish.

## What's NOT here yet (Phase 2)

Raw **pitch-event** data (`statcast(date)` → one row per pitch). That's the foundation for Player
Rating / per-game, is millions of rows, and the plan is to backfill ~the last 5 seasons when we
start it. Season snapshots (this package) do **not** depend on it.
