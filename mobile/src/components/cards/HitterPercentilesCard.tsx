import React from 'react';
import { useQuery } from '@tanstack/react-query';
import { PercentileCard, PercentileRow } from '@/components/charts/PercentileCard';
import { getHitterPercentiles } from '@/api/stats';
import { getStat } from '@/types';
import type { HitterPercentile } from '@/types';

// [statKey, statcategory key, display label] for each percentile group (HitterPercentilesStatsView).
const HITTING: [string, string, string][] = [
  ['bat_speed', 'hitter_bat_speed', 'Bat Speed'],
  ['bb_percent', 'hitter_bbpercent', 'BB%'],
  ['brl', 'hitter_barrels', 'Barrels'],
  ['brl_percent', 'hitter_barrelpercent', 'Barrel%'],
  ['chase_percent', 'hitter_chasepercent', 'Chase%'],
  ['exit_velocity', 'hitter_ev', 'EV'],
  ['hard_hit_percent', 'hitter_hardhitpercent', 'Hard Hit%'],
  ['k_percent', 'hitter_kpercent', 'K%'],
  ['max_ev', 'hitter_maxev', 'Max EV'],
  ['oaa', 'hitter_oaa', 'OAA'],
  ['squared_up_rate', 'hitter_squarepercent', 'Square%'],
  ['whiff_percent', 'hitter_whiffpercent', 'Whiff%'],
];
const EXPECTED: [string, string, string][] = [
  ['xba', 'hitter_xba', 'xBA'],
  ['xiso', 'hitter_xiso', 'xISO'],
  ['xbp', 'hitter_xobp', 'xOBP'],
  ['xslg', 'hitter_xslg', 'xSLG'],
  ['xwoba', 'hitter_xwoba', 'xwOBA'],
];
const MISC: [string, string, string][] = [
  ['arm_strength', 'hitter_arm', 'Arm'],
  ['sprint_speed', 'hitter_sprint', 'Sprint'],
];

const toRows = (defs: [string, string, string][], data: HitterPercentile): PercentileRow[] =>
  defs
    .filter(([key]) => getStat(data, key) != null)
    .map(([key, catKey, label]) => ({ catKey, label, percentile: Number(getStat(data, key)) }));

/** The three percentile cards (Hitting / Expected / Misc) below the season stats. */
export function HitterPercentilesCard({ mlbamId }: { mlbamId: number }) {
  const { data } = useQuery({
    queryKey: ['hitter-percentiles', mlbamId],
    queryFn: () => getHitterPercentiles(mlbamId),
  });
  if (!data) return null;

  return (
    <>
      <PercentileCard title="Hitting Percentiles" rows={toRows(HITTING, data)} />
      <PercentileCard title="Expected Percentiles" rows={toRows(EXPECTED, data)} />
      <PercentileCard title="Misc Percentiles" rows={toRows(MISC, data)} />
    </>
  );
}
