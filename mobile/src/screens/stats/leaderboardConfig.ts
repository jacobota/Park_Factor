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
}

export const HITTING_LEADERBOARD: LeaderboardStat[] = [
  { key: 'AVG', title: 'Batting Average', decimals: 3 },
  { key: 'OBP', title: 'OBP', decimals: 3 },
  { key: 'OPS', title: 'OPS', decimals: 3 },
  { key: 'SLG', title: 'Slugging', decimals: 3 },
  { key: 'WAR', title: 'WAR', decimals: 1 },
  { key: 'H', title: 'Hits', decimals: 0 },
  { key: 'HR', title: 'Home Runs', decimals: 0 },
  { key: 'R', title: 'Runs', decimals: 0 },
  { key: 'RBI', title: 'RBIs', decimals: 0 },
  { key: 'SB', title: 'Stolen Bases', decimals: 0 },
  { key: 'BB%', title: 'BB%', decimals: 3 },
  { key: 'K%', title: 'K%', decimals: 3 },
  { key: 'Barrel%', title: 'Barrel%', decimals: 3 },
  { key: 'EV', title: 'Exit Velocity', decimals: 1 },
  { key: 'wRC+', title: 'wRC+', decimals: 0 },
  { key: 'BsR', title: 'BsR', decimals: 1 },
];

export const PITCHING_LEADERBOARD: LeaderboardStat[] = [
  { key: 'AVG', title: 'Batting Average Against', decimals: 3 },
  { key: 'ERA', title: 'ERA', decimals: 2 },
  { key: 'IP', title: 'IP', decimals: 1 },
  { key: 'W', title: 'Wins', decimals: 0 },
  { key: 'L', title: 'Loss', decimals: 0 },
  { key: 'SO', title: 'Strikeouts', decimals: 0 },
  { key: 'K%', title: 'K%', decimals: 3 },
  { key: 'BB', title: 'Walks Allowed', decimals: 0 },
  { key: 'BB%', title: 'BB%', decimals: 3 },
  { key: 'H', title: 'Hits Allowed', decimals: 0 },
  { key: 'R', title: 'Runs Allowed', decimals: 0 },
  { key: 'HR', title: 'Home Runs Allowed', decimals: 0 },
  { key: 'SV', title: 'Saves', decimals: 0 },
  { key: 'WAR', title: 'WAR', decimals: 1 },
  { key: 'SIERA', title: 'SIERA', decimals: 2 },
  { key: 'WHIP', title: 'WHIP', decimals: 2 },
  { key: 'GB%', title: 'GB%', decimals: 3 },
  { key: 'vFA (pi)', title: 'Average Fastball Velocity', decimals: 1 },
  { key: 'EV', title: 'Exit Velocity Against', decimals: 1 },
];
