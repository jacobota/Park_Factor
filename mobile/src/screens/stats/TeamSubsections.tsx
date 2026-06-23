import React from 'react';
import { ActivityIndicator, StyleSheet, Text, View } from 'react-native';
import { useQuery } from '@tanstack/react-query';
import { TeamStatCard } from '@/components/cards/TeamStatCard';
import { getAllTeams } from '@/api/stats';
import { useAuth } from '@/context/AuthContext';
import type { Team } from '@/types';
import { colors, typography } from '@/theme';

const isFollowed = (team: Team, following: Team[]) =>
  following.some((t) => t.teamIDBR === team.teamIDBR);

/** TeamFollowingStatsView — cards for the user's followed teams. */
export function TeamFollowingList() {
  const { user } = useAuth();
  const teams = user?.followingTeams ?? [];

  if (teams.length === 0) return <Text style={styles.empty}>N/A</Text>;
  return (
    <View style={styles.list}>
      {teams.map((team) => (
        <TeamStatCard key={team.teamIDBR} team={team} isFollowing />
      ))}
    </View>
  );
}

/** AllTeamsStatsView — cards for every team. */
export function AllTeamsList() {
  const { user } = useAuth();
  const { data: teams, isLoading } = useQuery({ queryKey: ['all-teams'], queryFn: getAllTeams });

  if (isLoading) return <ActivityIndicator color={colors.primary} style={styles.loading} />;
  return (
    <View style={styles.list}>
      {(teams ?? []).map((team) => (
        <TeamStatCard
          key={team.teamIDBR}
          team={team}
          isFollowing={isFollowed(team, user?.followingTeams ?? [])}
        />
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  list: { paddingHorizontal: 16 },
  empty: { ...typography.bigTextNorwester, color: colors.white, textAlign: 'center', marginTop: 16 },
  loading: { marginVertical: 16 },
});
