# Park Factor — Planning Interview & v1 Plan

> Interviewer: a pro dev shop that builds baseball-analytics apps.
> Interviewee: the Park Factor product team (Nick + baseball-mind partner).
> Mode: plan mode — interview complete, plan ready for ExitPlanMode.

---

## Context

The product team has shipped a working **Action+ v2.1** pitch-grading engine (`calculateActionPlusV2()`) and prototyped most of an iOS-first analytics app called **Park Factor** in HTML/Chart.js. The app is positioned as "Baseball Savant done better, more simply, more opinionated":

- FotMob-inspired dark UI, condensed display type, card layouts, true-black bg, mint #2ED47A "good" accent
- 5-tab global bottom nav: **News** (a.k.a. "The Concourse") · **Games** · **Stats** · **Following** · **More**
- iOS-first (Expo), web parity later
- Infographic-heavy modules (roster construction, spend efficiency, dev pipelines) flagged as a v1 priority area
- Team colors reserved for team-identity visuals only; continuous red→yellow→green percentile gradients (no buckets)

The interview existed because four "Big Rocks" had no definition: Action+ surface, Player Rating, Market Value, Park Factor (the stat). Rounds 1-3 closed all four plus key scope-discipline calls.

---

## Interview Summary

### Round 1 — The Big Rocks
- **Q1 / Park Factor (the stat):** Brand name only. **No v1 calculation.** −1 Big Rock from scope.
- **Q2 / Action+ surface:** v1 = **per-pitch grades on arsenal cards** (engine output verbatim). Pitcher rollup (weighted avg per pitcher) is the logged v2 direction.
- **Q3 / Player Rating:** **The centerpiece engagement metric.** FotMob-style **0.0-10.0**, everyone starts each game at **6.5**, moves on process-oriented events, rolling windows (game / series / week / month / season), team rollup at same windows.
- **Q4 / Market Value:** **Combined $/WAR + comparable-player regression**, anchored on similar-bucket players + recent contracts/trades. Opaque presentation. Visual reference: fotmob.com/players/1105912/riccardo-calafiori. Framing: "What would this player be worth on the open market today?"

### Round 2 — Player Rating mechanics + scope discipline
- **Q5 / Rating drivers:** **All process streams layered** (xwOBA + OAA + BsR + framing, position-aware). Detailed weights live in `~/Downloads/park_factor_rating_v3.docx.md` (position players only — **read at implementation start**).
- **Q6 / Rating reset across windows:** **Per-game reset to 6.5; rollups are time-weighted averages of completed game ratings.** Player cards lead with last-game rating ("8.4 last night") + rolling context below.
- **Q7 / Infographics:** **v1 priority — 1-2 modules in launch.** Recommended pair: roster construction (FA / trade / homegrown) + spend efficiency. Player-dev pipeline = v2.
- **Q8 / Stats tab depth:** **Advanced primary + traditional secondary**, user explicitly wants to **heavily lean into the advanced metrics.** Traditional collapsed under expand affordance.

### Round 3 — Closing the Player Rating system
- **Q9 / Pitcher Rating:** **Separate event model** (not an Action+ feed), driven by **advanced process metrics**. Action+ can be one input, but the model is its own thing — a parallel to the position-player rating-v3 doc, still to be drafted.
- **Q10 / Team Rating rollup:** **Weighted by playing time (PA / batters faced).** Starters dominate; bench gets partial credit; mop-up reliever can't outweigh a 9-IP starter.

---

## v1 Scope Recommendation

### Phase A — Foundation
1. **App scaffold** — Expo (React Native), 5-tab bottom nav, theme tokens (black bg, mint accent, condensed display + clean data fonts), iOS-frame dev fidelity
2. **Statcast / MLB API ingestion pipeline** — daily cron, schema-validated, idempotent backfill, into Supabase (Postgres) per existing CLAUDE.md tech stack
3. **Player Rating engine — position players** — implement the rating-v3 doc spec (events → deltas, per-PA quality of contact, BsR, OAA, framing for catchers). Per-game reset to 6.5. Time-weighted rolling rollups.
4. **Player Rating engine — pitchers** — separate process-driven model (per-pitch Action+ feed + whiff% + chase induced + command/zone metrics + soft-contact rate). Spec to be drafted in parallel to rating-v3.
5. **Team Rating rollup** — PA-weighted (hitters) + BF-weighted (pitchers) aggregate of player ratings per game; same weighted rolling windows as players.

