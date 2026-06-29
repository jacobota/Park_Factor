# Park Factor — Target Architecture (launch)

> Launch-grade architecture for the data + backend layer after leaving AWS.
> Companion to `DATASWITCH.md` (the migration decision) and
> `.claude/plans/Park_Factor_Data_Switch_1.0.md` (full rationale).

## Headline

Supabase absorbs the entire transactional/social side (auth, users, posts, image hosting,
realtime feed). The only bespoke server we run is the **MLB stats service** — the unique,
defensible part of the app. The current Express/Node backend is largely **retired**.

- **Social / users / auth / images** → **Supabase** (Postgres + Auth + Storage + Realtime)
- **MLB stats** → **Flask stats API** backed by **DuckDB → MotherDuck**
- **AWS / DynamoDB** → **fully decommissioned** (after parity is verified — see Cutover)

## Diagram

```
┌───────────────────────────────────────────────────────────────────────┐
│                     CLIENT  —  React Native (Expo)                      │
│              (+ Next.js web shell later, same two backends)             │
└───────────────┬───────────────────────────────────┬───────────────────┘
                │                                     │
   supabase-js  │  (auth JWT, CRUD, realtime,         │  HTTPS + Supabase JWT
   SDK          │   Storage uploads)                  │  (read-only stats)
                ▼                                     ▼
┌──────────────────────────────────┐   ┌────────────────────────────────┐
│   SUPABASE  (managed BaaS)        │   │  STATS API  — Python / Flask    │
│  ─ Auth (JWT, OAuth, reset, email)│   │  ─ serves materialized tables   │
│  ─ Postgres (users, posts,        │   │    as JSON (sub-second)         │
│    follows, likes)  + RLS         │   │  ─ verifies Supabase JWT        │
│  ─ Storage (profile pics,         │   │           │                     │
│    post images)  + CDN            │   │           ▼                     │
│  ─ Realtime (the social feed)     │   │   ┌──────────────────────────┐  │
│  ─ Edge Functions (news proxy)    │   │   │ DuckDB  (self-host now)   │  │
└──────────────────────────────────┘   │   │   → MotherDuck (later)    │  │
                                        │   │  events + materialized    │  │
                                        │   │  tables (ratings, boards) │  │
                                        │   └─────────▲────────────────┘  │
                                        └─────────────┼──────────────────┘
                                                      │ nightly upsert + rebuild
                                        ┌─────────────┴──────────────────┐
                                        │  INGESTION JOB (Python, cron)   │
                                        │  pybaseball → Parquet → DuckDB  │
                                        │  Parquet durable copy → R2/S3   │
                                        └─────────────────────────────────┘
```

## Components

| Layer | Tech | Hosting | Role | Cost |
|---|---|---|---|---|
| Client | React Native (Expo) | EAS / app stores | UI; talks to Supabase + Stats API | — |
| Identity + social data | Supabase Auth + Postgres + RLS | Supabase (managed) | users, follows, likes, posts, auth | **$25/mo Pro** |
| Image hosting | Supabase Storage (+ CDN) | Supabase | profile pics, post images (URL stored in Postgres) | in the $25 (100 GB) |
| Realtime feed | Supabase Realtime | Supabase | "Baseball Twitter" live updates | in the $25 |
| Stats API | Python / Flask | 1 small VM (Fly.io/Railway/Render) | serves materialized MLB stats as JSON | ~$5–15/mo |
| Analytics store | DuckDB → MotherDuck | VM volume now → MD cloud later | events + ratings/leaderboards | $0 → comped MD |
| Object storage | Cloudflare R2 (or Supabase) | R2 | durable Parquet event store (zero egress) | ~$0–2/mo |
| Ingestion | Python + scheduler | Fly cron / GitHub Actions | nightly Statcast pull + rebuild | $0 |

**All-in launch cost: ~$30–40/mo**, effectively flat at this scale (Supabase Spend Cap ON guarantees
$25 ceiling for the BaaS side).

## Key data flows

**1. User posts with an image**
RN uploads the image to **Supabase Storage** → gets a CDN URL → inserts a `posts` row via
`supabase-js` (URL stored as a string). RLS enforces "verified users only." Realtime pushes it to
followers. *No custom backend code.*

**2. Loading a player's stats page**
RN → **Stats API** (`GET /players/:id`, Supabase JWT attached) → Flask reads pre-built
**materialized tables** (`player_game_agg`, `leaderboards`, `percentiles`) → JSON in <1s.
*No live pandas scraping.*

**3. Nightly ingestion**
Scheduler → Python pulls `statcast(yesterday)` → writes Parquet to R2 → **idempotent upsert** into
DuckDB → rebuilds materialized tables → (optionally caches leaderboard JSON). Safe to re-run.

## Why this shape

- **Own only what's differentiated.** Generic, security-sensitive plumbing (auth, CRUD, uploads,
  realtime) is Supabase's responsibility; the stats engine is the only bespoke server.
- **Right tool per workload.** Transactional social data on Postgres; analytical MLB data on a
  columnar engine.
- **Clean scaling story.** Self-hosted DuckDB is stateful (one VM) today. Flipping to **MotherDuck**
  moves state to the cloud → the Stats API becomes **stateless** → run multiple replicas for HA. No
  rewrite.
- **One identity system.** Supabase JWT authorizes both the social side (RLS) and the stats API
  (Flask verifies the same token). Retires hand-rolled bcrypt/JWT.

## Migration mapping (from today's AWS stack)

| Today (AWS) | Launch target | Effort |
|---|---|---|
| DynamoDB users/posts | Supabase Postgres + RLS | swap DAOs → Supabase (or client-direct) |
| In-house JWT + bcrypt | Supabase Auth | moderate — re-point signup/login; migrate hashes or force reset |
| `profilePicture` / `postImage` strings | Supabase Storage + URL string | drop-in if already URLs; build upload flow if base64 |
| Express proxy + Flask | **Flask stats only** (Express retired; news → Edge Function) | backend shrinks |
| Flask re-scrapes per request | DuckDB materialized tables | the Phase-A data work already planned |

## Decision: Supabase-direct vs API gateway

Recommended: **(a) RN client talks straight to Supabase** for all social/auth/image work (least
code, RLS for security). Keep a thin gateway only if later requirements demand server-side control.

## Cutover / rollout order

1. **Stand up Supabase** (project, schema, RLS, Storage buckets) — AWS stays live.
2. **Wire the client/backend to Supabase** in parallel; test against it.
3. **Migrate data** DynamoDB → Postgres (`Scan → transform → insert`), verify parity.
4. **Cut over** traffic to Supabase.
5. **Decommission AWS** only after parity confirmed (delete tables, remove creds from `.env`).
6. **Stats side** proceeds independently: DuckDB events store → ingestion → materialization → repoint
   Flask (see `DATASWITCH.md`).

> Do **not** stop AWS before step 5 — DynamoDB still backs live users/posts until cutover.
