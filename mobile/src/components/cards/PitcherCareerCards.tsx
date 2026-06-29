import React from 'react';
import { StyleSheet, Text } from 'react-native';
import { useQuery } from '@tanstack/react-query';
import { StatCard, StatCell } from './StatCard';
import { getPitcherCareer } from '@/api/players';
import { getStat } from '@/types';
import type { PitchingCareerStats, Player } from '@/types';
import { fmt, fmtInt } from '@/utils/format';
import { colors, typography } from '@/theme';

// Career Standard + Advanced mirror the pitcher season grids, reading the career row.
const standardCells = (s: PitchingCareerStats): StatCell[] => [
  { catKey: 'pitcher_g', label: 'G', value: fmtInt(getStat(s, 'G')) },
  { catKey: 'pitcher_gs', label: 'GS', value: fmtInt(getStat(s, 'GS')) },
  { catKey: 'pitcher_cg', label: 'CG', value: fmtInt(getStat(s, 'CG')) },
  { catKey: 'pitcher_sv', label: 'SV', value: fmtInt(getStat(s, 'SV')) },
  { catKey: 'pitcher_ip', label: 'IP', value: fmt(getStat(s, 'IP'), 1) },
  { catKey: 'pitcher_record', label: 'W-L', value: `${fmtInt(getStat(s, 'W'))}-${fmtInt(getStat(s, 'L'))}` },
  { catKey: 'pitcher_era', label: 'ERA', value: fmt(getStat(s, 'ERA'), 2) },
  { catKey: 'pitcher_so', label: 'SO', value: fmtInt(getStat(s, 'SO')) },
  { catKey: 'pitcher_walks', label: 'BB', value: fmtInt(getStat(s, 'BB')) },
  { catKey: 'pitcher_whip', label: 'WHIP', value: fmt(getStat(s, 'WHIP'), 3) },
];

const advancedCells = (s: PitchingCareerStats): StatCell[] => [
  { catKey: 'pitcher_siera', label: 'SIERA', value: fmt(getStat(s, 'SIERA'), 2) },
  { catKey: 'pitcher_xera', label: 'xERA', value: fmt(getStat(s, 'xERA'), 2) },
  { catKey: 'pitcher_fip', label: 'FIP', value: fmt(getStat(s, 'FIP'), 2) },
  { catKey: 'pitcher_xfip', label: 'xFIP', value: fmt(getStat(s, 'xFIP'), 2) },
  { catKey: 'pitcher_fbvelo', label: 'FB Velo', value: fmt(getStat(s, 'vFA (pi)'), 1) },
  { catKey: 'pitcher_war', label: 'WAR', value: fmt(getStat(s, 'WAR'), 1) },
  { catKey: 'pitcher_kpercent', label: 'K%', value: fmt(getStat(s, 'K%'), 3) },
  { catKey: 'pitcher_bbpercent', label: 'BB%', value: fmt(getStat(s, 'BB%'), 3) },
  { catKey: 'pitcher_kminusbbpercent', label: 'K-BB%', value: fmt(getStat(s, 'K-BB%'), 3) },
  { catKey: 'pitcher_gbpercent', label: 'GB%', value: fmt(getStat(s, 'GB%'), 3) },
  { catKey: 'pitcher_stuffplus', label: 'Stuff+', value: fmtInt(getStat(s, 'Stuff+')) },
  { catKey: 'pitcher_locationplus', label: 'Location+', value: fmtInt(getStat(s, 'Location+')) },
  { catKey: 'pitcher_pitchingplus', label: 'Pitching+', value: fmtInt(getStat(s, 'Pitching+')) },
];

export function PitcherCareerCards({ player }: { player: Player }) {
  const { data, isLoading } = useQuery({
    queryKey: ['pitcher-career', player.keyMlbam],
    queryFn: () => getPitcherCareer(player.keyMlbam ?? 0),
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
