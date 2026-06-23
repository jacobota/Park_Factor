import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { colors, fonts } from '@/theme';

/**
 * Sleek category eyebrow: a colored dot + an uppercase, letter-spaced label, with an optional
 * dimmer secondary string (e.g. "TONIGHT · tonight"). Used at the top of feed cards.
 */
export function Eyebrow({
  label,
  secondary,
  color = colors.good,
  dot = true,
}: {
  label: string;
  secondary?: string;
  color?: string;
  dot?: boolean;
}) {
  return (
    <View style={styles.row}>
      {dot && <View style={[styles.dot, { backgroundColor: color }]} />}
      <Text style={[styles.label, { color }]}>{label.toUpperCase()}</Text>
      {!!secondary && <Text style={styles.secondary}>· {secondary}</Text>}
    </View>
  );
}

const styles = StyleSheet.create({
  row: { flexDirection: 'row', alignItems: 'center' },
  dot: { width: 7, height: 7, borderRadius: 4, marginRight: 8 },
  label: { fontFamily: fonts.norwester, fontSize: 12, letterSpacing: 1.5 },
  secondary: { fontFamily: fonts.archivo, fontSize: 13, color: colors.gray, marginLeft: 6, letterSpacing: 0.3 },
});
