import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { Card } from '@/components/Card';
import { arsenalMeta } from '@/types';
import type { ArsenalPitch } from '@/types';
import { fmt } from '@/utils/format';
import { colors, fonts, radius, spacing, typography } from '@/theme';

const COLS = ['Velo', 'IVB', 'HB', 'Spin', 'Ext'];

/** Per-pitch shape table: velo / induced vertical break / horizontal break / spin / extension. */
export function PitchShapesTable({ pitches }: { pitches: ArsenalPitch[] }) {
  if (!pitches.length) return null;

  return (
    <Card style={styles.card}>
      <Text style={styles.title}>PITCH SHAPES</Text>
      <View style={styles.headRow}>
        <Text style={[styles.pitchCol, styles.headCell]}>Pitch</Text>
        {COLS.map((c) => (
          <Text key={c} style={[styles.col, styles.headCell]}>
            {c}
          </Text>
        ))}
      </View>
      {pitches.map((p) => {
        const meta = arsenalMeta(p.pitch_type);
        return (
          <View key={p.pitch_type} style={styles.dataRow}>
            <View style={[styles.pitchCol, styles.pitchNameBox]}>
              <View style={[styles.dot, { backgroundColor: meta.color }]} />
              <Text style={styles.cell} numberOfLines={1}>
                {meta.name}
              </Text>
            </View>
            <Text style={[styles.col, styles.cell]}>{p.velo != null ? fmt(p.velo, 1) : '—'}</Text>
            <Text style={[styles.col, styles.cell]}>{p.ivb != null ? fmt(p.ivb, 1) : '—'}</Text>
            <Text style={[styles.col, styles.cell]}>{p.hb != null ? fmt(p.hb, 1) : '—'}</Text>
            <Text style={[styles.col, styles.cell]}>{p.spin != null ? Math.round(p.spin) : '—'}</Text>
            <Text style={[styles.col, styles.cell]}>{p.ext != null ? fmt(p.ext, 1) : '—'}</Text>
          </View>
        );
      })}
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
  headRow: { flexDirection: 'row', marginBottom: spacing.sm },
  dataRow: { flexDirection: 'row', alignItems: 'center', paddingVertical: spacing.xs },
  pitchCol: { flex: 1.6 },
  col: { flex: 1, textAlign: 'center' },
  pitchNameBox: { flexDirection: 'row', alignItems: 'center' },
  dot: { width: 10, height: 10, borderRadius: 5, marginRight: 6 },
  headCell: { fontFamily: fonts.archivo, fontSize: 12, color: colors.gray },
  cell: { fontFamily: fonts.archivo, fontSize: 14, color: colors.white },
});
