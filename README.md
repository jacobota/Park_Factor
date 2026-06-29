# Park Factor — MLB Analytics App

**Park Factor** is an iOS-first MLB analytics app — "Baseball Savant done better, more simply,
more opinionated." It pairs deep advanced metrics (xwOBA, Stuff+, OAA, framing, BsR, wRC+…) with
an opinionated, infographic-heavy, FotMob-inspired presentation: a true-black UI, continuous
red→yellow→green percentile gradients, and per-page color identity.

> **Status:** mid-migration. The app was ported from Swift/SwiftUI to **React Native (Expo)**, and
> the data layer was moved **off AWS** — user/auth/social now run on **Supabase**, and stats are
> served from a local **DuckDB** season-snapshot store. See `ARCHITECTURE.md` and `DATASWITCH.md`
> for the full picture, and `CLAUDE.md` for the product source of truth.

## The four "Big Rocks"

1. **Player Rating** — the centerpiece engagement metric. FotMob-style 0.0–10.0, process-oriented,
   per-game reset to 6.5 with time-weighted rolling windows. Separate models for hitters and pitchers.
2. **Action+** — per-pitch pitch-grading engine; grades surface verbatim on arsenal cards.
3. **Market Value** — `$/WAR` + comparable-player regression, presented opaquely ("what's this
   player worth on the open market today?").
4. **Park Factor (the stat)** — brand name only in v1; no calculation yet.

## Features

- **Player profiles** — radar, percentile bars, pitch arsenal w/ Action+ grades, movement scatter,
  spray charts, Games/Career tabs (ported from the Logan Gilbert prototype).
- **Teams / Following** — favorite-team page, stat-toggle lineup, pitching staff, schedule.
- **Stats** — advanced-metric-forward leaderboards (hitters, pitchers, teams) with traditional
  stats collapsed/secondary.
- **News & Community** — "The Concourse" league news feed (NewsAPI) plus a social feed
  (profiles, posts, likes) backed by Supabase.
- **Accounts** — sign up / log in, favorite team + player onboarding, profile management.

## Repo structure

```
Park_Factor/
├── mobile/        React Native (Expo) app — the client
├── backend/       Node.js / Express gateway — news + stats proxy to Flask  (:3000)
├── stats_api/     Python / Flask + PyBaseball stats service                (:5000)
│   └── store/     DuckDB season-snapshot store + ingest job (read.py / ingest.py / db.py)
├── supabase/      Postgres schema + RLS + Storage migrations (users/auth/social)
├── scripts/       start-dev.sh — one-command local dev stack
└── *.md           CLAUDE.md (product), ARCHITECTURE.md, DATASWITCH.md, FUTURE.md, .claude/plans/
```

## Tech stack

| Layer | Tech |
|-------|------|
| **Mobile** | TypeScript, React Native, Expo, React Navigation, React Query, react-native-svg |
| **Gateway API** | Node.js, Express (proxies stats to Flask, serves news) |
| **Stats service** | Python, Flask, PyBaseball; served from DuckDB with a live-scrape fallback |
| **Stats store** | DuckDB (local file → MotherDuck later) — season-snapshot tables |
| **OLTP / Auth / Storage** | Supabase (Postgres + Auth + Storage + RLS) |
| **External APIs** | NewsAPI (MLB news), Statcast / Baseball-Reference via PyBaseball |

## Getting started

### Prerequisites

- **Node.js** 18+ and **npm**
- **Python** 3.9+ (for the Flask stats service)
- **Expo** tooling (`npx expo`) + the **Expo Go** app or an iOS simulator
- A **Supabase** project (free tier is fine)

### 1. Configure environment

**`backend/.env`** (gitignored):
```
FLASK_URL = 'http://127.0.0.1:5000'
NEWS_API_KEY = 'your-newsapi-key'
```

**`mobile/.env`** (gitignored; `EXPO_PUBLIC_` prefix ships to the client bundle):
```
EXPO_PUBLIC_SUPABASE_URL=https://<project>.supabase.co
EXPO_PUBLIC_SUPABASE_ANON_KEY=<anon-key>
```
> The anon key is publishable by design — Row-Level Security (the policies in
> `supabase/migrations/`) is the actual security boundary. Never put the `service_role` key in the app.

### 2. Set up Supabase

Apply the migrations in `supabase/migrations/` (run via `supabase db push`, or paste each file
into the Supabase SQL editor in order). They create the `profiles` / `posts` / `post_likes`
schema, RLS policies, and Storage buckets.

### 3. Install dependencies

```bash
# Mobile
cd mobile && npm install

# Express gateway
cd ../backend && npm install

# Flask stats service
cd ../stats_api && python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt
```

### 4. Build the stats store (optional but recommended)

The Flask service reads from a local DuckDB file and falls back to live scraping when a season is
missing. To pre-populate it:

```bash
./scripts/backfill-stats.sh     # 2008 → current season (one-time; idempotent)
./scripts/nightly-stats.sh      # refresh just the current season + bWAR (schedule this)
```
The store lives at `stats_api/data/parkfactor.duckdb` (gitignored; rebuildable). Both scripts
target MotherDuck instead of the local file when `PARKFACTOR_DUCKDB` is set to an `md:` connection
string — see "Stats data lifecycle" below.

## Stats data lifecycle

The DuckDB store is **gitignored and rebuildable**, so it never travels through git. How a teammate
(or production) stays current:

1. **Fresh clone** → run `./scripts/backfill-stats.sh` once. It loads every season 2008→present,
   including the current one, so you're up to date as of that run. (You don't strictly *need* this:
   the Flask layer falls back to live scraping for any season missing from the store — backfill just
   makes it fast.)
