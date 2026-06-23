import React, { useState } from 'react';
import { StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { PercentileBar } from './PercentileBar';
import { Card } from '@/components/Card';
import { StatExplanationModal } from '@/components/cards/StatCard';
import { colors, radius, spacing, typography } from '@/theme';

export interface PercentileRow {
  catKey: string;
  label: string;
  percentile: number;
}

/** A titled card listing percentile rows (label + bar), each label tappable for an explanation. */
export function PercentileCard({ title, rows }: { title: string; rows: PercentileRow[] }) {
  const [selected, setSelected] = useState<string | null>(null);
  if (rows.length === 0) return null;

  return (
    <Card style={styles.card}>
      <Text style={styles.title}>{title}</Text>
      {rows.map((row) => (
        <View key={row.catKey} style={styles.row}>
          <TouchableOpacity style={styles.labelBox} onPress={() => setSelected(row.catKey)}>
            <Text style={styles.label}>{row.label}</Text>
          </TouchableOpacity>
          <View style={styles.bar}>
            <PercentileBar percentile={row.percentile} />
          </View>
        </View>
      ))}
      <StatExplanationModal statKey={selected} onClose={() => setSelected(null)} />
    </Card>
  );
}

const styles = StyleSheet.create({
  card: { backgroundColor: colors.elevated, borderWidth: StyleSheet.hairlineWidth, borderColor: colors.hairline, borderRadius: radius.md, padding: spacing.lg, marginBottom: spacing.lg },
  title: { ...typography.subtitleNorwester, color: colors.white, marginBottom: spacing.md },
  row: { flexDirection: 'row', alignItems: 'center', marginBottom: spacing.md },
  labelBox: { width: 80 },
  label: { ...typography.smallText, color: colors.white },
  bar: { flex: 1 },
});
