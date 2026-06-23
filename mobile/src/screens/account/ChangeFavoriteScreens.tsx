import React from 'react';
import { FlatList, StyleSheet, Text } from 'react-native';
import { updateFavoritePlayer, updateFavoriteTeam } from '@/api/user';
import { FollowCard } from '@/components/cards/FollowCard';
import { useAuth } from '@/context/AuthContext';
import { playerFullName } from '@/types';
import type { Player, Team } from '@/types';
import { playerHeadshotUrl } from '@/utils/images';
import { teamByBR } from '@/utils/teams';
import { colors, spacing, typography } from '@/theme';

const teamLogo = (team: Team) => `https://cdn.ssref.net/req/202502211/tlogo/br/${team.franchID}.png`;

/** ChangeFavoriteTeamView — pick the favorite from your followed teams (tap again to clear). */
export function ChangeFavoriteTeamScreen() {
  const { user, setUser } = useAuth();
  const teams = user?.followingTeams ?? [];
  const favorite = user?.favoriteTeam ?? null;

  const choose = async (team: Team) => {
    if (!user) return;
    const next = favorite?.franchID === team.franchID ? null : team;
    await setUser({ ...user, favoriteTeam: next });
    try {
      await updateFavoriteTeam(next);
    } catch {
      await setUser({ ...user, favoriteTeam: favorite });
    }
  };

  return (
    <FlatList<Team>
      data={teams}
      keyExtractor={(t) => t.teamIDBR}
      contentContainerStyle={styles.content}
      ListHeaderComponent={<Text style={styles.title}>Select Your Favorite Team</Text>}
      ListEmptyComponent={<Text style={styles.message}>Follow some teams first</Text>}
      renderItem={({ item }) => (
        <FollowCard
          imageUri={teamLogo(item)}
          name={teamByBR(item.teamIDBR)?.fullName ?? item.teamIDBR}
          isSelected={favorite?.franchID === item.franchID}
          onToggle={() => choose(item)}
        />
      )}
    />
  );
}

/** ChangeFavoritePlayerView — pick the favorite from your followed players. */
export function ChangeFavoritePlayerScreen() {
  const { user, setUser } = useAuth();
  const players = user?.followingPlayers ?? [];
  const favorite = user?.favoritePlayer ?? null;

  const choose = async (player: Player) => {
    if (!user) return;
    const next = favorite?.keyMlbam === player.keyMlbam ? null : player;
    await setUser({ ...user, favoritePlayer: next });
    try {
      await updateFavoritePlayer(next);
    } catch {
      await setUser({ ...user, favoritePlayer: favorite });
    }
  };

  return (
    <FlatList<Player>
      data={players}
      keyExtractor={(p, i) => `${p.keyMlbam ?? i}`}
      contentContainerStyle={styles.content}
      ListHeaderComponent={<Text style={styles.title}>Select Your Favorite Player</Text>}
      ListEmptyComponent={<Text style={styles.message}>Follow some players first</Text>}
      renderItem={({ item }) => (
        <FollowCard
          imageUri={playerHeadshotUrl(item.keyMlbam)}
          name={playerFullName(item)}
          isSelected={favorite?.keyMlbam === item.keyMlbam}
          onToggle={() => choose(item)}
        />
      )}
    />
  );
}

const styles = StyleSheet.create({
  content: { padding: spacing.lg, backgroundColor: colors.pageBackground, flexGrow: 1 },
  title: { ...typography.subtitleNorwester, color: colors.white, textAlign: 'center', marginBottom: spacing.lg },
  message: { ...typography.smallText, color: colors.lightGray, textAlign: 'center', marginTop: spacing.xl },
});
