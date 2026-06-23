import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { colors, fonts } from '@/theme';

/** Uppercase, letter-spaced gray section divider label ("BREAKING", "TOP HIGHLIGHTS"). */
export function SectionLabel({ label, right }: { label: string; right?: React.ReactNode }) {
  return (
    <View style={styles.row}>
      <Text style={styles.label}>{label.toUpperCase()}</Text>
      {right}
    </View>
  );
}

const styles = StyleSheet.create({
  row: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', marginBottom: 10, marginTop: 4 },
  label: { fontFamily: fonts.norwester, fontSize: 13, letterSpacing: 1.5, color: colors.gray },
});
