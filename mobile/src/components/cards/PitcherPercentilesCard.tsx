import React from 'react';
import { useQuery } from '@tanstack/react-query';
import { PercentileCard, PercentileRow } from '@/components/charts/PercentileCard';
import { getPitcherPercentiles } from '@/api/stats';
import { getStat } from '@/types';

// [statKey, statcategory key, label] for the single pitcher percentile group.
const PITCHING: [string, string, string][] = [
  ['fb_velocity', 'pitcher_fbvelo', 'FB Velo'],
  ['fb_spin', 'pitcher_fbspin', 'FB Spin'],
  ['bb_percent', 'pitcher_bbpercent', 'BB%'],
  ['brl', 'pitcher_barrels', 'Barrels'],
  ['chase_percent', 'pitcher_chasepercent', 'Chase%'],
  ['exit_velocity', 'pitcher_ev', 'EV'],
  ['hard_hit_percent', 'pitcher_hardhitpercent', 'HH %'],
  ['k_percent', 'pitcher_kpercent', 'K%'],
  ['max_ev', 'pitcher_maxev', 'Max EV'],
  ['whiff_percent', 'pitcher_whiffpercent', 'Whiff%'],
];

export function PitcherPercentilesCard({ mlbamId }: { mlbamId: number }) {
  const { data } = useQuery({
    queryKey: ['pitcher-percentiles', mlbamId],
    queryFn: () => getPitcherPercentiles(mlbamId),
  });
  if (!data) return null;

  const rows: PercentileRow[] = PITCHING.filter(([key]) => getStat(data, key) != null).map(
    ([key, catKey, label]) => ({ catKey, label, percentile: Number(getStat(data, key)) }),
  );

  return <PercentileCard title="Pitching Percentiles" rows={rows} />;
}
