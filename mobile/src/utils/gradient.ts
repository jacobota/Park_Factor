/**
 * Continuous red → yellow → green gradient (matches the design language: percentile color
 * is interpolated from a raw value, never bucketed). `frac` is clamped to 0..1.
 */
const STOPS: [number, number, number][] = [
  [224, 36, 94], // colors.bad  #E0245E
  [245, 197, 24], // colors.mid #F5C518
  [46, 212, 122], // colors.good #2ED47A
];

const lerp = (a: number, b: number, t: number) => a + (b - a) * t;
const hex2 = (n: number) => Math.round(n).toString(16).padStart(2, '0');

export function gradientColor(frac: number): string {
  const t = Math.max(0, Math.min(1, frac));
  const seg = t < 0.5 ? 0 : 1;
  const lt = t < 0.5 ? t / 0.5 : (t - 0.5) / 0.5;
  const a = STOPS[seg];
  const b = STOPS[seg + 1];
  return `#${hex2(lerp(a[0], b[0], lt))}${hex2(lerp(a[1], b[1], lt))}${hex2(lerp(a[2], b[2], lt))}`;
}

/** Map an Action+ grade (100 = avg, ~±20 spread) onto a 0..1 gradient fraction. */
export const actionPlusFrac = (v: number) => (v - 80) / 40;
