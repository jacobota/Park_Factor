import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { Card } from '@/components/Card';
import { arsenalMeta } from '@/types';
import type { ArsenalPitch } from '@/types';
import { colors, fonts, radius, spacing, typography } from '@/theme';

/** Single stacked usage bar segmented (and colored) per pitch type, with a labeled legend. */
export function PitchUsageBar({ pitches }: { pitches: ArsenalPitch[] }) {
  if (!pitches.length) return null;
  const total = pitches.reduce((s, p) => s + p.usage, 0) || 1;

  return (
    <Card style={styles.card}>
      <Text style={styles.title}>PITCH MIX</Text>
      <View style={styles.bar}>
        {pitches.map((p) => {
          const meta = arsenalMeta(p.pitch_type);
          return <View key={p.pitch_type} style={{ flex: p.usage / total, backgroundColor: meta.color }} />;
        })}
      </View>
      <View style={styles.legend}>
        {pitches.map((p) => {
          const meta = arsenalMeta(p.pitch_type);
          return (
            <View key={p.pitch_type} style={styles.legendItem}>
              <View style={[styles.swatch, { backgroundColor: meta.color }]} />
              <Text style={styles.legendText}>
                {meta.name} {Math.round(p.usage * 100)}%
              </Text>
            </View>
          );
        })}
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
  title: { ...typography.smallTextNorwester, color: colors.lightGray, letterSpacing: 1.2, marginBottom: spacing.md },
  bar: { flexDirection: 'row', height: 22, borderRadius: radius.sm, overflow: 'hidden' },
  legend: { flexDirection: 'row', flexWrap: 'wrap', marginTop: spacing.md, rowGap: spacing.xs, columnGap: spacing.lg },
  legendItem: { flexDirection: 'row', alignItems: 'center' },
  swatch: { width: 12, height: 12, borderRadius: 3, marginRight: 6 },
  legendText: { fontFamily: fonts.archivo, fontSize: 13, color: colors.white },
});
