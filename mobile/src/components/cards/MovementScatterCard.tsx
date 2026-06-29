import React from 'react';
import { StyleSheet, Text } from 'react-native';
import { PitchScatterChart } from '@/components/charts/PitchScatterChart';
import { Card } from '@/components/Card';
import { arsenalPoint } from '@/types';
import type { ArsenalPitch, PitchPoint } from '@/types';
import { colors, radius, spacing, typography } from '@/theme';

/** Movement Profile scatter built from event-level arsenal data (break already in inches). */
export function MovementScatterCard({ pitches }: { pitches: ArsenalPitch[] }) {
  const points = pitches.map(arsenalPoint).filter((p): p is PitchPoint => p !== null);
  if (!points.length) return null;

  return (
    <Card style={styles.card}>
      <Text style={styles.title}>MOVEMENT PROFILE</Text>
      <PitchScatterChart points={points} />
    </Card>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: colors.elevated,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: colors.hairline,
    borderRadius: radius.md,
    padding: spacing.lg,
    marginBottom: spacing.lg,
  },
  title: { ...typography.smallTextNorwester, color: colors.lightGray, letterSpacing: 1.2, marginBottom: spacing.md },
});
