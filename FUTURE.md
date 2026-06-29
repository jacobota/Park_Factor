# Park Factor — Future Architecture (Proposal)

> **Status: mixed.** The **auth + social layer is now being implemented on Supabase**
> (Postgres + Auth + Storage) — DynamoDB is being retired. See `DATASWITCH.md`, `ARCHITECTURE.md`,
> and `docs/SUPABASE_SETUP.md`. The **stats track** below (MotherDuck/DuckDB ingestion) remains a
> proposal — not built yet; `stats_api/` still runs Flask + PyBaseball.
> See `CLAUDE.md` for product scope and `.claude/plans/Park_Factor_Plan_1.0.md` for the full plan.
>
> ⚠️ **Pre-launch checklist lives at the bottom** (#email-confirmation) — re-enable email confirmation.

## TL;DR

- **Two data stores, split by workload:**
  - **MotherDuck / DuckDB** → all baseball *analytics* data (stats, ratings, leaderboards, Statcast)
  - **Postgres** (optionally via Supabase) → *app* data (user accounts, auth, following, social feed)
- **Drop DynamoDB** — wrong tool for an analytics-heavy app.
- **Separate fetching from serving** — PyBaseball moves out of the request path into a scheduled
  ingestion job; the serving API reads from our own tables.
- **Backend language:** keep **Node/TypeScript** for the serving API, keep **Python** only for the
  ingestion job. Polyglot but minimal.

---

## Why move off the current architecture

Today every request to `stats_api/` triggers live PyBaseball scrapes (FanGraphs / Statcast /
Baseball Reference) and filters the result in pandas in memory. Concretely, a single player's stat
line pulls **three entire league-wide datasets** and keeps one row (`hitters.py` →
`get_hitter_stats_this_season`); leaderboards re-pull and re-sort the whole league per request
(`team_stats.py`). There are 40+ `pb.*` calls across the routes, almost all "fetch everything, keep
one slice."

Problems this causes:

| Problem | Fix with MotherDuck/DuckDB |
|---|---|
| Redundant full-league fetches to return one row, every request | Ingest once into tables; read only what's needed |
| Slow, latency-bound on external scrapes (seconds/request) | Columnar reads in milliseconds, no external round-trip on hot path |
| Fragile — scrapes break/rate-limit/change format (the silent `try/except → None` pattern, Ohtani/Sandoval special-cases) | Scrape failures happen once in a controlled job, not in front of users |
| No history — only "current season" snapshots | We own row-level history (required for ratings + rolling windows) |
| Analytics hand-rolled in Python loops (sorting, percentiles) | Native SQL: `ORDER BY`, `percent_rank()`, window functions, joins |

**The deepest reason:** the plan's core features — per-game rating resets, time-weighted rolling
windows, percentile color gradients, comparable-player buckets — all require *stored, queryable,
historical* data. PyBaseball-on-demand gives season snapshots with nothing to compute over.
MotherDuck/DuckDB is the OLAP store those features need.

---

## Why MotherDuck specifically

- **Right shape:** DuckDB is a columnar OLAP engine — exactly the leaderboard/percentile/aggregation
  workload this app is. Often *better than Postgres* for the heavy crunching.
- **Local-first:** DuckDB is embeddable (`pip install duckdb`, or a Node client). Point it at
  Statcast Parquet/CSV and iterate with zero infrastructure — matches "figure things out locally
  first." Promote to MotherDuck cloud (sharing/scale) later with the same SQL.
- **Low lock-in:** DuckDB is open source. Trial expiry or wanting out = keep running the same SQL on
  embedded/self-hosted DuckDB. Soft floor, not a rewrite. (A free MotherDuck trial is available to
  pilot the cloud layer.)

**Why not put everything on MotherDuck:** it's analytical, not transactional. User accounts, auth,
following, and a write-heavy social feed are OLTP — many small concurrent per-user writes, sessions,
row updates. That belongs on Postgres. Don't run login/social on a warehouse.

---

## The two-store split

| Layer | Store | Holds |
|---|---|---|
| **Baseball data** (analytics) | **MotherDuck / DuckDB** | Statcast ingestion, Player/Team Ratings, Action+ output, leaderboards, percentiles, Market Value comps |
| **App data** (transactional) | **Postgres** (or Supabase) | User accounts, auth, following/favorites, community feed/posts |

**The seam:** MLB player/team IDs (mlbam / FanGraphs id) are the shared key. Postgres stores
"user X follows player 660271"; MotherDuck holds 660271's stats. The app layer stitches them —
**no cross-database joins**, and don't duplicate entity data across both.

**Plain Postgres vs. Supabase:** both are Postgres. Supabase bundles managed auth + instant
REST/realtime APIs + storage on top, saving boilerplate (we need accounts + following anyway).
Lean Supabase, but it's a "later" decision that doesn't change the split.

---

## Structure: separate fetching from serving

```
            ┌─ INGESTION (offline, scheduled — Python + PyBaseball) ─┐
            │  scrape FanGraphs/Statcast/BBRef  (nightly cron)       │
            │            ▼                                           │
            │   raw Parquet  →  DuckDB / MotherDuck (typed tables)   │
            └───────────────────────────────────────────────────────┘
                                   │
            ┌─ SERVING (online, per request — Node/TypeScript) ──────┐
   RN  ───► │  API  ──►  MotherDuck (SQL fast reads)                 │
            │     └──►   Postgres (users/auth/social)                │
            └───────────────────────────────────────────────────────┘
```

1. **Ingestion job (Python):** reuse the existing `pb.*` calls, but run them **once nightly**, not
   per request. Land as Parquet → load into MotherDuck tables. The existing cleanup logic
   (`replace_nan_with_none`, bio/position normalization) becomes transform steps.
2. **MotherDuck/DuckDB:** per-player route becomes `SELECT ... WHERE mlbam_id = ?`; leaderboards
   become `ORDER BY wrc_plus DESC LIMIT 5`. Percentiles, rolling windows, rating math run as SQL.
3. **Postgres:** users/auth/following/social.

What changes in existing code: PyBaseball leaves the request path; the defensive `try/except → None`
serving pattern largely disappears (reads hit our own tables). `NewsController.js` (NewsAPI) is
genuinely realtime/external and **stays a live call** — not everything belongs in the warehouse.

---

## Backend language

The React Native frontend doesn't force a backend language, but it tips it:

- **Serving API → Node/TypeScript.** RN is TypeScript, the existing Action+ engine is TypeScript,
  and the plan's `packages/engine` reuses it. Node/TS lets us share types across
  frontend → engine → API. Reuses the existing Express backend rather than starting over.
- **Ingestion → Python.** PyBaseball is Python; no reason to rewrite it. Python survives as the
  *ingestion* language only, not on the request path.
- Both stores have first-class Node *and* Python clients, so the data layer doesn't constrain this.

**Net: polyglot but minimal — TypeScript for serving, Python for scraping.**

---

## Live stats (a later, additive layer)

PyBaseball's aggregated sources (FanGraphs) refresh ~nightly; Statcast/Savant is same-day but laggy.
Neither is truly live. The live source is the **MLB Stats API** (`statsapi.mlb.com`, free, public) —
the feed that powers Gameday, updating pitch-by-pitch in near-real-time:

- `GET /api/v1/schedule?sportId=1&date=YYYY-MM-DD` → active games + status
- `GET /api/v1.1/game/{gamePk}/feed/live` → live play-by-play (events, score, baserunners,
  pitch velo/movement, exit velo/launch angle); `diffPatch` streams deltas
- Python wrapper: `MLB-StatsAPI` (`import statsapi`)

**Tiered freshness model:**

```
Tier 1 — LIVE (seconds)       MLB Stats API live feed  → hot store → push to app
Tier 2 — NEAR-LIVE (minutes)  Baseball Savant pitch data (reconcile during/after game)
Tier 3 — AUTHORITATIVE (nightly)  FanGraphs + corrected Statcast → MotherDuck (source of truth)
```

This maps directly onto the Games tab's "day's stats alongside season stats" (Tier 1 next to Tier 3).

**App-specific payoff:** the Player Rating is *event*-driven, and the live feed delivers events live,
so the rating can update **during** the game (the FotMob live-rating feel). Modeled metrics
(xwOBA, Stuff+) can't be instant from public data — but we get the raw inputs (EV, launch angle,
pitch velo) live, and we own the engine, so we can compute *provisional* values live and reconcile
to Savant overnight.

