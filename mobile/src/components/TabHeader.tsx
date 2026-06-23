import React from 'react';
import { Image, StyleSheet, Text, View } from 'react-native';
import { colors, typography } from '@/theme';

/** Logo + title header used at the top of each main tab (SwiftUI toolbar leading item). */
export function TabHeader({ title }: { title: string }) {
  return (
    <View style={styles.row}>
      <Image source={require('@/assets/ParkFactorLogo.jpg')} style={styles.logo} resizeMode="contain" />
      <Text style={styles.title}>{title}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  row: { flexDirection: 'row', alignItems: 'center', paddingHorizontal: 16, paddingVertical: 8 },
  logo: { width: 48, height: 48, borderRadius: 8, marginRight: 8 },
  title: { ...typography.title, color: colors.primary },
});
