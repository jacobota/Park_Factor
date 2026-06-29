import React from 'react';
import { StyleSheet, Text } from 'react-native';
import { useQuery } from '@tanstack/react-query';
import { RadarChart, RadarAxis } from '@/components/charts/RadarChart';
import { Card } from '@/components/Card';
import { getHitterPercentiles } from '@/api/stats';
import { getStat } from '@/types';
import { toNum } from '@/utils/format';
import { colors, radius, spacing, typography } from '@/theme';

// 10-axis hitter radar — every axis is a Savant percentile (0-100, higher = better), so a fuller
// polygon reads as a better hitter. All values come from statcast_batter_percentile_ranks.
const AXES: RadarAxis[] = [
  { label: 'xwOBA', max: 100 },
  { label: 'xBA', max: 100 },
  { label: 'xSLG', max: 100 },
  { label: 'EV', max: 100 },
  { label: 'Barrel%', max: 100 },
  { label: 'Hard%', max: 100 },
  { label: 'K%', max: 100 },
  { label: 'BB%', max: 100 },
  { label: 'Chase%', max: 100 },
  { label: 'OAA', max: 100 },
];
const KEYS = [
  'xwoba',
  'xba',
  'xslg',
  'exit_velocity',
  'brl_percent',
  'hard_hit_percent',
  'k_percent',
  'bb_percent',
  'chase_percent',
  'oaa',
];

/** Player Summary radar card. */
export function HitterRadarCard({ mlbamId, color }: { mlbamId: number; color: string }) {
  const { data } = useQuery({
    queryKey: ['hitter-percentiles', mlbamId],
    queryFn: () => getHitterPercentiles(mlbamId),
  });
  if (!data) return null;

  const values = KEYS.map((k) => toNum(getStat(data, k)));

  return (
    <Card style={styles.card} accent={color}>
      <Text style={styles.title}>Player Summary</Text>
      <RadarChart axes={AXES} values={values} color={color} />
    </Card>
  );
}

const styles = StyleSheet.create({
  card: { backgroundColor: colors.elevated, borderWidth: StyleSheet.hairlineWidth, borderColor: colors.hairline, borderRadius: radius.md, padding: spacing.lg, marginBottom: spacing.lg },
  title: { ...typography.subtitleNorwester, color: colors.white, marginBottom: spacing.md },
});
