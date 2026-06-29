import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { useQuery } from '@tanstack/react-query';
import { Card } from '@/components/Card';
import { getPlayerPeople } from '@/api/stats';
import { colors, fonts, radius, spacing, typography } from '@/theme';

/** Two-line bio cell: small gray label over a white value. */
function Cell({ label, value }: { label: string; value: string }) {
  return (
    <View style={styles.cell}>
      <Text style={styles.label}>{label}</Text>
      <Text style={styles.value} numberOfLines={1}>
        {value}
      </Text>
    </View>
  );
}

/**
 * Player bio strip (MLB Stats API people): number/position headline + Age, B/T, Height,
 * Weight, Born grid. Falls back gracefully when a field is missing.
 */
export function PlayerInfoCard({ mlbamId }: { mlbamId: number }) {
  const { data: p } = useQuery({
    queryKey: ['player-people', mlbamId],
    queryFn: () => getPlayerPeople(mlbamId),
    enabled: !!mlbamId,
    staleTime: 24 * 60 * 60 * 1000,
  });
  if (!p) return null;

  const na = (v?: string | number | null) => (v == null || v === '' ? '—' : String(v));
  const bt = `${na(p.bats)} / ${na(p.throws)}`;

  return (
    <Card style={styles.card}>
      <View style={styles.headline}>
        {!!p.number && <Text style={styles.number}>#{p.number}</Text>}
        {!!p.position && <Text style={styles.pos}>{p.position}</Text>}
      </View>
      <View style={styles.grid}>
        <Cell label="AGE" value={na(p.age)} />
        <Cell label="B / T" value={bt} />
        <Cell label="HEIGHT" value={na(p.height)} />
        <Cell label="WEIGHT" value={p.weight ? `${p.weight} lb` : '—'} />
        <Cell label="BORN" value={na(p.born)} />
      </View>
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
  headline: { flexDirection: 'row', alignItems: 'baseline', gap: spacing.sm, marginBottom: spacing.md },
  number: { fontFamily: fonts.norwester, fontSize: 22, color: colors.primary },
  pos: { fontFamily: fonts.norwester, fontSize: 16, color: colors.lightGray, letterSpacing: 1 },
  grid: { flexDirection: 'row', flexWrap: 'wrap', rowGap: spacing.md },
  cell: { flexBasis: '33.33%' },
  label: { ...typography.subSectionText, color: colors.gray, letterSpacing: 0.6, marginBottom: 2 },
  value: { fontFamily: fonts.archivo, fontSize: 16, color: colors.white },
});
