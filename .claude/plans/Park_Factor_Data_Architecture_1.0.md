# Park Factor — Data Architecture & pybaseball Capability Map (v1.0)

> Companion to `Park_Factor_Plan_1.0.md` (product scope) and `CLAUDE.md` (distilled summary).
> This doc is the **source of truth for where every number comes from** and how the data layer
> must be built to support the 4 Big Rocks.
> Status: drafted 2026-06-24 from live pybaseball probing against the running `stats_api` service.

---

## 0. Why this doc exists

The original `stats_api` (Flask + pybaseball) leaned on **FanGraphs** for nearly all stats
(`batting_stats`, `pitching_stats`, `team_batting`, `team_pitching`, `fielding_stats`). As of
mid-2026 FanGraphs sits behind a **Cloudflare JavaScript challenge** and returns **HTTP 403** to
every non-browser client, including pybaseball. This silently emptied the Stats, Team, and Player
screens (the app surfaced `Error accessing 'https://www.fangraphs.com/leaders-legacy.aspx'.
Received status code 403`).

This is not a transient outage — it is a deliberate anti-scraping posture. The data layer must be
re-architected to **not depend on FanGraphs**. The good news: the metrics that actually matter for
Park Factor's process-oriented identity originate at **Baseball Savant (Statcast)**, which is not
blocked, and FanGraphs merely re-displayed them.

---

## 1. Source inventory (probed live, 2026-06-24)

| Source | pybaseball entry points | Status | Notes |
|---|---|---|---|
| **Baseball Savant — event level** | `statcast`, `statcast_batter`, `statcast_pitcher`, `statcast_single_game` | ✅ working | One row per pitch. The foundation for everything. |
| **Baseball Savant — leaderboards** | `statcast_*_exitvelo_barrels`, `*_expected_stats`, `*_percentile_ranks`, `*_arsenal_stats`, `outs_above_average`, `sprint_speed`, `*_pitch_movement` | ✅ working | Season aggregates keyed by `player_id` (MLBAM). |
| **Baseball-Reference** | `batting_stats_bref`, `pitching_stats_bref`, `bwar_bat`, `bwar_pitch`, `schedule_and_record`, `standings` | ✅ working | Standard counting/rate stats + **WAR** (`bwar_*`, off/def/rep splits). |
| **Chadwick / MLBAM** | `chadwick_register`, `playerid_lookup`, `playerid_reverse_lookup` | ✅ working | ID crosswalk (FG ↔ MLBAM ↔ bbref). |
| **FanGraphs** | `batting_stats`, `pitching_stats`, `team_*`, `fg_*` | ❌ **403 (Cloudflare)** | Do not use. Costs only *derived* metrics (wRC+, FIP, SIERA, Stuff+, FG-BsR). |
| **Catcher framing** | `statcast_catcher_framing` | ❌ **broken** | pybaseball parser bug (all years). Derive from event `called_strike`+`zone` instead. |
| **Salaries / contracts** | `salaries`, `lahman`, `download_lahman` | ❌ **broken** | Lahman zip 404s. **No working pybaseball contract source** — external data required. |
| **`team_batting_bref` et al.** | `team_batting_bref` | ❌ unreliable | IndexError on scrape. Aggregate team stats from player frames instead. |

### Metric recovery: FanGraphs → Savant/bbref
- **Recoverable (Statcast-native):** xwOBA, xBA, xSLG, wOBA, xERA, EV, maxEV, Barrel%, HardHit%,
  K%, BB%, Whiff%, Chase%, OAA, sprint speed, per-pitch run value & arsenal.
- **Lost (FanGraphs-proprietary, no equivalent):** wRC+, FanGraphs WAR, FIP, SIERA, Stuff+/Location+/
  Pitching+, FanGraphs BsR/wSB, WPA, FG plate-discipline (Swing%/Z-Swing%/Contact%).
