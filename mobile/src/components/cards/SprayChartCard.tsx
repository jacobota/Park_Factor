import React from 'react';
import { Image, StyleSheet, Text, View } from 'react-native';
import { config } from '@/config';
import { colors, radius, spacing, typography } from '@/theme';

/** Savant team-abbreviation fixups used by the spray-chart endpoint (HitterVisualsStatsView). */
const sprayTeam = (fgAbbr?: string): string =>
  fgAbbr === 'KCR' ? 'KC' : fgAbbr === 'SDP' ? 'SD' : (fgAbbr ?? '');

/**
 * Spray chart — a matplotlib image served directly by the Flask stats API.
 * This is the one screen that calls Flask directly, so Flask must bind 0.0.0.0 for devices.
 */
export function SprayChartCard({ mlbamId, teamFG }: { mlbamId: number; teamFG?: string }) {
  const uri = `${config.flaskBaseURL}/hitters/api/hitter-stats/spraychart?mlbam-id=${mlbamId}&team=${sprayTeam(teamFG)}`;
  return (
    <View style={styles.card}>
      <Text style={styles.title}>Spray Chart</Text>
      <Image source={{ uri }} style={styles.image} resizeMode="contain" />
    </View>
  );
}

const styles = StyleSheet.create({
  card: { backgroundColor: colors.secondary, borderRadius: radius.md, padding: spacing.lg, marginBottom: spacing.sm, alignItems: 'center' },
  title: { ...typography.subtitleNorwester, color: colors.white, alignSelf: 'flex-start', marginBottom: spacing.md },
  image: { width: 300, height: 300 },
});
