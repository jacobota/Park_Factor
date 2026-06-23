import React from 'react';
import { ActivityIndicator, StyleSheet, Text, View } from 'react-native';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import { useQuery } from '@tanstack/react-query';
import { HitterPage } from './HitterPage';
import { PitcherPage } from './PitcherPage';
import { HitterPreviewPage, PitcherPreviewPage } from './PreviewPage';
import { ScreenContainer } from '@/components/ScreenContainer';
import {
  getHitterPreviewStats,
  getHitterSeasonStats,
  getPitcherPreviewStats,
  getPitcherSeasonStats,
} from '@/api/stats';
import { playerFullName } from '@/types';
import { colors, spacing, typography } from '@/theme';
import type { ProfileStackParamList } from '@/navigation/types';

/**
 * PlayerPageView — fetches season + preview stats and routes to the matching page, in priority
 * order: hitter season → pitcher season → hitter preview → pitcher preview → no data.
 */
export function PlayerPage({ route }: NativeStackScreenProps<ProfileStackParamList, 'PlayerPage'>) {
  const { player } = route.params;
  const fgId = player.keyFangraphs ?? 0;
  const mlbamId = player.keyMlbam ?? 0;

  const hitter = useQuery({ queryKey: ['hitter-season', fgId, mlbamId], queryFn: () => getHitterSeasonStats(fgId, mlbamId) });
  const pitcher = useQuery({ queryKey: ['pitcher-season', fgId, mlbamId], queryFn: () => getPitcherSeasonStats(fgId, mlbamId) });
  const hitterPreview = useQuery({ queryKey: ['hitter-preview', mlbamId], queryFn: () => getHitterPreviewStats(mlbamId) });
  const pitcherPreview = useQuery({ queryKey: ['pitcher-preview', mlbamId], queryFn: () => getPitcherPreviewStats(mlbamId) });

  const loading = hitter.isLoading || pitcher.isLoading || hitterPreview.isLoading || pitcherPreview.isLoading;

  if (loading) {
    return (
      <View style={styles.loading}>
        <ActivityIndicator color={colors.primary} />
      </View>
    );
  }

  if (hitter.data) return <HitterPage player={player} stats={hitter.data} />;
  if (pitcher.data) return <PitcherPage player={player} stats={pitcher.data} />;
  if (hitterPreview.data?.[0]) return <HitterPreviewPage player={player} stats={hitterPreview.data[0]} />;
  if (pitcherPreview.data?.[0]) return <PitcherPreviewPage player={player} stats={pitcherPreview.data[0]} />;

  // PlayerNoDataPageView
  return (
    <ScreenContainer scroll background={colors.pageBackground} contentStyle={styles.center}>
      <Text style={styles.title}>{playerFullName(player)}</Text>
      <Text style={styles.subtitle}>No stats available</Text>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  center: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: spacing.xl },
  loading: { flex: 1, backgroundColor: colors.pageBackground, alignItems: 'center', justifyContent: 'center' },
  title: { ...typography.title, color: colors.primary, textAlign: 'center' },
  subtitle: { ...typography.smallText, color: colors.lightGray, marginTop: spacing.sm },
});