### Phase B — Core pages
6. **Following / Teams** (most fleshed-out flow in mockups): favorite team page, diamond lineup view, stat-toggle diamond (Player Rating / fWAR / OAA / BsR / wRC+), team logo "on the mound" → pitching-staff drill-in, hitter Damage heatmap, pitch-shape grid + side-by-side trajectory module, team browser/search
7. **Player profile** — port the Logan Gilbert HTML prototype to React Native (header, bio grid, season snapshot, 10-axis radar, Pitchability, Arsenal, Movement Profile scatter, Usage% bar, Pitch Shapes table, percentile bars, Games tab, Career tab)
8. **Games tab** — scoreboard list, tap → diamond lineup with **day's stats alongside season stats** (not yet designed; resolve in implementation)
9. **Stats tab** — Hitting / Pitching split. Advanced-led leaderboard cards: 🔥 Trending (wRC+ last 50 PA), wRC+, xERA, Stuff+ per pitch type, OAA, framing runs, BsR, K%, BB%. Traditional collapsed under expand affordance per card.

### Phase C — Differentiating modules
10. **Action+ arsenal card** — wire the existing engine into the player page's Arsenal module (per-pitch grade as built; no new aggregation)
11. **Market Value module** — FotMob Calafiori-style port. Comparable-player bucketing (position × age × WAR-tier × service-time), recent-contract anchor, opaque presentation. Headline AAV + 1Y/3Y/Max range toggle + trend line.
12. **Roster Construction infographic** — team page module. FA / trade / homegrown ring + per-position-group stacked bar + roster table grouped by acquisition source. Inputs from Baseball Reference transactions + Spotrac.
13. **Spend Efficiency infographic** — team page module. $/WAR by acquisition source, league percentile context.

### Phase D — Social + onboarding
14. **Onboarding** — favorite team selection at first launch
15. **Profile screens** — own + others' (own = avatar, title badge, Profile module, Following list with hitter/pitcher/team stat lines; others' = verified badge, Follow button, Overview / Posts tabs)
16. **Community feed ("Baseball Twitter")** — News + Community sub-tabs under News, clickable @mentions route to player pages
17. **Comparison tools** — team-vs-team (Head-to-Head, Overview, Hitting), player-vs-player (Traits, Hitting); team-color-coded "winning" pill

### Polish layer (continuous)
- **Framer Motion** — Player Rating change pop on result reveal, gauge sweep on Action+, smooth leaderboard reorders
- **Continuous gradient ratings** — red → yellow → green from raw value, no discrete buckets
- **Per-page color identity** — single color per pitch/player used across every visual on that page (legend learned once)
- **Monogram + initials placeholders** — keep through v1; defer logo/photo licensing

### Explicitly out of v1
- **Park Factor (the stat)** — brand only in v1
- **Action+ pitcher rollup** — logged v2 direction
- **Player-development pipeline infographic** — v2
- **Real photo/logo licensing** — monograms hold the line for v1
- **Hot Stove / The Vault / Podcast / Fantasy Predictor** — More-tab stretches, not v1
- **Smart-default-by-user-tier Stats tab** — over-engineered for v1
- **Live in-game pitch shape viz** — stretch idea per brief, not v1

### Open implementation-phase decisions (not interview-level)
These don't block plan approval — call them during implementation:

- **App code home** (recommendation: monorepo with `packages/engine` reusing existing Action+ code + `apps/mobile` Expo app + `apps/web` Next.js shell. Lets engine and app evolve independently while sharing types.)
- **Cross-linking** — bottom-nav Stats tab leader names should route to that entity's player/team Stats sub-tab (matches the brief's intuition; default everything else to entity Overview)
- **Roster groupings** for Pitchers + Catchers in the team Roster tab (brief flagged Infielders + Outfielders only as defined)
- **Standings tab content** (brief flagged the placeholder — real list: GB, L10, streak, run differential)
- **"Top Pitchers" vs "Top Starters" duplicate card** in Games tab — collapse into one card
- **Diamond view reconciliation** — Games-tab diamond and Team-page mound-tap drill-in are the same component reused (confirm in implementation)

---

## Critical Files & Reuse

### Reuse from existing repo
- **`calculateActionPlusV2()`** — entry point for per-pitch Action+ grades; powers arsenal card module
- **GBM JSON artifacts** (xwoba, rv100, whiff heads) — model files, byte-identical post v2.2 retrain
- **Zod input schemas** — `.finite()` refinement pattern, validation guards (per v2.2 bulletproofing sprint)
- **Scout scripts** (`scripts/detmers-*.ts`) — pattern for integration test harnesses
- **Theme tokens** — black bg, mint #2ED47A, iOS systemGray scales already documented in root CLAUDE.md Part 4

### External references (READ DURING IMPLEMENTATION)
- **`~/Downloads/park_factor_rating_v3.docx.md`** — position-player rating-event spec, weights, deltas. **Source of truth for Phase A.3.**
- **fotmob.com/players/1105912/riccardo-calafiori** — Market Value module visual reference
- **HTML/Chart.js prototypes** (location TBD — confirm whether in this repo or elsewhere): Logan Gilbert player page, Padres team page, Dodgers diamond view, comparison screens, market value chart, global bottom nav. Port targets for Phase B.

