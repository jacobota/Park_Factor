import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { Card } from '@/components/Card';
import { arsenalMeta } from '@/types';
import type { ArsenalPitch } from '@/types';
import { fmt } from '@/utils/format';
import { actionPlusFrac, gradientColor } from '@/utils/gradient';
import { colors, fonts, radius, spacing, typography } from '@/theme';

/** A single metric column (label over value) inside a pitch row. */
function Metric({ label, value }: { label: string; value: string }) {
  return (
    <View style={styles.metric}>
      <Text style={styles.metricLabel}>{label}</Text>
      <Text style={styles.metricValue}>{value}</Text>
    </View>
  );
}

function PitchRow({ p }: { p: ArsenalPitch }) {
  const meta = arsenalMeta(p.pitch_type);
  const grade = gradientColor(actionPlusFrac(p.action_plus));
  return (
    <View style={styles.row}>
      <View style={styles.headRow}>
        <View style={styles.nameBox}>
          <View style={[styles.dot, { backgroundColor: meta.color }]} />
          <Text style={styles.name}>{meta.name}</Text>
          <Text style={styles.usage}>{Math.round(p.usage * 100)}%</Text>
        </View>
        <View style={[styles.grade, { borderColor: grade }]}>
          <Text style={[styles.gradeValue, { color: grade }]}>{Math.round(p.action_plus)}</Text>
          <Text style={styles.gradeLabel}>ACTION+</Text>
        </View>
      </View>
      <View style={styles.metrics}>
        <Metric label="VELO" value={p.velo != null ? `${fmt(p.velo, 1)}` : '—'} />
        <Metric label="IVB" value={p.ivb != null ? `${fmt(p.ivb, 1)}"` : '—'} />
        <Metric label="HB" value={p.hb != null ? `${fmt(p.hb, 1)}"` : '—'} />
        <Metric label="SPIN" value={p.spin != null ? `${Math.round(p.spin)}` : '—'} />
        <Metric label="EXT" value={p.ext != null ? `${fmt(p.ext, 1)}'` : '—'} />
      </View>
    </View>
  );
}

/** Per-pitch Action+ arsenal: one row per pitch type, run-value-graded with the percentile gradient. */
export function ArsenalActionCards({ pitches }: { pitches: ArsenalPitch[] }) {
  if (!pitches.length) return null;
  return (
    <Card style={styles.card}>
      <Text style={styles.title}>ARSENAL · ACTION+</Text>
      {pitches.map((p) => (
        <PitchRow key={p.pitch_type} p={p} />
      ))}
      <Text style={styles.footnote}>Action+ proxy from per-pitch run value (100 = league average).</Text>
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
  row: {
    borderTopWidth: StyleSheet.hairlineWidth,
    borderTopColor: colors.hairline,
    paddingVertical: spacing.md,
  },
  headRow: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' },
  nameBox: { flexDirection: 'row', alignItems: 'center', flex: 1 },
  dot: { width: 12, height: 12, borderRadius: 6, marginRight: spacing.sm },
  name: { fontFamily: fonts.archivo, fontSize: 18, color: colors.white },
  usage: { fontFamily: fonts.archivo, fontSize: 14, color: colors.gray, marginLeft: spacing.sm },
  grade: { borderWidth: 1.5, borderRadius: radius.sm, paddingHorizontal: spacing.sm, paddingVertical: 2, alignItems: 'center', minWidth: 56 },
  gradeValue: { fontFamily: fonts.norwester, fontSize: 20 },
  gradeLabel: { fontFamily: fonts.archivo, fontSize: 9, color: colors.gray, letterSpacing: 1 },
  metrics: { flexDirection: 'row', marginTop: spacing.sm },
  metric: { flex: 1, alignItems: 'center' },
  metricLabel: { ...typography.subSectionText, color: colors.gray, fontSize: 11, marginBottom: 2 },
  metricValue: { fontFamily: fonts.archivo, fontSize: 15, color: colors.white },
  footnote: { ...typography.subSectionText, color: colors.gray, fontSize: 11, marginTop: spacing.sm },
});
