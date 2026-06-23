/**
 * Percentile payloads (0-100) for the radar/percentile-bar visuals.
 * Backend wraps as { hitter_percentile: [...] } / { pitcher_percentile: [...] } with
 * snake_case keys (arm_strength, bat_speed, ...). Kept raw and read by key.
 */
export type PercentileBag = Record<string, number | string | null | undefined>;

export type HitterPercentile = PercentileBag;
export type PitcherPercentile = PercentileBag;
