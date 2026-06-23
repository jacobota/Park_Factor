import React, { useMemo, useState } from 'react';
import { ActivityIndicator, StyleSheet, Text, View } from 'react-native';
import { useQuery } from '@tanstack/react-query';
import { PlayerStatCard } from '@/components/cards/PlayerStatCard';
import { PlayerSearchBar } from '@/components/PlayerSearchBar';
import { getAllPlayers } from '@/api/stats';
import { useAuth } from '@/context/AuthContext';
import { playerFullName } from '@/types';
import type { Player } from '@/types';
import { colors, typography } from '@/theme';

const isFollowed = (player: Player, following: Player[]) =>
  following.some((p) => p.keyMlbam === player.keyMlbam);

/** PlayerFollowingStatsView — cards for the user's followed players. */
export function PlayerFollowingList() {
  const { user } = useAuth();
  const players = user?.followingPlayers ?? [];

  if (players.length === 0) return <Text style={styles.empty}>N/A</Text>;
  return (
    <View style={styles.list}>
      {players.map((player) => (
        <PlayerStatCard key={player.keyMlbam ?? playerFullName(player)} player={player} isFollowing />
      ))}
    </View>
  );
}

/** PlayerLookupStatsView — search the full player list by name prefix. */
export function PlayerLookupList() {
  const { user } = useAuth();
  const [search, setSearch] = useState('');
  const { data: players, isLoading } = useQuery({ queryKey: ['all-players'], queryFn: getAllPlayers });

  const cap = search.charAt(0).toUpperCase() + search.slice(1);
  const filtered = useMemo(() => {
    if (!search || !players) return [];
    return players.filter((p) => playerFullName(p).startsWith(cap));
  }, [search, cap, players]);

  return (
    <View style={styles.list}>
      <PlayerSearchBar value={search} onChangeText={setSearch} />
      <Text style={styles.heading}>Search Results</Text>
      {isLoading && <ActivityIndicator color={colors.primary} style={styles.loading} />}
      {filtered.map((player) => (
        <PlayerStatCard
          key={player.keyMlbam ?? playerFullName(player)}
          player={player}
          isFollowing={isFollowed(player, user?.followingPlayers ?? [])}
        />
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  list: { paddingHorizontal: 16 },
  empty: { ...typography.bigTextNorwester, color: colors.white, textAlign: 'center', marginTop: 16 },
  heading: { ...typography.subtitleNorwester, color: colors.white, marginVertical: 12 },
  loading: { marginVertical: 16 },
});