**Where live data lands:** it's small, streaming, write-heavy — OLTP/cache shape, **not** analytical.
Don't write it straight to MotherDuck (DuckDB is poor at high-frequency small writes). Instead:

```
live feed → poller service → Postgres/Redis "hot/today" tables → served live
                                       │ nightly reconcile
                                       ▼
                                  MotherDuck (authoritative history)
```

A small poller loops over in-progress games (~10–15s cadence), upserts into the hot store, and
pushes to the app (own websocket / Supabase realtime / client polling). Overnight, the authoritative
batch overwrites the day's provisional numbers.

---

## Recommended sequencing

1. **Local-first kickoff:** embedded DuckDB on Statcast files; re-point one route at it to feel the
   difference — no cloud needed yet.
2. **Build the nightly batch** (Python ingestion → MotherDuck) + Node serving API. This powers ~95%
   of the app; "yesterday's stats" is fine for most surfaces.
3. **Stand up Postgres/Supabase** for accounts/auth/social when building those features; migrate the
   DynamoDB DAOs (`UsersDAO`, `VerifiedPostsDAO`) + JWT/bcrypt auth.
4. **Add the live layer** (MLB Stats API → poller → hot store) as scoped Games-tab / live-rating
   polish — additive, not a re-architecture.

## Open questions

