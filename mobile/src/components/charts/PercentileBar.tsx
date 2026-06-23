import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { colors } from '@/theme';

/** Bucketed percentile color (PercentileView.percentileColor). */
export function percentileColor(p: number): string {
  if (p > 97) return '#FFD700';
  if (p > 90) return '#006400';
  if (p > 75) return '#ADFF2F';
  if (p > 50) return '#FFFF00';
  if (p > 25) return '#FFA500';
  if (p > 5) return '#FF0000';
  return '#8B0000';
}

/** Horizontal percentile bar with the value at the end of the fill. */
export function PercentileBar({ percentile }: { percentile: number }) {
  const pct = Math.max(0, Math.min(100, percentile));
  return (
    <View style={styles.track}>
      <View style={[styles.fill, { width: `${pct}%`, backgroundColor: percentileColor(pct) }]}>
        <Text style={styles.value}>{Math.round(pct)}</Text>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  track: {
    height: 20,
    borderRadius: 10,
    borderWidth: 2,
    borderColor: colors.gray,
    backgroundColor: colors.pageBackground,
    justifyContent: 'center',
    overflow: 'hidden',
  },
  fill: { height: '100%', borderRadius: 9, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' },
  value: { color: '#000', fontWeight: '700', fontSize: 13, paddingRight: 8 },
});
