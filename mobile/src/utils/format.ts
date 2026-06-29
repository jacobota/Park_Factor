import type { StatValue } from '@/types';

/** Coerce a stat value to a number (Decimal/strings arrive from the backend). */
export const toNum = (v: StatValue): number => {
  const n = typeof v === 'number' ? v : Number(v);
  return Number.isFinite(n) ? n : 0;
};

/** Fixed-decimal stat formatting (replaces the Swift `%.Nf` specifiers). */
export const fmt = (v: StatValue, decimals: number): string => toNum(v).toFixed(decimals);

/** Integer stat formatting. */
export const fmtInt = (v: StatValue): string => String(Math.trunc(toNum(v)));

/** Percent formatting for fractional rate stats (0.30 -> "30.0%"). */
export const fmtPct = (v: StatValue, decimals = 1): string => `${(toNum(v) * 100).toFixed(decimals)}%`;
