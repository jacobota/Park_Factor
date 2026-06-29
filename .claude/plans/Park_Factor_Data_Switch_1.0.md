# DuckDB / MotherDuck for Park Factor — Architecture Decision Memo

## Context

Park Factor's data layer has two very different workloads that are currently
mashed onto AWS + an unpersisted Python service:

1. **OLTP (transactional):** user accounts, auth (JWT+bcrypt), following, likes, and the
   "verified posts" social feed. Today: **DynamoDB** (`ParkFactor-Users`,
   `ParkFactor-VerifiedPosts`), region `us-west-1`, pure key-value GET/PUT/UPDATE/DELETE plus
   full-table `Scan` for the feed. Accessed via clean DAO classes (`backend/src/repository/*DAO.js`).
2. **OLAP (analytical):** the actual product — millions of pitch-level Statcast events →
   per-game aggregation → leaderboards, percentiles, Player Rating, Action+. Today: **no
   persistent store at all**. `stats_api` (Flask + pybaseball) re-scrapes ~900 rows from bbref +
   Savant on every request and does the math in **pandas**, behind a 30-min in-memory cache
   (`stats_api/routes/savant_sources.py`). The `Park_Factor_Data_Architecture_1.0.md` plan already
   calls for "a real store (not in-memory), partitioned by date, with a daily cron doing
   incremental upserts" — i.e. it's begging for an analytical database.

The user wants to (a) get off AWS, (b) cut/predict cost, (c) simplify, and (d) get real
analytical performance, by moving to **DuckDB locally + MotherDuck hosted**, with a nightly
ingestion job that historically backfills then appends each prior day into one continually growing
event store. This memo records the recommended architecture and the things to know before doing it.

## The core finding: this is the right tool for the OLAP half, the wrong tool for the OLTP half

- **OLAP → DuckDB/MotherDuck is a slam-dunk.** Columnar + vectorized; reads/writes Parquet
  natively; group-bys over millions of rows in milliseconds; same engine/client whether embedded
  (`duckdb.connect('events.duckdb')`) or hosted (`duckdb.connect('md:parkfactor')`). It directly
  replaces the "re-scrape + pandas groupby + 30-min cache" pattern with a persisted store and
  sub-second SQL, and it's the store the data-architecture plan already assumes.
- **OLTP → DuckDB/MotherDuck is the wrong tool.** DuckDB is **single-writer** (one process holds
  the write lock) and is built for batch analytics, not many small concurrent per-user
  reads/writes (registration, profile edits, follows, likes, posting). MotherDuck's managed layer
  helps concurrency but it is still an **analytical warehouse, not a transactional app DB**. Putting
  auth + social writes there fights the tool and will not scale.

**Therefore: "everything in MotherDuck" is not advised — but "everything off AWS" absolutely is.**
Recommended split (two stores, both off AWS):

| Workload | Store | Why |
|---|---|---|
| Statcast events + ratings/leaderboards | **DuckDB (local/self-host) → MotherDuck** | analytical, batch-ingest, read-heavy |
| Users / auth / following / social feed | **Small OLTP store** (Postgres: Neon/Supabase free tier; or Turso/libSQL) | transactional, concurrent, point reads/writes |

The existing **DAO pattern makes this cheap**: only `UsersDAO.js` and `VerifiedPostsDAO.js` change;
services/controllers/auth (`token.js`) are store-agnostic. The DynamoDB data is tiny (2 tables,
light schema) — a one-shot `Scan → JSON → load` migration, low risk.

> **Note: free MotherDuck does not remove the need for a separate OLTP store.** Keeping
> users/auth/social on Postgres/Turso is an *engine-fit* decision (single-writer, analytical engine
> vs. concurrent transactional writes), not a cost one — it holds regardless of MotherDuck pricing.
> Default: **Postgres (Neon/Supabase free)**; **Turso/libSQL** is the lighter-ops alternative if the
> social schema stays simple. Both ~$0 at this scale, so choose on ergonomics.

> If the user insists on literally one store for everything, DuckDB *can* hold the user/post tables
> for a tiny beta, but flag it as a known dead-end that must be split out before real concurrency.

## Mobile clarification (important)

"DuckDB for the mobile app" does **not** mean DuckDB on the phone. We never ship a multi-GB event
store to a device. The React Native app keeps calling the API (Express → compute layer); DuckDB/
MotherDuck is the **backend warehouse**, and "local DuckDB" means the dev/ingestion machine, not
the handset.

## The cost reality (verified June 2026 — pricing changed)

MotherDuck restructured pricing in early 2026. There is **no longer a ~$25/mo middle tier**:

- **Lite (Free): $0** — 10 GB storage, **10 Pulse compute-hours/month**, 3 users, 1-day snapshots.
- **Business: $250/mo** + usage — storage $0.04/GB-mo; compute $0.60/hr (Pulse) → $36/hr (Giga),
  billed per second; 99.9% SLA, 90-day restore.
- **Enterprise:** custom.

Implication for a cost-sensitive small launch: the Free tier is generous *if you stay inside it*,
but the next step up is a **steep $250/mo cliff**. Binding constraints on Free:
- **Storage (10 GB):** a season of league-wide Statcast events is ~700k pitches × ~90 cols ≈
  a few hundred MB–~1–2 GB as compressed Parquet. A few seasons fit; a "continually growing,
  keep-everything-forever" store will eventually blow past 10 GB.
- **Compute (10 hr/mo ≈ 20 min/day):** fine for a tight nightly batch + materialize; *not* fine if
  the mobile hot path queries raw events synchronously on every request.

