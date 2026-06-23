import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { useQuery } from '@tanstack/react-query';
import { RadarChart, RadarAxis } from '@/components/charts/RadarChart';
import { getHitterPercentiles } from '@/api/stats';
import { getStat } from '@/types';
import { toNum } from '@/utils/format';
import { colors, radius, spacing, typography } from '@/theme';

// Hitter radar axes (HitterSpiderGraphView: xwOBA, EV, Barrel%, K%, BB%, OAA), all 0-100 percentiles.
const AXES: RadarAxis[] = [
  { label: 'xwOBA', max: 100 },
  { label: 'EV', max: 100 },
  { label: 'Barrel%', max: 100 },
  { label: 'K%', max: 100 },
  { label: 'BB%', max: 100 },
  { label: 'OAA', max: 100 },
];
const KEYS = ['xwoba', 'exit_velocity', 'brl_percent', 'k_percent', 'bb_percent', 'oaa'];

/** Player Summary radar card. */
export function HitterRadarCard({ mlbamId, color }: { mlbamId: number; color: string }) {
  const { data } = useQuery({
    queryKey: ['hitter-percentiles', mlbamId],
    queryFn: () => getHitterPercentiles(mlbamId),
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
