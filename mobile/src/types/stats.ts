/**
 * Stat payloads.
 *
 * These objects arrive keyed by their raw FanGraphs / Statcast / Baseball-Reference column
 * names (e.g. "wRC+", "BB%", "xwOBA", "vFA (pi)"). Rather than re-mapping ~80 fields per type
 * (the Swift CodingKeys), we keep the raw keys and read them by key in data-driven stat cards,
 * matching the keys in assets/statcategory.json. Use `getStat(bag, key)` for safe access.
 */

export type StatValue = number | string | null | undefined;
export type StatBag = Record<string, StatValue>;

export const getStat = (bag: StatBag | null | undefined, key: string): StatValue =>
  bag ? bag[key] : undefined;

// Season stats (FanGraphs columns + Statcast extras). Includes a "Team" abbr.
export type HitterStats = StatBag;
export type PitchingStats = StatBag;

// Career stats (per-season rows; same column families as season).
export type HittingCareerStats = StatBag;
export type PitchingCareerStats = StatBag;

// Minor/preview stats (Baseball-Reference columns: "#days", "2B", "BA", "Tm", "Lev", "mlbID", ...).
export type HitterPreviewStats = StatBag;
export type PitchingPreviewStats = StatBag;

// Team aggregate stats.
export type TeamBatting = StatBag;
export type TeamFielding = StatBag;
export type TeamPitching = StatBag;

export interface TeamStats {
  teamBatting?: TeamBatting[] | null; // "team_batting"
  teamFielding?: TeamFielding[] | null; // "team_fielding"
  teamPitching?: TeamPitching[] | null; // "team_pitching"
}