### Recommendation: start cheaper than MotherDuck, design so MotherDuck is a one-line upgrade
Because DuckDB (open source) and MotherDuck share the same engine and client, design for DuckDB and
treat MotherDuck as a drop-in `md:` connection string later. Most cost-effective ladder:

1. **Now (≈ $0–10/mo):** plain **DuckDB embedded in the Flask service** on a cheap VM
   (Fly.io / Railway / small droplet), raw events as **Parquet on Cloudflare R2** (no egress fees).
   Heavy historical backfill compute runs locally/on the VM for free. This captures ~95% of the
   analytical win at near-zero marginal cost.
2. **When ops burden / sharing / scale-to-zero justify it:** point the same code at **MotherDuck**
   (`md:`). The user has a contact at MotherDuck who can comp an account, so this step is
   **de-risked** — the upgrade is a one-line connection-string change with no near-term cost.
3. **If this grows big:** $250/mo Business is the accepted endgame.

> Decision (confirmed): **self-host DuckDB first**, MotherDuck as the comped drop-in upgrade later.

### Cost-effective code patterns (these matter because MD bills compute)
- **Partition + prune:** events partitioned by `game_date`/season; queries touch only needed ranges.
- **Materialize, don't recompute live:** nightly job rolls events → small `player_game_agg`,
  `leaderboards`, `ratings` tables. The API serves those compact tables (or cached JSON), so the
  warehouse spins up for ingest/recompute only and **scales to zero** the rest of the day.
- **Keep the mobile hot path off raw events** entirely — serve materialized results.
- **Idempotent daily upsert:** delete-partition-then-insert (or `MERGE`) keyed by pitch/play id so
  reruns/backfills are safe (matches the plan's "idempotent upsert" requirement).
- **Dev against a local `.duckdb` file** (free); reserve hosted compute for the shared store.

## Compute placement (answering "keep Python or push to SQL")

Hybrid — and the existing code decides the split:
- **Python (pybaseball/pandas) stays the ingestion layer:** fetch `statcast(date)`, write Parquet,
  load into DuckDB/MD. Pandas is fine for *fetch + light shaping*, bad as the aggregation engine.
- **Push aggregation into DuckDB SQL:** leaderboards, per-game rollups, percentile ranks, arsenal
  group-bys (currently pandas in `savant_sources.py`) become SQL — far faster and cheaper. This is
  where the performance win lives.
- **Rating / Action+ engines stay as code:** `calculateActionPlusV2()` (JS) and the Player Rating
  spec consume *aggregated inputs* DuckDB produces; DuckDB feeds them, it doesn't replace them.

## Risks / things to know before committing

- **Vendor maturity / lock-in:** MotherDuck is far younger than AWS; weigh for "production-serious."
  Mitigated by the fact that local DuckDB + Parquet is the portable fallback (no lock-in).
- **Concurrency model:** single-writer DuckDB; great for batch-ingest + read-heavy serving, wrong
  for transactional write fanout → keep OLTP elsewhere.
- **Cold start:** scale-to-zero means duckling wake latency → serve materialized results, don't
  block mobile requests on a waking warehouse.
- **Pricing cliff:** no $25 tier anymore; plan storage/compute to live on Free or budget for $250.
- **Statcast scraping ToS / data licensing:** orthogonal but real; unchanged by this move.

## Proposed execution path (phased, when we implement)

1. **Stand up the events store (local DuckDB first).** Schema = the event columns in
   `Park_Factor_Data_Architecture_1.0.md` §2; one canonical `statcast_events` table, partitioned by
   date, Parquet-backed.
2. **Ingestion job (Python).** Historical backfill (loop seasons → Parquet → load) + nightly
   `statcast(yesterday)` idempotent upsert. Schema validation + backfill count check
   (per CLAUDE.md pipeline expectations). Schedule via cron / the VM scheduler.
3. **Materialization layer (DuckDB SQL).** Nightly build `player_game_agg`, `leaderboards`,
   `percentiles`; rewrite `savant_sources.py` aggregations to query these instead of re-scraping.
4. **Repoint Flask routes** to read materialized tables (sub-second), retaining current JSON shapes
   so Express/RN are unaffected.
5. **Migrate OLTP off DynamoDB** to Postgres/Turso: swap `UsersDAO.js` + `VerifiedPostsDAO.js`,
   one-shot data export/import, drop AWS creds from `.env`.
6. **(Optional) Promote to MotherDuck:** change the connection string to `md:`, validate on Free
   Lite, monitor storage/compute against the 10 GB / 10 hr caps.

## Verification (when implemented)

- **Performance:** a leaderboard endpoint that takes seconds (cold pandas scrape) returns
  sub-second from materialized tables; per-game windowing (Judge 2-HR day) computes from events.
- **Ingestion:** nightly run is idempotent (re-running a date yields identical row counts);
  backfill count matches expected pitches/season.
- **Cost:** confirm the nightly batch fits the Free Lite 10 compute-hr / 10 GB envelope before any
  paid commitment; verify warehouse scales to zero between runs.
- **OLTP migration:** registration/login/profile/post flows pass against the new store; DynamoDB
  decommissioned only after parity confirmed.
- **No regression:** RN app golden path unchanged (Express JSON contracts preserved).

## Sources
- [MotherDuck Pricing](https://motherduck.com/product/pricing/)
- [MotherDuck Pricing Docs](https://motherduck.com/docs/about-motherduck/billing/pricing/)
- [MotherDuck 2026 pricing change writeup](https://tasrieit.com/blog/motherduck-pricing-change-2026)
- [Where to host DuckDB now](https://layerbase.com/blog/motherduck-pricing-changes-2026)
