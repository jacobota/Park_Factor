# Park Factor

> Source of truth for product scope and decisions: `.claude/plans/Park_Factor_Plan_1.0.md`.
> Source of truth for **data architecture & where every stat comes from**: `.claude/plans/Park_Factor_Data_Architecture_1.0.md`
> (FanGraphs is Cloudflare-blocked; the data layer is built on Statcast event-level data + bbref).
> This file is the distilled summary — read the plans for full rationale.

## What it is

**Park Factor** is an iOS-first MLB analytics app — "Baseball Savant done better, more
simply, more opinionated." It pairs deep advanced metrics with an opinionated, infographic-heavy
presentation and a FotMob-inspired UI.

**Frontend direction: React Native (Expo).** We are migrating off the current Swift/SwiftUI
implementation — treat React Native + Expo as the target stack for all new app work.

### Design language
- FotMob-inspired dark UI: **true-black background**, condensed display type + clean data fonts, card layouts
- Mint **#2ED47A** as the "good" accent
- **Continuous red → yellow → green percentile gradients** from raw values — no discrete buckets
- **Team colors reserved for team-identity visuals only**
- **Per-page color identity**: one color per pitch/player, reused across every visual on that page
- Monogram + initials placeholders through v1 (defer photo/logo licensing)
- Framer Motion polish: rating-change pop on result reveal, gauge sweep on Action+, smooth leaderboard reorders

### Navigation
5-tab global bottom nav: **News** ("The Concourse") · **Games** · **Stats** · **Following** · **More**

## The four "Big Rocks" (core defined features)

1. **Player Rating** — *the centerpiece engagement metric.* FotMob-style **0.0–10.0**. Everyone
   starts each game at **6.5** and moves on **process-oriented** events. Per-game reset to 6.5;
   rolling windows (game / series / week / month / season) are **time-weighted averages** of
   completed game ratings. Player cards lead with last-game rating ("8.4 last night") + rolling context.
   - **Position players:** all process streams layered (xwOBA + OAA + BsR + framing, position-aware).
     Spec: `~/Downloads/park_factor_rating_v3.docx.md` (read at implementation start).
   - **Pitchers:** a **separate** process-driven event model (whiff%, chase/induced, command/zone,
     soft-contact, with Action+ as one input). Spec still to be drafted — largest open modeling task.
   - **Team rollup:** weighted by playing time (**PA** for hitters / **batters faced** for pitchers).
     Starters dominate; a mop-up reliever can't outweigh a 9-IP starter.

2. **Action+** — existing v2.1 pitch-grading engine (`calculateActionPlusV2()`). v1 surfaces
   **per-pitch grades on arsenal cards**, engine output verbatim. Pitcher rollup is **v2**, not v1.

3. **Market Value** — combined **$/WAR + comparable-player regression**, anchored on similar-bucket
   players (position × age × WAR-tier × service-time) and recent contracts/trades. **Opaque
   presentation.** Framing: "What would this player be worth on the open market today?" Visual
   reference: fotmob.com/players/1105912/riccardo-calafiori.

4. **Park Factor (the stat)** — **brand name only in v1. No calculation.**

## v1 Scope (phased)

- **Phase A — Foundation:** Expo app scaffold (5-tab nav + theme tokens) · Statcast/MLB API
  ingestion (daily cron, schema-validated, idempotent backfill) · Player Rating engine
  (position players, then pitchers) · Team Rating rollup.
- **Phase B — Core pages:** Following/Teams (favorite team page, stat-toggle diamond lineup,
  mound-tap → pitching staff, hitter Damage heatmap, pitch-shape grid) · Player profile
  (port the Logan Gilbert prototype: radar, Pitchability, Arsenal, Movement scatter, percentile
  bars, Games/Career tabs) · Games tab (scoreboard → diamond, day stats alongside season) ·
  Stats tab.
- **Phase C — Differentiating modules:** Action+ arsenal card · Market Value module ·
  **Roster Construction infographic** (FA/trade/homegrown) · **Spend Efficiency infographic** ($/WAR).
- **Phase D — Social + onboarding:** favorite-team onboarding · profile screens ·
  community feed ("Baseball Twitter") · comparison tools (team-vs-team, player-vs-player).

### Key product stances
- **Stats tab leans hard into advanced metrics** (wRC+, xERA, Stuff+, OAA, framing, BsR, K%, BB%);
  traditional stats present but collapsed/secondary.
- **Infographics are a v1 priority** — Roster Construction + Spend Efficiency ship at launch.

### Explicitly out of v1
Park Factor stat (brand only) · Action+ pitcher rollup (v2) · player-development pipeline
infographic (v2) · real photo/logo licensing · Hot Stove / The Vault / Podcast / Fantasy
Predictor (More-tab stretches) · live in-game pitch-shape viz.

## Architecture / code home

Recommended monorepo:
- `packages/engine` — reuse existing Action+ code (`calculateActionPlusV2()`, GBM JSON artifacts,
  Zod input schemas), Player Rating engines, Team Rating rollup, Market Value comp engine
- `apps/mobile` — Expo (React Native) app
- `apps/web` — Next.js shell (web parity later)

**Existing backend services in this repo** (Node/Express + AWS DynamoDB under `backend/`,
Python PyBaseball stats microservice under `stats_api/`) provide news, user accounts, and
player/team/hitter/pitcher stats — reconcile these with the ingestion pipeline during Phase A.

## Critical files & references

- **`calculateActionPlusV2()`** — per-pitch Action+ grade entry point (arsenal cards)
- **`~/Downloads/park_factor_rating_v3.docx.md`** — position-player rating spec; **source of truth for Phase A rating work**
- **GBM JSON artifacts** (xwoba, rv100, whiff heads) + Zod schemas (`.finite()` refinement pattern) — reuse from existing engine
- **HTML/Chart.js prototypes** (location TBD) — Logan Gilbert player page, Padres team page,
  Dodgers diamond, comparison screens, market value chart — port targets for Phase B

## Verification expectations

- **Rating (position):** replay a Judge 2-HR / 4-for-5 day → end rating ≥ 9.0; an 0-for-4 / 3 K
  day → ≤ 5.0. Unit-test the time-weighted window math.
- **Rating (pitcher):** a high-Stuff+/low-result start must score above a low-Stuff+/high-result
  start with identical results (proves "process-oriented").
- **Team rating:** 9-IP starter dominates mop-up relievers; winning team's rating beats loser's >70% over a month.
- **Market value:** model AAV within ±20% for Soto/Ohtani/Skenes/Acuña/Judge; every card surfaces 3 visible comps.
- **App:** iOS simulator + Expo dev client golden path (favorite team → team → diamond → mound →
  pitcher → profile → Action+ card); Detox for nav coverage; manual on physical iPhone before release.
- **Pipeline:** daily ingestion CI check, schema validation on API responses, backfill count verification.

## Open implementation decisions (non-blocking)

Cross-linking from Stats leaders to entity sub-tabs · Pitchers/Catchers roster groupings ·
Standings tab content (GB, L10, streak, run differential) · collapse "Top Pitchers"/"Top Starters"
into one Games card · confirm Games diamond and Team mound-tap drill-in are the same reused component.
