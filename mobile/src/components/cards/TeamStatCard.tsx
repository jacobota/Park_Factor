import React from 'react';
import { ActivityIndicator, Image, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { useQuery } from '@tanstack/react-query';
import { StatGrid } from './StatGrid';
import { getTeamSeasonStats } from '@/api/stats';
import { getStat } from '@/types';
import type { Team } from '@/types';
import { teamByBR } from '@/utils/teams';
import { fmt, fmtInt, toNum } from '@/utils/format';
import { colors, radius, spacing, typography } from '@/theme';
import type { ProfileStackParamList } from '@/navigation/types';

type Nav = NativeStackNavigationProp<ProfileStackParamList>;

/** Team summary card (TeamStatsCardView): logo, mascot, follow star, and a W-L/RS/RA/ERA/wOBA/WAR grid. */
export function TeamStatCard({ team, isFollowing }: { team: Team; isFollowing: boolean }) {
  const navigation = useNavigation<Nav>();

  const { data, isLoading } = useQuery({
    queryKey: ['team-season', team.teamIDfg],
    queryFn: () => getTeamSeasonStats(team.teamIDfg),
  });

  const batting = data?.teamBatting?.[0];
  const pitching = data?.teamPitching?.[0];

  const cells =
    batting && pitching
      ? [
          { label: 'W-L', value: `${fmtInt(getStat(pitching, 'W'))}-${fmtInt(getStat(pitching, 'L'))}` },
          { label: 'RS', value: fmtInt(getStat(batting, 'R')) },
          { label: 'RA', value: fmtInt(getStat(pitching, 'R')) },
          { label: 'ERA', value: fmt(getStat(pitching, 'ERA'), 2) },
          { label: 'wOBA', value: fmt(getStat(batting, 'wOBA'), 3) },
          { label: 'WAR', value: (toNum(getStat(batting, 'WAR')) + toNum(getStat(pitching, 'WAR'))).toFixed(1) },
        ]
      : null;

  return (
    <TouchableOpacity
      style={styles.card}
      activeOpacity={0.8}
      onPress={() => navigation.push('TeamPage', { teamAbbr: team.teamIDBR })}
    >
      <View style={styles.header}>
        <View style={styles.logo}>
          <Image
            source={{ uri: `https://cdn.ssref.net/req/202502211/tlogo/br/${team.franchID}.png` }}
            style={styles.logoImg}
            resizeMode="contain"
          />
        </View>
        <Text style={styles.name} numberOfLines={1}>
          {teamByBR(team.teamIDBR)?.mascot ?? team.teamIDBR}
        </Text>
        {isFollowing && <Ionicons name="star" size={22} color={colors.primary} />}
      </View>

      {isLoading ? (
        <ActivityIndicator color={colors.primary} style={styles.loading} />
      ) : (
        cells && <StatGrid cells={cells} />
      )}
    </TouchableOpacity>
  );
}

const LOGO = 50;
const styles = StyleSheet.create({
  card: { backgroundColor: colors.secondary, borderRadius: radius.md, marginBottom: spacing.sm },
  header: { flexDirection: 'row', alignItems: 'center', padding: 20 },
  logo: {
    width: LOGO,
    height: LOGO,
    borderRadius: LOGO / 2,
    backgroundColor: colors.white,
    alignItems: 'center',
    justifyContent: 'center',
    overflow: 'hidden',
  },
  logoImg: { width: LOGO, height: LOGO },
  name: { ...typography.subtitleNorwester, color: colors.white, flex: 1, marginHorizontal: 16 },
  loading: { paddingBottom: 20 },
});
