import React from 'react';
import { ActivityIndicator, Image, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { useQuery } from '@tanstack/react-query';
import { lookupPlayerByName } from '@/api/stats';
import { playerHeadshotUrl } from '@/utils/images';
import { resolveLeaderboardName, pickLeaderboardPlayer } from '@/utils/playerNames';
import { mascotByFG, teamByFG, teamColorByFG, teamLogoUrlByFG } from '@/utils/teams';
import { colors, typography } from '@/theme';
import type { LeaderboardEntry } from '@/types';
import type { ProfileStackParamList } from '@/navigation/types';

type Nav = NativeStackNavigationProp<ProfileStackParamList>;

const format = (value: number, decimals: number) => value.toFixed(decimals);

function Rank({ index }: { index: number }) {
  return <Text style={styles.rank}>{index + 1}</Text>;
}

/** Player leaderboard row: resolves the player (for headshot + navigation) by name. */
export function PlayerLeaderboardRow({
  index,
  entry,
  decimals,
  isPitching,
}: {
  index: number;
  entry: LeaderboardEntry;
  decimals: number;
  isPitching: boolean;
}) {
  const navigation = useNavigation<Nav>();
  const { first, last } = resolveLeaderboardName(entry.name ?? '');

  const { data: player } = useQuery({
    queryKey: ['player-id', first, last],
    queryFn: () => lookupPlayerByName(first, last),
    select: (results) => pickLeaderboardPlayer(results, first, last, isPitching),
    enabled: !!first && !!last,
    staleTime: 24 * 60 * 60 * 1000,
  });

  return (
    <TouchableOpacity
      style={styles.row}
      disabled={!player}
      activeOpacity={0.7}
      onPress={() => player && navigation.push('PlayerPage', { player })}
    >
      <Rank index={index} />
      <View style={[styles.avatar, { backgroundColor: teamColorByFG(entry.team) }]}>
        {player ? (
          <Image source={{ uri: playerHeadshotUrl(player.keyMlbam) }} style={styles.avatarImg} />
        ) : (
          <ActivityIndicator size="small" color={colors.white} />
        )}
      </View>
      <Text style={styles.name} numberOfLines={1}>
        {entry.name}
      </Text>
      <View style={styles.spacer} />
      <Text style={styles.value}>{format(entry.value, decimals)}</Text>
    </TouchableOpacity>
  );
}

/** Team leaderboard row: team logo + mascot, navigates to the team page. */
export function TeamLeaderboardRow({
  index,
  entry,
  decimals,
}: {
  index: number;
  entry: LeaderboardEntry;
  decimals: number;
}) {
  const navigation = useNavigation<Nav>();
  const info = teamByFG(entry.team);
  const logo = teamLogoUrlByFG(entry.team);

  return (
    <TouchableOpacity
      style={styles.row}
      disabled={!info}
      activeOpacity={0.7}
      onPress={() => info && navigation.push('TeamPage', { teamAbbr: info.brAbbr })}
    >
      <Rank index={index} />
      <View style={[styles.avatar, styles.teamAvatar]}>
        {logo && <Image source={{ uri: logo }} style={styles.avatarImg} resizeMode="contain" />}
      </View>
      <Text style={styles.name} numberOfLines={1}>
        {mascotByFG(entry.team)}
      </Text>
      <View style={styles.spacer} />
      <Text style={styles.value}>{format(entry.value, decimals)}</Text>
    </TouchableOpacity>
  );
}

const AVATAR = 35;
const styles = StyleSheet.create({
  row: { flexDirection: 'row', alignItems: 'center', paddingVertical: 4 },
  rank: { ...typography.textNorwester, color: colors.white, width: 24 },
  avatar: {
    width: AVATAR,
    height: AVATAR,
    borderRadius: AVATAR / 2,
    marginHorizontal: 10,
    alignItems: 'center',
    justifyContent: 'center',
    overflow: 'hidden',
  },
  teamAvatar: { backgroundColor: colors.white },
  avatarImg: { width: AVATAR, height: AVATAR },
  name: { ...typography.textNorwester, color: colors.white, width: 150 },
  spacer: { flex: 1 },
  value: { ...typography.textNorwester, color: colors.primary, paddingRight: 12 },
});
