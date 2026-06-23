import React from 'react';
import { ActivityIndicator, FlatList, StyleSheet, Text, View } from 'react-native';
import { useQuery } from '@tanstack/react-query';
import { getTeamSchedule } from '@/api/teams';
import { TeamGameCard } from '@/components/cards/TeamGameCard';
import { TeamOverviewCard } from '@/components/cards/TeamOverviewCard';
import type { GameDetails } from '@/types';
import { colors, spacing, typography } from '@/theme';

/**
 * Schedule subtab. The Swift view paired a DatePicker with a single game card; on mobile we
 * lead with the record overview + last game played, then list every game (most recent first).
 */
export function TeamScheduleSection({ teamAbbr }: { teamAbbr: string }) {
  const { data, isLoading, isError } = useQuery({
    queryKey: ['team-schedule', teamAbbr],
    queryFn: () => getTeamSchedule(teamAbbr),
  });

  if (isLoading) {
    return (
      <View style={styles.center}>
        <ActivityIndicator color={colors.primary} />
      </View>
    );
  }
  if (isError || !data) {
    return (
      <View style={styles.center}>
        <Text style={styles.message}>Schedule unavailable</Text>
      </View>
    );
  }

  const played = data.filter((g) => g.R != null);
  const lastGame = played[played.length - 1];
  const games = [...data].reverse();

  return (
    <FlatList<GameDetails>
      data={games}
      keyExtractor={(g, i) => `${g.Date ?? 'g'}-${i}`}
      contentContainerStyle={styles.content}
      ListHeaderComponent={
        <>
          <TeamOverviewCard game={lastGame} />
          <TeamGameCard game={lastGame} label="Last Game Played" />
          <Text style={styles.heading}>Full Schedule</Text>
        </>
      }
      renderItem={({ item }) => <TeamGameCard game={item} />}
    />
  );
}

const styles = StyleSheet.create({
  content: { padding: spacing.lg },
  center: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: spacing.xl },
  message: { ...typography.smallText, color: colors.lightGray },
  heading: { ...typography.subtitleNorwester, color: colors.white, marginTop: spacing.md, marginBottom: spacing.sm },
});
