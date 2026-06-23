import React from 'react';
import { StyleSheet, Text } from 'react-native';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import { ScreenContainer } from '@/components/ScreenContainer';
import { teamByBR } from '@/utils/teams';
import { colors, typography } from '@/theme';
import type { ProfileStackParamList } from '@/navigation/types';

/** TODO: full team profile page is translated in a later wave of Task 6. */

export function TeamPageScreen({ route }: NativeStackScreenProps<ProfileStackParamList, 'TeamPage'>) {
  const team = teamByBR(route.params.teamAbbr);
  return (
    <ScreenContainer scroll contentStyle={styles.center} background={colors.pageBackground}>
      <Text style={styles.title}>{team?.fullName ?? route.params.teamAbbr}</Text>
      <Text style={styles.subtitle}>Team page coming soon</Text>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  center: { alignItems: 'center', justifyContent: 'center', flexGrow: 1, padding: 24 },
  title: { ...typography.title, color: colors.primary, textAlign: 'center' },
  subtitle: { ...typography.smallText, color: colors.lightGray, marginTop: 8 },
});
