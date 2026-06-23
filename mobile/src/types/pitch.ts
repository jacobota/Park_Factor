import { colors } from '@/theme';

/** A single pitch in a pitcher's arsenal (raw keys from the backend). */
export interface PitchType {
  avg_speed?: number | null;
  diff_x?: number | null;
  league_break_x?: number | null;
  pitch_hand?: string | null;
  pitch_per?: number | null;
  pitch_type?: string | null;
  pitch_type_name?: string | null;
  pitcher_break_z_induced?: number | null;
  pitches_thrown?: number | null;
}

export interface PitchPoint {
  x: number;
  y: number;
  color: string;
  pitchName: string;
}

/** pitch_per * 100 */
export const pitchPercentage = (p: PitchType): number | null =>
  p.pitch_per == null ? null : p.pitch_per * 100;

/** Shortened display name for longer pitch names. */
export const shortenedPitchName = (p: PitchType): string | null => {
  const name = p.pitch_type_name;
  if (!name) return null;
  switch (name) {
    case '4-Seam Fastball':
      return '4-Seam';
    case 'Changeup':
      return 'Change';
    case 'Curveball':
      return 'Curve';
    case 'Split-Finger':
      return 'Split';
    case 'Sweeper':
      return 'Sweep';
    default:
      return name;
  }
};

/** Per-pitch color identity (matches Swift pitchColor). */
export const pitchColor = (p: PitchType): string | null => {
  switch (p.pitch_type_name) {
    case '4-Seam Fastball':
      return 'red';
    case 'Changeup':
      return 'green';
    case 'Curveball':
      return 'blue';
    case 'Sinker':
      return 'orange';
    case 'Slider':
      return 'purple';
    case 'Sweeper':
      return 'yellow';
    default:
      return p.pitch_type_name ? colors.white : null;
  }
};

/**
 * Horizontal break: combine league break with the pitcher's differential, then flip
 * the sign for right-handers so points orient correctly on the movement chart.
 */
export const pitcherBreakX = (p: PitchType): number | null => {
  const leagueX = p.league_break_x;
  const diffX = p.diff_x;
  if (leagueX == null || diffX == null) return null;

  const sameSign = (leagueX > 0 && diffX > 0) || (leagueX < 0 && diffX < 0);
  const result = sameSign ? leagueX + diffX : leagueX - diffX;
  return p.pitch_hand === 'R' ? -result : result;
};

/** Build a plottable point for the movement chart, or null if incomplete. */
export const pitchPoint = (p: PitchType): PitchPoint | null => {
  const x = pitcherBreakX(p);
  const y = p.pitcher_break_z_induced;
  const name = shortenedPitchName(p);
  const color = pitchColor(p);
  if (x == null || y == null || !name || !color) return null;
  return { x, y, color, pitchName: name };
};
