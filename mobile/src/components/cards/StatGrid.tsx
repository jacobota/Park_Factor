import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { colors, typography } from '@/theme';

/** Six-column label/value grid used at the bottom of the player & team stat cards. */
export function StatGrid({ cells }: { cells: { label: string; value: string }[] }) {
  return (
    <View style={styles.grid}>
      {cells.map((c) => (
        <View key={c.label} style={styles.cell}>
          <Text style={styles.label}>{c.label}</Text>
          <Text style={styles.value}>{c.value}</Text>
        </View>
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  grid: { flexDirection: 'row', paddingHorizontal: 20, paddingBottom: 20 },
  cell: { flex: 1, alignItems: 'center' },
  label: { ...typography.subSectionText, color: colors.gray, marginBottom: 4 },
  value: { ...typography.subSectionText, color: colors.white },
});