### New code to build
- **Player Rating engine** (position + pitcher modules, share rollup infrastructure)
- **Team Rating rollup** (PA / BF-weighted aggregator)
- **Statcast + MLB API ingestion** (daily cron, idempotent backfill)
- **Comparable-player engine** for Market Value (bucketing + recent-contract anchor)
- **Expo app shell** + per-page React Native screens
- **Infographic components** for roster construction + spend efficiency

---

## Verification Plan (end-to-end)

### Player Rating — position players
- **Unit tests:** event → rating-delta table, sourced directly from rating-v3 doc
- **Integration:** replay a known game (e.g., Judge 2-HR / 4-for-5 day) and assert ending rating ≥ 9.0; replay an 0-for-4 / 3 K day and assert ending rating ≤ 5.0
- **Window math:** unit-test time-weighted rollup across a synthetic 30-game window; verify last-7-day rating differs from season rating in the expected direction

### Player Rating — pitchers
- **Unit tests:** per-pitch process metric → rating-delta table (TBD spec)
- **Integration:** replay a Skenes high-Stuff+/low-result start and a high-result/low-Stuff+ start; verify the high-process game scores higher even if the result is identical (this proves "process-oriented")

### Team Rating
- **Unit test:** 9-IP starter + 5 mop-up batters faced — verify starter's weight dominates the team-pitching contribution
- **Sanity test:** over a month sample of completed games, winning team's team-rating exceeds losing team's > 70% of the time

### Market Value
- **Hand-check:** model AAV for 5 marquee contracts (Soto, Ohtani, Skenes, Acuña, Judge) — must land within ±20% of actual
- **Comp surfacing:** every Market Value card surfaces 3 visible comparable players + their actual recent contracts

### App build
- **iOS simulator + Expo dev client** for golden-path flows: favorite team → team page → diamond → tap mound → pitching staff → tap pitcher → player profile → Action+ arsenal card
- **Manual on physical iPhone** before any release
- **Detox** for end-to-end nav coverage

### Data pipeline
- **Daily ingestion CI check** (alert if rows ingested < expected for the date)
- **Schema validation** on Statcast / MLB API responses
- **Backfill verification:** ingest a known historical date and assert event counts match known totals

---

## Memory items to save (immediately after ExitPlanMode)

Plan mode blocks memory writes. Save these the moment we exit (user explicitly requested #1; others are durable product decisions):

1. **project / pitcher-rollup-future-action-plus** — v1 = per-pitch Action+; pitcher rollup is the logged v2 direction (user-requested log)
2. **project / player-rating-system-design** — App centerpiece. 0.0-10.0, 6.5 baseline, FotMob-style, layered process streams, per-game reset + time-weighted rollups, multi-window + team rollup. Position-player weights live in `~/Downloads/park_factor_rating_v3.docx.md`
3. **project / pitcher-rating-separate-model** — Pitcher rating is a separate process-driven event model, not an Action+ feed. Spec TBD; parallel to the rating-v3 position-player doc
4. **project / team-rating-pa-weighted** — Team rating rollup is weighted by playing time (PA / BF), not unweighted mean
5. **project / market-value-fotmob-style** — Combined $/WAR + comparable-player regression. Opaque. Calafiori page (fotmob.com/players/1105912/riccardo-calafiori) as visual reference. Framing: "open market today?"
6. **project / park-factor-brand-not-stat** — "Park Factor" is the app's brand only; no Park Factor calculation in v1. Drops one Big Rock
7. **project / stats-tab-advanced-lean** — Advanced metrics dominate the Stats tab; traditional present but collapsed/secondary. User wants heavy advanced lean
8. **project / infographics-v1-priority** — Roster construction (FA/trade/homegrown) + spend efficiency are the two v1 infographic modules. Player-dev pipeline = v2
9. **reference / rating-v3-spec-doc** — `~/Downloads/park_factor_rating_v3.docx.md`. Preliminary position-player rating-event spec. Read at implementation start of Phase A.3

---

## Recommended immediate next steps (post plan approval)

1. **Save the 9 memory items** (~5 minutes, scripted)
2. **Read `~/Downloads/park_factor_rating_v3.docx.md` end-to-end** before any Phase A.3 code
3. **Draft the pitcher-rating spec** (parallel to rating-v3 doc) — this is the largest single piece of unresolved modeling work
4. **Decide app-code home** — recommend monorepo (`packages/engine` + `apps/mobile` + `apps/web`)
5. **Locate the HTML/Chart.js prototypes** — confirm whether they live in this repo, sibling repo, or elsewhere; they're the ported source for Phase B player + team pages
6. **Start Phase A.1** — Expo scaffold with the 5-tab bottom nav and theme tokens, on a feature branch
