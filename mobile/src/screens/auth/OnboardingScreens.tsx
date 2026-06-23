import React, { useMemo, useState } from 'react';
import { ActivityIndicator, FlatList, StyleSheet, Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import { useQuery } from '@tanstack/react-query';
import { ScreenContainer } from '@/components/ScreenContainer';
import { PrimaryButton } from '@/components/PrimaryButton';
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
import type { AuthStackParamList } from '@/navigation/types';

const teamLogo = (team: Team) => `https://cdn.ssref.net/req/202502211/tlogo/br/${team.franchID}.png`;

/** FollowingTeamsView (signup) — choose teams to follow, persist, then move to players. */
export function OnboardingTeamsScreen({
  navigation,
  route,
}: NativeStackScreenProps<AuthStackParamList, 'OnboardingTeams'>) {
  const { user, token } = route.params;
  const { data, isLoading } = useQuery({ queryKey: ['all-teams'], queryFn: getAllTeams });
  const [selected, setSelected] = useState<Team[]>([]);
  const [busy, setBusy] = useState(false);

  const isSelected = (t: Team) => selected.some((s) => s.teamIDBR === t.teamIDBR);
  const toggle = (t: Team) =>
    setSelected((cur) => (isSelected(t) ? cur.filter((s) => s.teamIDBR !== t.teamIDBR) : [...cur, t]));

  const onContinue = async () => {
    setBusy(true);
    try {
      await updateFollowingTeams(selected);
    } catch {
      /* keep going; onboarding selections are best-effort */
    }
    navigation.navigate('OnboardingPlayers', { user: { ...user, followingTeams: selected }, token });
    setBusy(false);
  };

  return (
    <SafeAreaView edges={['top', 'left', 'right']} style={styles.container}>
      <Text style={styles.title}>Select Following Teams</Text>
      {isLoading ? (
        <Center />
      ) : (
        <FlatList<Team>
          data={data ?? []}
          keyExtractor={(t) => t.teamIDBR}
          contentContainerStyle={styles.list}
          renderItem={({ item }) => (
            <FollowCard
              imageUri={teamLogo(item)}
              name={teamByBR(item.teamIDBR)?.fullName ?? item.teamIDBR}
              isSelected={isSelected(item)}
              onToggle={() => toggle(item)}
            />
          )}
        />
      )}
      <PrimaryButton title="Continue" onPress={onContinue} disabled={busy} style={styles.button} />
    </SafeAreaView>
  );
}

/** FollowingPlayersView (signup) — choose players, persist, then finish sign-in. */
export function OnboardingPlayersScreen({
  route,
}: NativeStackScreenProps<AuthStackParamList, 'OnboardingPlayers'>) {
  const { user, token } = route.params;
  const { signIn } = useAuth();
  const { data, isLoading } = useQuery({ queryKey: ['all-players'], queryFn: getAllPlayers });
  const [selected, setSelected] = useState<Player[]>([]);
  const [search, setSearch] = useState('');
  const [busy, setBusy] = useState(false);

  const isSelected = (p: Player) => selected.some((s) => s.keyMlbam === p.keyMlbam);
  const toggle = (p: Player) =>
    setSelected((cur) => (isSelected(p) ? cur.filter((s) => s.keyMlbam !== p.keyMlbam) : [...cur, p]));

  const results = useMemo(() => {
    if (!search.trim()) return selected;
    const q = search.toLowerCase();
    return (data ?? []).filter((p) => playerFullName(p).toLowerCase().includes(q));
  }, [search, data, selected]);

  const onFinish = async () => {
    setBusy(true);
    try {
      await updateFollowingPlayers(selected);
    } catch {
      /* best-effort */
    }
    await signIn({ ...user, followingPlayers: selected }, token);
  };

  return (
    <SafeAreaView edges={['top', 'left', 'right']} style={styles.container}>
      <Text style={styles.title}>Select Following Players</Text>
      <PlayerSearchBar value={search} onChangeText={setSearch} />
      {isLoading ? (
        <Center />
      ) : (
        <FlatList<Player>
          data={results}
          keyExtractor={(p, i) => `${p.keyMlbam ?? i}`}
          contentContainerStyle={styles.list}
          keyboardShouldPersistTaps="handled"
          renderItem={({ item }) => (
            <FollowCard
              imageUri={playerHeadshotUrl(item.keyMlbam)}
              name={playerFullName(item)}
              isSelected={isSelected(item)}
              onToggle={() => toggle(item)}
            />
          )}
          ListEmptyComponent={<Text style={styles.message}>{search.trim() ? 'No matches' : 'Search to add players'}</Text>}
        />
      )}
      <PrimaryButton title="Enter Park Factor" onPress={onFinish} disabled={busy} style={styles.button} />
    </SafeAreaView>
  );
}

const Center = () => (
  <View style={styles.center}>
    <ActivityIndicator color={colors.primary} />
  </View>
);

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.secondary, paddingTop: spacing.xl },
  title: { ...typography.title, color: colors.white, textAlign: 'center', marginBottom: spacing.md },
  list: { paddingHorizontal: spacing.lg, paddingBottom: spacing.lg },
  center: { flex: 1, alignItems: 'center', justifyContent: 'center' },
  message: { ...typography.smallText, color: colors.lightGray, textAlign: 'center', marginTop: spacing.xl },
  button: { alignSelf: 'center', minWidth: '60%', marginVertical: spacing.lg },
});
