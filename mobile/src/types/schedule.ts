import { teamByFG } from '@/utils/teams';

/** One game row from the team schedule & results feed (raw Baseball-Reference keys). */
export interface GameDetails {
  Attendance?: number | null;
  'D/N'?: string | null;
  Date?: string | null;
  GB?: string | null;
  Home_Away?: string | null;
  Inn?: number | null;
  Loss?: string | null;
  Opp?: string | null;
  'Orig. Scheduled'?: string | null;
  R?: number | null;
  RA?: number | null;
  Rank?: number | null;
  Save?: string | null;
  Streak?: number | null;
  Time?: string | null;
  Tm?: string | null;
  'W-L'?: string | null;
  'W/L'?: string | null;
  Win?: string | null;
  cLI?: string | null;
}

export const oppMascot = (g: GameDetails): string => teamByFG(g.Opp)?.mascot ?? 'Unknown Name';
export const teamMascot = (g: GameDetails): string => teamByFG(g.Tm)?.mascot ?? 'Unknown Name';
