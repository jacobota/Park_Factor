import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import type { GameDetails } from '@/types';
import { Card } from '@/components/Card';
import { colors, radius, spacing, typography } from '@/theme';

/** Streak column: positive => "N W", negative => "N L" (TeamOverviewCardView). */
const streakLabel = (streak?: number | null): string => {
  if (streak == null) return 'N/A';
  return streak >= 0 ? `${streak} W` : `${Math.abs(streak)} L`;
};

/** Record / GB / Streak summary derived from the team's last played game. */
export function TeamOverviewCard({ game }: { game?: GameDetails }) {
  return (
    <Card style={styles.card}>
      <View style={styles.row}>
        <Column label="Record" value={game?.['W-L'] ?? 'N/A'} />
        <Column label="GB" value={game?.GB ?? 'N/A'} />
        <Column label="Streak" value={streakLabel(game?.Streak)} />
      </View>
    </Card>
  );
}

const Column = ({ label, value }: { label: string; value: string }) => (
  <View style={styles.col}>
    <Text style={styles.label}>{label}</Text>
    <Text style={styles.value}>{value}</Text>
  </View>
);

const styles = StyleSheet.create({
  card: { backgroundColor: colors.elevated, borderWidth: StyleSheet.hairlineWidth, borderColor: colors.hairline, borderRadius: radius.md, padding: spacing.lg, marginBottom: spacing.lg },
  row: { flexDirection: 'row' },
  col: { flex: 1, alignItems: 'center' },
  label: { ...typography.smallText, color: colors.gray, marginBottom: 4 },
  value: { ...typography.smallText, color: colors.white },
});
