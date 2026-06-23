import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import Svg, { Circle, Line, Text as SvgText } from 'react-native-svg';
import { colors, typography } from '@/theme';
import type { PitchPoint } from '@/types';

const MAX_INCHES = 24;

/**
 * Pitch Movement Profile scatter (PitchGraphView): concentric inch rings + crosshair spokes,
 * with each pitch plotted by horizontal/induced-vertical break. L/R arrows above, legend below.
 */
export function PitchScatterChart({ points, size = 320 }: { points: PitchPoint[]; size?: number }) {
  const center = size / 2;
  const R = center - 5;
  const scale = R / MAX_INCHES;
  const rings = [0.25, 0.5, 0.75];
  const ticks = [6, 12, 18, 24];

  return (
    <View style={styles.wrapper}>
      <View style={styles.axisRow}>
        <Ionicons name="arrow-back" size={22} color={colors.white} />
        <Text style={styles.axisLabel}>L</Text>
        <Text style={styles.axisGap} />
        <Text style={styles.axisLabel}>R</Text>
        <Ionicons name="arrow-forward" size={22} color={colors.white} />
      </View>

      <Svg width={size} height={size}>
        <Circle cx={center} cy={center} r={R} stroke={colors.white} strokeWidth={4} fill="none" />
        {rings.map((f) => (
          <Circle key={f} cx={center} cy={center} r={R * f} stroke={colors.white} strokeOpacity={0.5} strokeWidth={2} fill="none" />
        ))}
        <Line x1={0} y1={center} x2={size} y2={center} stroke={colors.white} strokeWidth={2} />
        <Line x1={center} y1={0} x2={center} y2={size} stroke={colors.white} strokeWidth={2} />
        {ticks.map((t) => (
          <SvgText key={t} x={center + scale * t - 2} y={center - 6} fill={colors.white} fontSize={11} textAnchor="middle">
            {`${t}''`}
          </SvgText>
        ))}
        {points.map((p, i) => (
          <Circle
            key={i}
            cx={center + scale * p.x}
            cy={center - scale * p.y}
            r={20}
            fill={p.color}
            fillOpacity={0.5}
            stroke={p.color}
            strokeWidth={3}
          />
        ))}
      </Svg>

      <View style={styles.legend}>
        {points.map((p, i) => (
          <View key={i} style={styles.legendItem}>
            <View style={[styles.swatch, { backgroundColor: p.color, borderColor: p.color }]} />
            <Text style={styles.legendText}>{p.pitchName}</Text>
          </View>
        ))}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  wrapper: { alignItems: 'center' },
  axisRow: { flexDirection: 'row', alignItems: 'center', marginBottom: 24 },
  axisLabel: { ...typography.text, color: colors.white, marginHorizontal: 6 },
  axisGap: { width: 24 },
  legend: { flexDirection: 'row', flexWrap: 'wrap', justifyContent: 'center', marginTop: 16, gap: 16 },
  legendItem: { alignItems: 'center' },
  swatch: { width: 44, height: 18, borderRadius: 9, borderWidth: 3, opacity: 0.6 },
  legendText: { ...typography.smallText, color: colors.white, marginTop: 4 },
});