2. **Staying current** → `./scripts/nightly-stats.sh` only re-snapshots the **current season**
   (delete-then-insert) plus the all-years bWAR tables. The immutable 2008..last-year rows are
   untouched, so it's cheap and effectively just updates today's numbers. Run it on a schedule
   (local `cron`/`launchd`), not by hand every day.

**Moving to MotherDuck** turns this from a per-machine chore into one shared cloud store:

- Set `PARKFACTOR_DUCKDB=md:parkfactor` (plus a `motherduck_token`). The API and the ingest scripts
  now read/write that one cloud database — no local file, no per-teammate backfill.
- MotherDuck is the **storage destination, not a job runner**: the nightly work is a Python
  pybaseball scrape, so it still needs compute somewhere always-on — *not* a laptop. The natural fit
  is a **scheduled GitHub Actions workflow** (cron) that `pip install`s and runs
  `PARKFACTOR_DUCKDB=md:parkfactor ./scripts/nightly-stats.sh` with the token as a secret. Any cron
  host works too (Render/Railway/Fly cron, Lambda+EventBridge, Cloud Run Job + Scheduler).
- Because ingest is idempotent and season-scoped, the nightly run just overwrites the current
  season's rows in MotherDuck; past seasons accumulate untouched.

### 5. Run the dev stack

```bash
./scripts/start-dev.sh            # Express :3000 + Flask :5000 + Expo/Metro :8081
./scripts/start-dev.sh --clear    # same, with a wiped Metro bundler cache
```
Expo owns the terminal (press `i` for iOS sim, `r` to reload); Ctrl+C tears the whole stack down.
Backend logs are tee'd to `.dev-logs/`. To run pieces individually: `node backend/app.js`,
`python stats_api/app.py`, and `cd mobile && npx expo start`.

## Notes

- **PyBaseball is locally patched** — `statcast_pitcher_active_spin` /
  `statcast_pitcher_pitch_movement` are exported from its `__init__.py`, and `player_bios` returns
  an extended dict (Position/Bats/Throws/Born/Origin). If you reinstall the library from PyPI,
  re-apply these.
- **Single-writer DuckDB** — the ingest job opens the store read-write; the API opens short-lived
  read-only connections. Reads fall back to a live scrape during the brief nightly-ingest window.
