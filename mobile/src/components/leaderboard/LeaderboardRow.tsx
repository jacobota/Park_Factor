import React from 'react';
import { Image, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { useQuery } from '@tanstack/react-query';
import { LinearGradient } from 'expo-linear-gradient';
import { lookupPlayerByName } from '@/api/stats';
import { playerFullName } from '@/types';
import { resolveLeaderboardName, pickLeaderboardPlayer } from '@/utils/playerNames';
import { mascotByFG, teamByFG, teamColorByFG, teamLogoUrlByFG } from '@/utils/teams';
import { colors, fonts, typography } from '@/theme';
import type { LeaderboardEntry } from '@/types';
import type { ProfileStackParamList } from '@/navigation/types';

type Nav = NativeStackNavigationProp<ProfileStackParamList>;

const format = (value: number, decimals: number) => value.toFixed(decimals);

/** Two initials from a display name ("Mason Miller" -> "MM"). */
const initials = (name = '') =>
  name.trim().split(/\s+/).slice(0, 2).map((w) => w[0]?.toUpperCase() ?? '').join('');

function Rank({ index }: { index: number }) {
  return <Text style={styles.rank}>{index + 1}</Text>;
}

/** Circular monogram placeholder, tinted by team color (v1 defers photo/logo licensing). */
function Monogram({ name, team }: { name?: string; team: string }) {
  const tint = teamByFG(team) ? teamColorByFG(team) : colors.hairline;
  return (
    <View style={[styles.avatar, { backgroundColor: tint, borderColor: tint }]}>
      <Text style={styles.monogram}>{initials(name)}</Text>
    </View>
  );
}

/** Value + continuous red→yellow→green bar; `fill` (0..1) is the value's rank within its board. */
function ValueBar({ value, decimals, fill }: { value: number; decimals: number; fill: number }) {
  const frac = Math.max(0, Math.min(1, fill));
  return (
    <View style={styles.valueCol}>
      <Text style={styles.value}>{format(value, decimals)}</Text>
      <View style={styles.barTrack}>
        <View style={[styles.barClip, { width: BAR_W * frac }]}>
          <LinearGradient
            colors={[colors.bad, '#F5C518', colors.good]}
            start={{ x: 0, y: 0 }}
            end={{ x: 1, y: 0 }}
            style={styles.barFill}
          />
        </View>
      </View>
    </View>
  );
}

/** Player leaderboard row: monogram + name + POS · TEAM, value bar; taps through to the profile. */
export function PlayerLeaderboardRow({
  index,
  entry,
  decimals,
  fill,
  isPitching,
}: {
  index: number;
  entry: LeaderboardEntry;
  decimals: number;
  fill: number;
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

  const meta = [entry.pos, entry.team].filter(Boolean).join('  ·  ');
  // bbref leaderboard names are ASCII; the looked-up record carries the accented form (José, Muñoz).
  const displayName = (player && playerFullName(player)) || entry.name || '';

  return (
    <TouchableOpacity
      style={styles.row}
      disabled={!player}
      activeOpacity={0.7}
      onPress={() => player && navigation.push('PlayerPage', { player })}
    >
      <Rank index={index} />
      <Monogram name={displayName} team={entry.team} />
      <View style={styles.nameCol}>
        <Text style={styles.name} numberOfLines={1}>
          {displayName}
        </Text>
        {!!meta && <Text style={styles.meta}>{meta}</Text>}
      </View>
      <ValueBar value={entry.value} decimals={decimals} fill={fill} />
    </TouchableOpacity>
  );
}

/** Team leaderboard row: team logo + mascot + city, value bar; taps through to the team page. */
export function TeamLeaderboardRow({
  index,
  entry,
  decimals,
  fill,
}: {
  index: number;
  entry: LeaderboardEntry;
  decimals: number;
  fill: number;
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
      <View style={styles.nameCol}>
        <Text style={styles.name} numberOfLines={1}>
          {mascotByFG(entry.team)}
        </Text>
        {!!info?.city && <Text style={styles.meta}>{info.city}</Text>}
      </View>
      <ValueBar value={entry.value} decimals={decimals} fill={fill} />
    </TouchableOpacity>
  );
}

const AVATAR = 32;
const BAR_W = 90;
const styles = StyleSheet.create({
  row: { flexDirection: 'row', alignItems: 'center', paddingVertical: 7 },
  rank: { ...typography.smallTextNorwester, color: colors.gray, width: 20, textAlign: 'center', fontSize: 15 },
  avatar: {
    width: AVATAR,
    height: AVATAR,
    borderRadius: AVATAR / 2,
    borderWidth: 1.5,
    marginHorizontal: 9,
    alignItems: 'center',
    justifyContent: 'center',
    overflow: 'hidden',
  },
  // Initials are A–Z only, so the punchy display font is safe here.
  monogram: { fontFamily: fonts.norwester, color: colors.white, fontSize: 12 },
  teamAvatar: { backgroundColor: colors.white, borderColor: colors.white },
  avatarImg: { width: AVATAR, height: AVATAR },
  nameCol: { flex: 1, justifyContent: 'center', paddingRight: 6 },
  // Archivo Narrow has full accented-Latin coverage (Norwester does not) and fits more chars.
  name: { fontFamily: fonts.archivo, color: colors.white, fontSize: 16 },
  meta: { fontFamily: fonts.archivo, color: colors.gray, fontSize: 11, letterSpacing: 0.5, marginTop: 1 },
  valueCol: { alignItems: 'flex-end', minWidth: BAR_W, paddingLeft: 6 },
  value: { ...typography.textNorwester, color: colors.white, fontSize: 18 },
  barTrack: {
    width: BAR_W,
    height: 3,
    borderRadius: 2,
    backgroundColor: colors.hairline,
    marginTop: 5,
    overflow: 'hidden',
  },
  barClip: { height: '100%', overflow: 'hidden' },
  barFill: { width: BAR_W, height: '100%' },
});