- Plain Postgres vs. Supabase (auth + instant APIs vs. full control)
- Hot store for live data: Postgres table vs. Redis cache
- Serving API: extend existing Express backend vs. fresh Node service in the monorepo `apps/`
- How aggressively to compute own (provisional) modeled metrics live vs. wait for Savant reconcile

## Image uploads (deferred from Swift translation)

Swift uploaded directly to S3 with client-side AWS creds (NOT ported). Rebuild via backend
pre-signed URLs. Existing buckets (region `us-west-1`):
- profile pics: `parkfactor-profilepictures`
- post images: `parkfactor-postimages`

⚠️ Rotate the AWS access key/secret that were committed in the old `Env.plist`.
RN gaps to restore once uploads exist: profile-picture change, post/edit image attach.

---

## Email confirmation (re-enable before launch)  ⚠️ launch blocker {#email-confirmation}

During Supabase setup we **turned OFF** Authentication → "Confirm email" so signup logs in
immediately in dev. **Turn it back ON before launch** so accounts must verify a real email (blocks
throwaway/bot signups and typo'd addresses).

**To re-enable:** Supabase → Authentication → Providers → Email → enable **Confirm email**. Then set
up **custom SMTP** (Authentication → Emails → SMTP) so mail comes from your own domain (deliverability
+ branding) instead of Supabase's shared sender.

**Code impact:** once ON, `supabase.auth.signUp()` no longer returns an active session until the user
clicks the link. The current Signup → auto-login → onboarding flow
(`mobile/src/screens/auth/SignupScreen.tsx` → `OnboardingTeams`) must change to a "check your email"
state, and onboarding should run **after** the first confirmed login. Plan this before flipping it.

### Professional confirmation email template
Paste into Supabase → Authentication → **Emails → Confirm signup** (HTML). Supabase substitutes
`{{ .ConfirmationURL }}`. Branding: true-black bg, mint `#2ED47A` accent.

```html
<!DOCTYPE html>
<html lang="en">
  <body style="margin:0;padding:0;background:#000000;font-family:-apple-system,Segoe UI,Roboto,Helvetica,Arial,sans-serif;">
    <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#000000;padding:32px 0;">
      <tr><td align="center">
        <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="max-width:480px;background:#0B0B0B;border:1px solid #1A1A1A;border-radius:16px;overflow:hidden;">
          <tr><td style="padding:32px 32px 8px 32px;">
            <p style="margin:0;font-size:14px;letter-spacing:2px;text-transform:uppercase;color:#2ED47A;font-weight:700;">Park Factor</p>
          </td></tr>
          <tr><td style="padding:8px 32px 0 32px;">
            <h1 style="margin:0;font-size:26px;line-height:1.2;color:#FFFFFF;font-weight:800;">Confirm your email</h1>
            <p style="margin:16px 0 0 0;font-size:15px;line-height:1.6;color:#B0B0B0;">
              Welcome to Park Factor — baseball analytics, done better. Tap below to verify your email
              and start following your team.
            </p>
          </td></tr>
          <tr><td style="padding:28px 32px;">
            <a href="{{ .ConfirmationURL }}" style="display:inline-block;background:#2ED47A;color:#000000;font-size:16px;font-weight:700;text-decoration:none;padding:14px 28px;border-radius:10px;">Confirm my email</a>
          </td></tr>
          <tr><td style="padding:0 32px 32px 32px;">
            <p style="margin:0;font-size:13px;line-height:1.6;color:#777777;">
              If the button doesn't work, paste this link into your browser:<br />
              <a href="{{ .ConfirmationURL }}" style="color:#2ED47A;word-break:break-all;">{{ .ConfirmationURL }}</a>
            </p>
            <p style="margin:20px 0 0 0;font-size:12px;line-height:1.6;color:#555555;">
              Didn't create a Park Factor account? You can safely ignore this email.
            </p>
          </td></tr>
        </table>
        <p style="margin:20px 0 0 0;font-size:11px;color:#444444;">© Park Factor</p>
      </td></tr>
    </table>
  </body>
</html>
```

> Mirror this style for the **Reset password** and **Magic link** templates when those ship.
