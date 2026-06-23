import React from 'react';
import { ActivityIndicator, StyleSheet, Text, View } from 'react-native';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import { useQuery } from '@tanstack/react-query';
import { getTeamByAbbr } from '@/api/teams';
import { RespectiveTeamPage } from './RespectiveTeamPage';
import { ScreenContainer } from '@/components/ScreenContainer';
import { teamByBR } from '@/utils/teams';
import { colors, spacing, typography } from '@/theme';
import type { ProfileStackParamList } from '@/navigation/types';

/**
 * TeamPageView — resolves a Team record from its Baseball-Reference abbr, then renders the
 * full profile (RespectiveTeamPageView) or a not-found page (TeamNoDataPageView).
 */
export function TeamPage({ route }: NativeStackScreenProps<ProfileStackParamList, 'TeamPage'>) {
  const { teamAbbr } = route.params;
  const { data, isLoading } = useQuery({
    queryKey: ['team-by-abbr', teamAbbr],
    queryFn: () => getTeamByAbbr(teamAbbr),
  });

  if (isLoading) {
    return (
      <View style={styles.loading}>
        <ActivityIndicator color={colors.primary} />
      </View>
    );
  }

  const team = data?.[0];
  if (team) return <RespectiveTeamPage team={team} />;

  // TeamNoDataPageView
  return (
    <ScreenContainer scroll background={colors.pageBackground} contentStyle={styles.center}>
      <Text style={styles.title}>Apologies!</Text>
      <Text style={styles.title}>Could not find stats for</Text>
      <Text style={styles.title}>{teamByBR(teamAbbr)?.fullName ?? teamAbbr}</Text>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  loading: { flex: 1, backgroundColor: colors.pageBackground, alignItems: 'center', justifyContent: 'center' },
  center: { flexGrow: 1, alignItems: 'center', justifyContent: 'center', padding: spacing.xl },
  title: { ...typography.title, color: colors.primary, textAlign: 'center' },
});
