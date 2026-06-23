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
  row: { flexDirection: 'row', alignItems: 'center', paddingHorizontal: 16, paddingTop: 4, paddingBottom: 8 },
  logo: { width: 40, height: 40, borderRadius: 7, marginRight: 10 },
  title: { ...typography.bigTextNorwester, fontSize: 25, color: colors.primary },
});
