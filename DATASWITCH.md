# DATASWITCH — Moving Park Factor off AWS

> Summary of the data-layer migration decision (2026-06-29).
> Full rationale/interview: `.claude/plans/let-s-have-an-interview-structured-hippo.md`.

## The switch, in one line

**Leave AWS entirely**, splitting the data layer by workload:

| Workload | From (AWS) | To | Why |
|---|---|---|---|
| **MLB stats** (Statcast events, ratings, leaderboards, Action+) | none persisted (Flask re-scrapes + pandas per request) | **DuckDB** self-hosted → **MotherDuck** | analytical / batch-ingest / read-heavy — DuckDB's home turf |
| **Users, auth, following, posts/social feed** | **DynamoDB** (`ParkFactor-Users`, `ParkFactor-VerifiedPosts`) | **Supabase** (Postgres + Auth + Storage + Realtime) | transactional, concurrent point reads/writes |
| **Profile pics + post images** | string fields in DynamoDB | **Supabase Storage** (buckets, CDN URL stored in Postgres) | media belongs in object storage, not the DB |

## Why two stores, not one

- DuckDB/MotherDuck is a **columnar analytical (OLAP) engine** — perfect for group-bys over
  millions of pitch-level Statcast rows, wrong for many small concurrent per-user writes.
- DuckDB is **single-writer**; user/auth/social writes belong on a real transactional (OLTP) store.
- This split is an **engine-fit** decision, not a cost one — it holds even though MotherDuck access
  is comped. "Everything in MotherDuck" is **not** advised; "everything off AWS" **is**.

## MLB stats: DuckDB now, MotherDuck later

- **Start self-hosted DuckDB** (open source, free) in the Flask `stats_api`; raw events as
  **Parquet** (e.g. Cloudflare R2). ~$0–10/mo, no lock-in.
- **Promote to MotherDuck** with a one-line `md:` connection-string change when wanted (a contact
  can comp the account). $250/mo Business is the growth endgame.
- **Pricing note:** MotherDuck has no cheap middle tier anymore — Free Lite (10 GB / 10 compute-hr
  per month) then a $250/mo jump. Hence self-host first.

### Cost-effective patterns
- Partition events by date; prune to the range each query needs.
- **Materialize** nightly into small tables (`player_game_agg`, `leaderboards`, `percentiles`); the
  API serves those — keep the mobile hot path **off raw events**.
- Idempotent daily upsert (delete-partition-then-insert / `MERGE`) so backfills are safe.
- Let the warehouse scale to zero between nightly runs.

### Compute placement
- **Python (pybaseball/pandas)** stays the **ingestion** layer (fetch → Parquet → load).
- **Push aggregations into DuckDB SQL** (replacing the pandas group-bys in `savant_sources.py`).
- **Rating + Action+ engines stay as code** (`calculateActionPlusV2()`, rating spec) — DuckDB
  feeds them aggregated inputs.

## Users/posts: DynamoDB → Postgres

- **Decision (locked): Supabase** (Postgres + Auth + Storage + Realtime — one provider replaces
  DynamoDB *and* image hosting).
- **Phasing:** **start on Free** (accounts + auth + text posts; images deferred). Move to **Pro
  $25/mo** (Spend Cap ON → hard $25 ceiling) when we add images + launch — Pro also removes Free's
  1-week inactivity pause.
- **Images → Supabase Storage** (buckets `avatars`, `post-images`), **deferred**; Postgres stores
  the CDN **URL** string only. No base64 in the DB — it would burn the scarce DB-size quota instead
  of the roomier file-storage quota. Schema split: `0001_initial_schema.sql` (live) +
  `0002_storage.sql` (apply when images ship).
- Tiny dataset (2 tables) → one-shot `Scan → JSON → load` migration, then drop AWS creds from
  `.env`.

## Mobile note

DuckDB/MotherDuck is the **backend warehouse**, not an on-device DB. React Native keeps calling the
API (Express → compute layer); "local DuckDB" = the dev/ingestion machine.

## Migration steps

1. Stand up the **DuckDB events store** (schema from `Park_Factor_Data_Architecture_1.0.md` §2;
   `statcast_events`, partitioned by date, Parquet-backed).
2. **Ingestion job (Python):** historical backfill + nightly `statcast(yesterday)` idempotent upsert
   (schema validation + backfill count check).
3. **Materialization layer (DuckDB SQL):** nightly `player_game_agg` / `leaderboards` / `percentiles`.
4. **Repoint Flask routes** to read materialized tables (keep current JSON shapes → Express/RN
   unaffected).
5. **Migrate OLTP off DynamoDB** to Postgres/Turso (swap the two DAOs; drop AWS creds).
6. **(Optional) Promote to MotherDuck:** flip the connection string to `md:`, validate on Free Lite.

## Verification

- Leaderboard endpoint returns **sub-second** from materialized tables (vs. cold pandas scrape).
- Nightly ingest is **idempotent** (re-run = identical row counts); backfill counts match.
- Stats batch fits Free Lite (10 GB / 10 compute-hr) before any paid commitment.
- Auth/profile/post flows pass on the new OLTP store; **DynamoDB decommissioned only after parity**.
- RN golden path unchanged (Express JSON contracts preserved).
