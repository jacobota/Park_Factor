/**
 * Leaderboards. The Swift app had ~60 near-identical structs (BattingAveragePlayer,
 * WalkPercentageTeam, ...) all shaped `{ Team, <statKey>, Name? }`. Collapsed here into a
 * single normalized entry plus a normalizer that reads each entry's value from its stat key.
 *
 * A leaderboard response is keyed by raw stat name -> array of raw entries, e.g.
 *   { "AVG": [{ Team, AVG, Name }], "wRC+": [...] }
 */
export interface LeaderboardEntry {
  team: string;
  value: number;
  name?: string;
}

export type RawLeaderboardEntry = Record<string, string | number>;
export type RawLeaderboard = Record<string, RawLeaderboardEntry[]>;
export type Leaderboard = Record<string, LeaderboardEntry[]>;

/**
 * Normalize a raw leaderboard: pull each entry's value out of its stat-named key.
 * Defensive against the backend's `{ error: "..." }` envelope — non-array values are skipped.
 */
export const normalizeLeaderboard = (raw: RawLeaderboard | null | undefined): Leaderboard => {
  const out: Leaderboard = {};
  if (!raw) return out;
  for (const [statKey, entries] of Object.entries(raw)) {
    if (!Array.isArray(entries)) continue;
    out[statKey] = entries.map((e) => ({
      team: String(e.Team ?? ''),
      value: Number(e[statKey] ?? 0),
      name: e.Name != null ? String(e.Name) : undefined,
    }));
  }
  return out;
};

/** The backend wraps upstream failures as `{ <envelopeKey>: { error: "..." } }`. */
export const leaderboardError = (inner: unknown): string | null => {
  if (inner && typeof inner === 'object' && 'error' in inner) {
    const msg = (inner as { error: unknown }).error;
    return typeof msg === 'string' ? msg : 'Leaderboard data unavailable';
  }
  return null;
};
