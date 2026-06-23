import React, { useMemo, useState } from 'react';
import { ActivityIndicator, FlatList, StyleSheet, Text, View } from 'react-native';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import { useQuery } from '@tanstack/react-query';
import { TabScreen } from '@/components/TabScreen';
import { PlayerSearchBar } from '@/components/PlayerSearchBar';
import { FollowCard } from '@/components/cards/FollowCard';
import { getAllPlayers, getAllTeams } from '@/api/stats';
import { updateFollowingPlayers, updateFollowingTeams } from '@/api/user';
import { useAuth } from '@/context/AuthContext';
import { playerFullName } from '@/types';
import type { Player, Team } from '@/types';
import { playerHeadshotUrl } from '@/utils/images';
import { teamByBR } from '@/utils/teams';
import { colors, spacing, typography } from '@/theme';
import type { FollowingStackParamList } from '@/navigation/types';

const teamLogo = (team: Team) => `https://cdn.ssref.net/req/202502211/tlogo/br/${team.franchID}.png`;

type Props = NativeStackScreenProps<FollowingStackParamList, 'FollowingHome'>;

/** FollowingView — Teams / Players follow management. */
export function FollowingScreen({ navigation }: Props) {
  const [tab, setTab] = useState('Teams');
  return (
    <TabScreen title="Following" tabs={['Teams', 'Players']} selected={tab} onSelect={setTab}>
      {tab === 'Teams' ? <TeamsSection navigation={navigation} /> : <PlayersSection navigation={navigation} />}
    </TabScreen>
  );
}

/** TeamsFollowingPageView — followed teams first, then the rest; tap to open a team page. */
function TeamsSection({ navigation }: { navigation: Props['navigation'] }) {
  const { user, setUser } = useAuth();
  const { data, isLoading } = useQuery({ queryKey: ['all-teams'], queryFn: getAllTeams });
  const following = user?.followingTeams ?? [];
  const isFollowing = (t: Team) => following.some((f) => f.teamIDBR === t.teamIDBR);

  const toggle = async (team: Team) => {
    if (!user) return;
    const next = isFollowing(team)
      ? following.filter((f) => f.teamIDBR !== team.teamIDBR)
      : [...following, team];
    await setUser({ ...user, followingTeams: next });
    try {
      await updateFollowingTeams(next);
    } catch {
      await setUser({ ...user, followingTeams: following });
    }
  };

  const ordered = useMemo(() => {
    const all = data ?? [];
    const followed = all.filter(isFollowing);
    const rest = all.filter((t) => !isFollowing(t));
    return [...followed, ...rest];
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [data, following]);

  if (isLoading) return <Center />;

  return (
    <FlatList<Team>
      data={ordered}
      keyExtractor={(t) => t.teamIDBR}
      style={styles.fill}
      contentContainerStyle={styles.list}
      renderItem={({ item }) => (
        <FollowCard
          imageUri={teamLogo(item)}
          name={teamByBR(item.teamIDBR)?.fullName ?? item.teamIDBR}
          isSelected={isFollowing(item)}
          onToggle={() => toggle(item)}
          onPress={() => navigation.navigate('TeamPage', { teamAbbr: item.teamIDBR })}
        />
      )}
    />
  );
}

/** PlayersFollowingPageView — followed players, or live search results when searching. */
function PlayersSection({ navigation }: { navigation: Props['navigation'] }) {
  const { user, setUser } = useAuth();
  const [search, setSearch] = useState('');
  const { data, isLoading } = useQuery({ queryKey: ['all-players'], queryFn: getAllPlayers });
  const following = user?.followingPlayers ?? [];
  const isFollowing = (p: Player) => following.some((f) => f.keyMlbam === p.keyMlbam);

  const toggle = async (player: Player) => {
    if (!user) return;
    const next = isFollowing(player)
      ? following.filter((f) => f.keyMlbam !== player.keyMlbam)
      : [...following, player];
    await setUser({ ...user, followingPlayers: next });
    try {
      await updateFollowingPlayers(next);
    } catch {
      await setUser({ ...user, followingPlayers: following });
    }
  };

  const results = useMemo(() => {
    if (!search.trim()) return following;
    const q = search.toLowerCase();
    return (data ?? []).filter((p) => playerFullName(p).toLowerCase().includes(q));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [search, data, following]);

  return (
    <FlatList<Player>
      data={results}
      keyExtractor={(p, i) => `${p.keyMlbam ?? i}`}
      style={styles.fill}
      contentContainerStyle={styles.list}
      keyboardShouldPersistTaps="handled"
      ListHeaderComponent={
        <>
          <PlayerSearchBar value={search} onChangeText={setSearch} />
          {!!search.trim() && <Text style={styles.subheading}>Search Results</Text>}
        </>
      }
      renderItem={({ item }) => (
        <FollowCard
          imageUri={playerHeadshotUrl(item.keyMlbam)}
          name={playerFullName(item)}
          isSelected={isFollowing(item)}
          onToggle={() => toggle(item)}
          onPress={() => navigation.navigate('PlayerPage', { player: item })}
        />
      )}
      ListEmptyComponent={
        isLoading ? <Center /> : <Text style={styles.message}>{search.trim() ? 'No matches' : 'Not following anyone yet'}</Text>
      }
    />
  );
}

const Center = () => (
  <View style={styles.center}>
    <ActivityIndicator color={colors.primary} />
  </View>
);

const styles = StyleSheet.create({
  fill: { flex: 1 },
  list: { padding: spacing.lg, flexGrow: 1 },
  center: { paddingVertical: spacing.xl, alignItems: 'center' },
  subheading: { ...typography.textNorwester, color: colors.gray, marginBottom: spacing.md, marginTop: spacing.sm },
  message: { ...typography.smallText, color: colors.lightGray, textAlign: 'center', marginTop: spacing.lg },
});
