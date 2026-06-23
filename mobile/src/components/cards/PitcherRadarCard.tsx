import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { useQuery } from '@tanstack/react-query';
import { RadarChart, RadarAxis } from '@/components/charts/RadarChart';
import { getPitcherPercentiles } from '@/api/stats';
import { getStat } from '@/types';
import { toNum } from '@/utils/format';
import { colors, radius, spacing, typography } from '@/theme';

// Pitcher radar axes (PitcherSpiderGraphView). NOTE: the GB% axis reuses the whiff_percent
// value, matching the Swift source (pitcher percentiles carry no ground-ball percentile).
const AXES: RadarAxis[] = [
  { label: 'xERA', max: 100 },
  { label: 'FB Velo', max: 100 },
  { label: 'Whiff%', max: 100 },
  { label: 'K%', max: 100 },
  { label: 'BB%', max: 100 },
  { label: 'GB%', max: 100 },
];
const KEYS = ['xera', 'fb_velocity', 'whiff_percent', 'k_percent', 'bb_percent', 'whiff_percent'];

export function PitcherRadarCard({ mlbamId, color }: { mlbamId: number; color: string }) {
  const { data } = useQuery({
    queryKey: ['pitcher-percentiles', mlbamId],
    queryFn: () => getPitcherPercentiles(mlbamId),
  });
  if (!data) return null;

  const values = KEYS.map((k) => toNum(getStat(data, k)));

  return (
    <View style={styles.card}>
      <Text style={styles.title}>Player Summary</Text>
      <RadarChart axes={AXES} values={values} color={color} />
    </View>
  );
}

const styles = StyleSheet.create({
  card: { backgroundColor: colors.secondary, borderRadius: radius.md, padding: spacing.lg, marginBottom: spacing.sm },
  title: { ...typography.subtitleNorwester, color: colors.white, marginBottom: spacing.md },
});
