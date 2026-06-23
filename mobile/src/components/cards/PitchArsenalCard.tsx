import React, { useState } from 'react';
import { StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { useQuery } from '@tanstack/react-query';
import { PitchScatterChart } from '@/components/charts/PitchScatterChart';
import { StatExplanationModal } from '@/components/cards/StatCard';
import { getPitcherArsenal } from '@/api/stats';
import { pitcherBreakX, pitchPercentage, pitchPoint, shortenedPitchName } from '@/types';
import type { PitchPoint } from '@/types';
import { fmt } from '@/utils/format';
import { colors, radius, spacing, typography } from '@/theme';

const SUMMARY_COLS: { catKey?: string; label: string }[] = [
  { label: 'Type' },
  { catKey: 'pitcher_velo', label: 'Velo' },
  { catKey: 'pitcher_ivb', label: 'IVB' },
  { catKey: 'pitcher_hb', label: 'HB' },
  { catKey: 'pitcher_pitchpercentage', label: '%' },
];

/** Movement Profile scatter + per-pitch Summary table (PitcherPitchArsenalGraphView). */
export function PitchArsenalCard({ mlbamId }: { mlbamId: number }) {
  const [selected, setSelected] = useState<string | null>(null);
  const { data: arsenal } = useQuery({
    queryKey: ['pitcher-arsenal', mlbamId],
    queryFn: () => getPitcherArsenal(mlbamId),
  });

  if (!arsenal || arsenal.length === 0) return null;
  const points = arsenal.map(pitchPoint).filter((p): p is PitchPoint => p !== null);

  return (
    <>
      <View style={styles.card}>
        <Text style={styles.title}>Movement Profile</Text>
        <PitchScatterChart points={points} />
      </View>

      <View style={styles.card}>
        <Text style={styles.title}>Summary</Text>
        <View style={styles.headerRow}>
          {SUMMARY_COLS.map((c) => (
            <TouchableOpacity key={c.label} style={styles.col} disabled={!c.catKey} onPress={() => c.catKey && setSelected(c.catKey)}>
              <Text style={styles.headerCell}>{c.label}</Text>
            </TouchableOpacity>
          ))}
        </View>
        {arsenal.map((pitch, i) => (
          <View key={i} style={styles.dataRow}>
            {/* Note: IVB/HB columns mirror the Swift source's value order. */}
            <Text style={[styles.col, styles.cell]}>{shortenedPitchName(pitch) ?? 'N/A'}</Text>
            <Text style={[styles.col, styles.cell]}>{fmt(pitch.avg_speed, 1)}</Text>
            <Text style={[styles.col, styles.cell]}>{fmt(pitcherBreakX(pitch), 1)}</Text>
            <Text style={[styles.col, styles.cell]}>{fmt(pitch.pitcher_break_z_induced, 1)}</Text>
            <Text style={[styles.col, styles.cell]}>{fmt(pitchPercentage(pitch), 2)}%</Text>
          </View>
        ))}
      </View>

      <StatExplanationModal statKey={selected} onClose={() => setSelected(null)} />
    </>
  );
}

const styles = StyleSheet.create({
  card: { backgroundColor: colors.secondary, borderRadius: radius.md, padding: spacing.lg, marginBottom: spacing.sm },
  title: { ...typography.subtitleNorwester, color: colors.white, marginBottom: spacing.md },
  headerRow: { flexDirection: 'row', marginBottom: spacing.sm },
  dataRow: { flexDirection: 'row', marginBottom: spacing.xs },
  col: { flex: 1, alignItems: 'center', textAlign: 'center' },
  headerCell: { ...typography.smallText, color: colors.gray, textAlign: 'center' },
  cell: { ...typography.smallText, color: colors.white },
});
