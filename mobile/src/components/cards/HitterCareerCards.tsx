import React from 'react';
import { StyleSheet, Text } from 'react-native';
import { useQuery } from '@tanstack/react-query';
import { StatCard, StatCell } from './StatCard';
import { getHitterCareer } from '@/api/players';
import { getStat } from '@/types';
import type { HittingCareerStats, Player } from '@/types';
import { fmt, fmtInt } from '@/utils/format';
import { colors, typography } from '@/theme';

// Career Standard mirrors the season Standard grid; Advanced uses career-only stats (wOBA/WPA/wSB).
const standardCells = (s: HittingCareerStats): StatCell[] => [
  { catKey: 'hitter_g', label: 'G', value: fmtInt(getStat(s, 'G')) },
  { catKey: 'hitter_ba', label: 'BA', value: fmt(getStat(s, 'AVG'), 3) },
  { catKey: 'hitter_obp', label: 'OBP', value: fmt(getStat(s, 'OBP'), 3) },
  { catKey: 'hitter_slg', label: 'SLG', value: fmt(getStat(s, 'SLG'), 3) },
  { catKey: 'hitter_ops', label: 'OPS', value: fmt(getStat(s, 'OPS'), 3) },
  { catKey: 'hitter_h', label: 'H', value: fmtInt(getStat(s, 'H')) },
  { catKey: 'hitter_hr', label: 'HR', value: fmtInt(getStat(s, 'HR')) },
  { catKey: 'hitter_runs', label: 'R', value: fmtInt(getStat(s, 'R')) },
  { catKey: 'hitter_rbi', label: 'RBI', value: fmtInt(getStat(s, 'RBI')) },
  { catKey: 'hitter_sb', label: 'SB', value: fmtInt(getStat(s, 'SB')) },
];

const advancedCells = (s: HittingCareerStats): StatCell[] => [
  { catKey: 'hitter_wrcplus', label: 'wRC+', value: fmtInt(getStat(s, 'wRC+')) },
  { catKey: 'hitter_woba', label: 'wOBA', value: fmt(getStat(s, 'wOBA'), 3) },
  { catKey: 'hitter_bbpercent', label: 'BB%', value: fmt(getStat(s, 'BB%'), 3) },
  { catKey: 'hitter_kpercent', label: 'K%', value: fmt(getStat(s, 'K%'), 3) },
  { catKey: 'hitter_babip', label: 'BABIP', value: fmt(getStat(s, 'BABIP'), 3) },
  { catKey: 'hitter_war', label: 'WAR', value: fmt(getStat(s, 'WAR'), 1) },
  { catKey: 'hitter_iso', label: 'ISO', value: fmt(getStat(s, 'ISO'), 3) },
  { catKey: 'hitter_wpa', label: 'WPA', value: fmt(getStat(s, 'WPA'), 2) },
  { catKey: 'hitter_wsb', label: 'wSB', value: fmt(getStat(s, 'wSB'), 1) },
  { catKey: 'hitter_bsr', label: 'BsR', value: fmt(getStat(s, 'BsR'), 1) },
];

export function HitterCareerCards({ player }: { player: Player }) {
  const { data, isLoading } = useQuery({
    queryKey: ['hitter-career', player.keyFangraphs],
    queryFn: () => getHitterCareer(player.keyFangraphs ?? 0, player.mlbPlayedFirst ?? 0, player.mlbPlayedLast ?? 0),
  });

  const row = data?.[0];
  if (isLoading || !row) return <Text style={styles.loading}>Loading Career ...</Text>;

  return (
    <>
      <StatCard title="Standard" cells={standardCells(row)} />
      <StatCard title="Advanced" cells={advancedCells(row)} />
    </>
  );
}

const styles = StyleSheet.create({
  loading: { ...typography.subtitleNorwester, color: colors.primary, textAlign: 'center', marginTop: 24 },
});
