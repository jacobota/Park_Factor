/**
 * Leaderboard display config — replaces the long `if let ... CardView(title:, decimalCount:)`
 * chains in the four Swift leaderboard views. Each row renders only if its stat key is present
 * in the normalized response, so the same hitting/pitching config serves both player and team
 * (team responses simply omit keys like IP/W/L).
 *
 * `key` is the raw stat key from the backend; `decimals: 0` renders an integer.
 */
export interface LeaderboardStat {
  key: string;
  title: string;
  decimals: number;
  /** One-line context shown under the card title. */
  description?: string;
  /** When true, lower raw values are better (inverts the value-bar fill). */
  lowerIsBetter?: boolean;
}

// Advanced metrics lead (per plan: Stats tab leans hard into advanced); traditional follow.
// Keys absent from the backend response simply don't render — so FanGraphs-only stats (wRC+,
// WAR, BsR, SIERA, vFA, GB%) stay listed but no-op until/unless that source returns.
export const HITTING_LEADERBOARD: LeaderboardStat[] = [
  { key: 'xwOBA', title: 'xwOBA', decimals: 3, description: 'Expected wOBA — quality of contact' },
  { key: 'Barrel%', title: 'Barrel%', decimals: 3, description: 'Barrels per batted ball' },
  { key: 'HardHit%', title: 'Hard-Hit%', decimals: 3, description: 'Batted balls 95+ mph' },
  { key: 'EV', title: 'Exit Velocity', decimals: 1, description: 'Average exit velocity (mph)' },
  { key: 'K%', title: 'K%', decimals: 3, description: 'Strikeout rate — lower is better', lowerIsBetter: true },
  { key: 'BB%', title: 'BB%', decimals: 3, description: 'Walk rate' },
  { key: 'wRC+', title: 'wRC+', decimals: 0, description: 'Park-adjusted offense — 100 = league avg' },
  { key: 'BsR', title: 'BsR', decimals: 1, description: 'Baserunning runs above average' },
  { key: 'WAR', title: 'WAR', decimals: 1, description: 'Wins above replacement' },
  { key: 'OPS', title: 'OPS', decimals: 3, description: 'On-base plus slugging' },
  { key: 'OBP', title: 'OBP', decimals: 3, description: 'On-base percentage' },
  { key: 'SLG', title: 'Slugging', decimals: 3, description: 'Slugging percentage' },
  { key: 'AVG', title: 'Batting Average', decimals: 3, description: 'Hits per at-bat' },
  { key: 'H', title: 'Hits', decimals: 0, description: 'Total hits' },
  { key: 'HR', title: 'Home Runs', decimals: 0, description: 'Total home runs' },
  { key: 'R', title: 'Runs', decimals: 0, description: 'Runs scored' },
  { key: 'RBI', title: 'RBIs', decimals: 0, description: 'Runs batted in' },
  { key: 'SB', title: 'Stolen Bases', decimals: 0, description: 'Stolen bases' },
];

export const PITCHING_LEADERBOARD: LeaderboardStat[] = [
  { key: 'xERA', title: 'xERA', decimals: 2, description: 'Expected ERA — true skill metric', lowerIsBetter: true },
  { key: 'K%', title: 'K%', decimals: 3, description: 'Strikeout rate' },
  { key: 'BB%', title: 'BB%', decimals: 3, description: 'Walk rate — lower is better', lowerIsBetter: true },
  { key: 'Barrel%', title: 'Barrel% Against', decimals: 3, description: 'Barrels allowed — lower is better', lowerIsBetter: true },
  { key: 'EV', title: 'Exit Velocity Against', decimals: 1, description: 'Avg exit velo allowed — lower is better', lowerIsBetter: true },
  { key: 'SIERA', title: 'SIERA', decimals: 2, description: 'Skill-interactive ERA', lowerIsBetter: true },
  { key: 'WAR', title: 'WAR', decimals: 1, description: 'Wins above replacement' },
  { key: 'ERA', title: 'ERA', decimals: 2, description: 'Earned run average — lower is better', lowerIsBetter: true },
  { key: 'WHIP', title: 'WHIP', decimals: 2, description: 'Walks + hits per inning — lower is better', lowerIsBetter: true },
  { key: 'AVG', title: 'Batting Average Against', decimals: 3, description: 'Opponent average — lower is better', lowerIsBetter: true },
  { key: 'IP', title: 'IP', decimals: 1, description: 'Innings pitched' },
  { key: 'SO', title: 'Strikeouts', decimals: 0, description: 'Total strikeouts' },
  { key: 'W', title: 'Wins', decimals: 0, description: 'Wins' },
  { key: 'L', title: 'Loss', decimals: 0, description: 'Losses — lower is better', lowerIsBetter: true },
  { key: 'SV', title: 'Saves', decimals: 0, description: 'Saves' },
  { key: 'BB', title: 'Walks Allowed', decimals: 0, description: 'Walks allowed — lower is better', lowerIsBetter: true },
  { key: 'H', title: 'Hits Allowed', decimals: 0, description: 'Hits allowed — lower is better', lowerIsBetter: true },
  { key: 'R', title: 'Runs Allowed', decimals: 0, description: 'Runs allowed — lower is better', lowerIsBetter: true },
  { key: 'HR', title: 'Home Runs Allowed', decimals: 0, description: 'Home runs allowed — lower is better', lowerIsBetter: true },
  { key: 'GB%', title: 'GB%', decimals: 3, description: 'Ground-ball rate' },
  { key: 'vFA (pi)', title: 'Average Fastball Velocity', decimals: 1, description: 'Average fastball velocity (mph)' },
];