- **Replaced in spirit:** WAR ← `bwar_bat`/`bwar_pitch`; FIP/SIERA ← xERA; Swing%/Contact% ←
  Whiff%/Chase%; FG-BsR ← event-derived baserunning run value + sprint speed.

---

## 2. The core architectural decision: an event-level store

Every Big Rock except the brand-only Park Factor stat is best served by **one canonical table**:
raw Statcast pitch events. Build it once, compute everything from it.

```
                    ┌─────────────────────────────┐
   daily cron  ───► │  statcast(date) → raw pitch  │  (Savant, unblocked)
                    │  events  [one row / pitch]   │
                    └──────────────┬──────────────┘
                                   │  (idempotent upsert, keyed by play/pitch id)
                    ┌──────────────▼──────────────┐
                    │   events store (raw)         │   game_pk, game_date, batter, pitcher,
                    │                              │   events, description, zone, pitch_type,
                    │                              │   launch_speed/angle, release_speed,
                    │                              │   estimated_woba_using_speedangle,
                    │                              │   delta_run_exp, delta_home_win_exp
                    └──────────────┬──────────────┘
          ┌────────────────────────┼────────────────────────┐
          ▼                        ▼                        ▼
  per-game player          season/rolling          Action+ per-pitch
  aggregates               leaderboards & %iles     grades
  (xwOBA, RV, whiff%,      (rebuild w/o FanGraphs)  (existing engine)
   chase%, OAA, BsR)
          │
          ▼
  Player Rating engine (6.5 reset → per-game rating → time-weighted windows)
          │
          ▼
  Team Rating rollup (PA / batters-faced weighted)
```

**Why event-level, not season leaderboards:** the Player Rating is defined as *process-oriented
and per-game* (reset to 6.5 each game, move on events). Season aggregates literally cannot express
that — only pitch/PA-level data with `delta_run_exp` and `estimated_woba_using_speedangle` can.
Proven: grouping `statcast_batter` by `game_date` yields per-game xwOBA + summed run value directly.

### Key event columns (confirmed present)
`game_date`, `game_pk`, `batter`, `pitcher`, `events`, `description`, `type`, `zone`,
`pitch_type`, `release_speed`, `launch_speed`, `launch_angle`, `bb_type`,
`estimated_woba_using_speedangle`, `estimated_ba_using_speedangle`, `woba_value`,
`delta_run_exp` (run value of the event), `delta_home_win_exp` (leverage/WPA-like).

---

## 3. Per-Rock data design

### Rock 1 — Player Rating (centerpiece)
**Position players** (spec: `~/Downloads/park_factor_rating_v3.docx.md`):
- xwOBA stream ← event `estimated_woba_using_speedangle` per PA.
- Run-value stream ← event `delta_run_exp` summed per game.
- OAA (defense) ← `statcast_outs_above_average` (season baseline) + event-derived per-game range plays.
- BsR (baserunning) ← custom: event `delta_run_exp` on SB/CS/extra-base advancement + `sprint_speed`.
- Framing (catchers) ← **derive** from event `called_strike` rate by `zone`/count (since
  `statcast_catcher_framing` is broken).
- Engine: per game, start 6.5, apply weighted process deltas → game rating. Rolling windows =
  time-weighted average of completed game ratings.

**Pitchers** (separate model, spec TBD — largest open modeling task):
- Whiff% ← swinging strikes / swings (event `description`). Proven.
- Chase% ← swings at `zone >= 11` (out-of-zone). Proven.
- Called-strike/zone command ← `called_strike` rate, `zone` distribution.
- Soft-contact ← `launch_speed`, `estimated_woba_using_speedangle` allowed.
- Action+ as one input (Rock 2).

**Verification (from CLAUDE.md):** Judge 2-HR/4-for-5 day → ≥9.0; 0-for-4/3K → ≤5.0;
high-Stuff/low-result start > low-Stuff/high-result start.

