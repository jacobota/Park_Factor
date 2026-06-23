import React from 'react';
import { ActivityIndicator, Image, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { useQuery } from '@tanstack/react-query';
import { StatGrid } from './StatGrid';
import { getHitterSeasonStats, getPitcherSeasonStats } from '@/api/stats';
import { getStat, playerFullName } from '@/types';
import type { Player } from '@/types';
import { playerHeadshotUrl } from '@/utils/images';
import { teamColorByFG } from '@/utils/teams';
import { fmt, fmtInt } from '@/utils/format';
import { colors, radius, spacing, typography } from '@/theme';
import type { ProfileStackParamList } from '@/navigation/types';

type Nav = NativeStackNavigationProp<ProfileStackParamList>;

/**
 * Player summary card — consolidates HitterStatsCardView, PitcherStatsCardView and
 * GenericPlayerCardView. Fetches season stats and renders the hitter grid, pitcher grid,
 * or just the header (generic) depending on what comes back.
 */
export function PlayerStatCard({ player, isFollowing }: { player: Player; isFollowing: boolean }) {
  const navigation = useNavigation<Nav>();
  const fgId = player.keyFangraphs ?? 0;
  const mlbamId = player.keyMlbam ?? 0;

  const hitter = useQuery({
    queryKey: ['hitter-season', fgId, mlbamId],
    queryFn: () => getHitterSeasonStats(fgId, mlbamId),
  });
  const pitcher = useQuery({
    queryKey: ['pitcher-season', fgId, mlbamId],
    queryFn: () => getPitcherSeasonStats(fgId, mlbamId),
  });

  const loading = hitter.isLoading || pitcher.isLoading;
  const hitterStats = hitter.data;
  const pitcherStats = pitcher.data;
  const team = (getStat(hitterStats, 'Team') ?? getStat(pitcherStats, 'Team')) as string | undefined;

  const cells =
    hitterStats != null
      ? [
          { label: 'G', value: fmtInt(getStat(hitterStats, 'G')) },
          { label: 'BA', value: fmt(getStat(hitterStats, 'AVG'), 3) },
          { label: 'HR', value: fmtInt(getStat(hitterStats, 'HR')) },
          { label: 'RBI', value: fmtInt(getStat(hitterStats, 'RBI')) },
          { label: 'OPS', value: fmt(getStat(hitterStats, 'OPS'), 3) },
          { label: 'WAR', value: fmt(getStat(hitterStats, 'WAR'), 1) },
        ]
      : pitcherStats != null
        ? [
            { label: 'G', value: fmtInt(getStat(pitcherStats, 'G')) },
            { label: 'IP', value: fmt(getStat(pitcherStats, 'IP'), 1) },
            { label: 'ERA', value: fmt(getStat(pitcherStats, 'ERA'), 2) },
            { label: 'K%', value: fmt(getStat(pitcherStats, 'K%'), 3) },
            { label: 'BB%', value: fmt(getStat(pitcherStats, 'BB%'), 3) },
            { label: 'WAR', value: fmt(getStat(pitcherStats, 'WAR'), 1) },
          ]
        : null;

  return (
    <TouchableOpacity
      style={styles.card}
      activeOpacity={0.8}
      onPress={() => navigation.push('PlayerPage', { player })}
    >
      <View style={styles.header}>
        <View style={[styles.avatar, { backgroundColor: team ? teamColorByFG(team) : colors.white }]}>
          <Image source={{ uri: playerHeadshotUrl(player.keyMlbam) }} style={styles.avatarImg} />
        </View>
        <Text style={styles.name} numberOfLines={1}>
          {playerFullName(player)}
        </Text>
        {isFollowing && <Ionicons name="star" size={22} color={colors.primary} />}
      </View>

      {loading ? (
        <ActivityIndicator color={colors.primary} style={styles.loading} />
      ) : (
        cells && <StatGrid cells={cells} />
      )}
    </TouchableOpacity>
  );
}

const AVATAR = 50;
const styles = StyleSheet.create({
  card: { backgroundColor: colors.secondary, borderRadius: radius.md, marginBottom: spacing.sm },
  header: { flexDirection: 'row', alignItems: 'center', padding: 20 },
  avatar: { width: AVATAR, height: AVATAR, borderRadius: AVATAR / 2, overflow: 'hidden' },
  avatarImg: { width: AVATAR, height: AVATAR },
  name: { ...typography.subtitleNorwester, color: colors.white, flex: 1, marginHorizontal: 16 },
  loading: { paddingBottom: 20 },
});
