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

/**
 * Per-pitch arsenal row from the event-level endpoint (/pitchers/stats/arsenal-full).
 * Richer than {@link PitchType}: pre-computed usage, velo, break (already in inches), spin,
 * extension, and a run-value-derived Action+ proxy (100 = league avg, higher is better).
 */
export interface ArsenalPitch {
  pitch_type: string;
  pitch_name: string;
  usage: number; // 0..1
  velo: number | null;
  ivb: number | null; // induced vertical break, inches
  hb: number | null; // horizontal break, inches (catcher POV, signed)
  ext: number | null;
  spin: number | null;
  action_plus: number;
  count: number;
}

/** Per-pitch color + short name identity, keyed by Statcast 2-letter pitch code. */
export const PITCH_META: Record<string, { name: string; color: string }> = {
  FF: { name: '4-Seam', color: '#FF4D4D' },
  FT: { name: '2-Seam', color: '#FF7043' },
  SI: { name: 'Sinker', color: '#FF8C42' },
  FC: { name: 'Cutter', color: '#C0392B' },
  SL: { name: 'Slider', color: '#B06BE0' },
  ST: { name: 'Sweeper', color: '#F2C14E' },
  SV: { name: 'Slurve', color: '#9B59B6' },
  CU: { name: 'Curveball', color: '#4D9DE0' },
  KC: { name: 'Knuckle Curve', color: '#5E72E4' },
  CS: { name: 'Slow Curve', color: '#3D7DC0' },
  CH: { name: 'Changeup', color: '#2ED47A' },
  FS: { name: 'Splitter', color: '#1ABC9C' },
  FO: { name: 'Forkball', color: '#16A085' },
  SC: { name: 'Screwball', color: '#E67E22' },
  EP: { name: 'Eephus', color: '#95A5A6' },
  KN: { name: 'Knuckleball', color: '#7F8C8D' },
  PO: { name: 'Pitchout', color: '#95A5A6' },
};

export const arsenalMeta = (code: string): { name: string; color: string } =>
  PITCH_META[code] ?? { name: code, color: '#AEAEB2' };

/** Plottable movement point for an arsenal-full pitch (break is already in inches). */
export const arsenalPoint = (p: ArsenalPitch): PitchPoint | null => {
  if (p.hb == null || p.ivb == null) return null;
  const m = arsenalMeta(p.pitch_type);
  return { x: p.hb, y: p.ivb, color: m.color, pitchName: m.name };
};

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