### Rock 2 — Action+
- Existing `calculateActionPlusV2()` engine, output verbatim on arsenal cards.
- Pitch inputs ← event `pfx_x/pfx_z`, `release_speed`, `release_spin_rate`; plus
  `statcast_pitcher_arsenal_stats` for per-pitch run value / whiff% / put-away.

### Rock 3 — Market Value
- **$/WAR side:** WAR ← `bwar_bat` / `bwar_pitch` (off/def/rep splits, by player-year-team). ✅
- **Comparable-player buckets:** position × age × WAR-tier × service-time ← `chadwick_register` /
  `people` + WAR + statcast age/position.
- **Contracts (the gap):** no working pybaseball source. **Action required** — ingest an external
  contract dataset (Spotrac / Cot's scrape, or a maintained CSV). This is the only Big-Rock input
  pybaseball cannot supply.
- **Verification:** AAV within ±20% for Soto/Ohtani/Skenes/Acuña/Judge; 3 visible comps per card.

### Rock 4 — Park Factor (the stat)
- Brand only in v1. **No data, no ingestion.**

---

## 4. Stopgap vs. foundation

- **Stopgap (DONE — 2026-06-24):** `stats_api/routes/savant_sources.py` rebuilds the 4 leaderboards
  and the 4 Flask routes are wired to it (`hitters`, `pitchers`, `team_stats` ×2), verified 200 end
  to end through Express. Sources:
  - **Player boards** ← `batting_stats_bref` / `pitching_stats_bref` (standard, qual-gated) joined to
    Savant `*_exitvelo_barrels` + `*_expected_stats` (xwOBA, xERA, Barrel%, HardHit%, EV). Team
    identity emitted as the **FanGraphs abbr**, disambiguating shared cities via bbref `Lev` league.
  - **Team boards** ← **MLB Stats API** (`statsapi.mlb.com/.../teams/stats`) — exact official totals
    with proper team ids (bbref city aggregation was abandoned: it merged the two LA/NY/Chicago teams).
  - Advanced metrics lead the board order (frontend `leaderboardConfig.ts` reordered); FanGraphs-only
    keys (wRC+, WAR, BsR, SIERA, vFA, GB%) stay listed but no-op until that source returns.
- **Foundation (the overhaul):** the event-level store in §2. The stopgap leaderboards should later
  be recomputed from the event store so there is a single source of truth.

---

## 5. Build sequence (proposed)

1. **Stopgap leaderboards** — finish wiring `savant_sources.py`, verify 4 routes return data.
2. **Event ingestion** — daily `statcast(date)` pull → idempotent upsert into events store;
   schema validation; backfill with count verification (CLAUDE.md pipeline expectations).
3. **Per-game aggregation layer** — materialize per-player-per-game process metrics from events.
4. **Player Rating (position)** — implement rating-v3 spec; replay-test Judge/0-fer cases;
   unit-test time-weighted window math.
5. **Player Rating (pitcher)** — draft the pitcher process model, then implement.
6. **Team Rating rollup** — PA / batters-faced weighting.
7. **Market Value** — WAR via `bwar_*` + external contract ingestion + comp regression.
8. Recompute leaderboards/percentiles from the event store (retire stopgap scrapes).

---

## 6. Open decisions / risks

- **ID crosswalk discipline:** events are MLBAM-keyed; bbref is bbref-keyed; legacy code used
  FanGraphs IDs. Standardize on MLBAM as the primary key, map others via `chadwick_register`.
- **Statcast volume:** a full season of league-wide events is millions of rows — needs a real store
  (not in-memory), partitioned by date, with the daily cron doing incremental upserts.
- **Contract data licensing/sourcing** for Market Value — unresolved, external.
- **Framing model** must be custom (pybaseball's is broken) — scope it or defer framing as a
  rating input for catchers in v1.
- **Qualifier math** for rate-stat leaderboards is currently approximated from max games played;
  revisit once the event store gives exact team-games.
```
