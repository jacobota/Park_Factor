import React from 'react';
import { ScrollView, StyleSheet, View } from 'react-native';
import { SubTabBar } from '@/components/SubTabBar';
import { PlayerHeader } from '@/components/PlayerHeader';
import { StatCard, StatCell } from '@/components/cards/StatCard';
import { getStat } from '@/types';
import type { HitterPreviewStats, PitchingPreviewStats, Player, StatBag } from '@/types';
import { fmt, fmtInt } from '@/utils/format';
import { teamByCity, teamColor } from '@/utils/teams';
import { colors, spacing } from '@/theme';

/**
 * Preview pages (HittersPreviewPageView / PitchersPreviewPageView) for players without
 * FanGraphs data — single "Season" subtab with a Standard stat card. Team is keyed by the
 * Baseball-Reference city + level.
 */
function PreviewPage({ player, stats, cells }: { player: Player; stats: StatBag; cells: StatCell[] }) {
  const info = teamByCity(getStat(stats, 'Tm') as string, getStat(stats, 'Lev') as string);
  return (
    <View style={styles.container}>
      <PlayerHeader player={player} teamColor={teamColor(info)} teamName={info?.mascot ?? 'Free Agent'} />
      <SubTabBar tabs={['Season']} selected="Season" onSelect={() => {}} />
      <ScrollView contentContainerStyle={styles.content}>
        <StatCard title="Standard" cells={cells} />
      </ScrollView>
    </View>
  );
}

const hitterCells = (s: HitterPreviewStats): StatCell[] => [
  { catKey: 'hitter_g', label: 'G', value: fmtInt(getStat(s, 'G')) },
  { catKey: 'hitter_ba', label: 'BA', value: fmt(getStat(s, 'BA'), 3) },
  { catKey: 'hitter_obp', label: 'OBP', value: fmt(getStat(s, 'OBP'), 3) },
  { catKey: 'hitter_slg', label: 'SLG', value: fmt(getStat(s, 'SLG'), 3) },
  { catKey: 'hitter_ops', label: 'OPS', value: fmt(getStat(s, 'OPS'), 3) },
  { catKey: 'hitter_ab', label: 'AB', value: fmtInt(getStat(s, 'AB')) },
  { catKey: 'hitter_h', label: 'H', value: fmtInt(getStat(s, 'H')) },
  { catKey: 'hitter_double', label: '2B', value: fmtInt(getStat(s, '2B')) },
  { catKey: 'hitter_triple', label: '3B', value: fmtInt(getStat(s, '3B')) },
  { catKey: 'hitter_hr', label: 'HR', value: fmtInt(getStat(s, 'HR')) },
  { catKey: 'hitter_runs', label: 'R', value: fmtInt(getStat(s, 'R')) },
  { catKey: 'hitter_rbi', label: 'RBI', value: fmtInt(getStat(s, 'RBI')) },
  { catKey: 'hitter_sb', label: 'SB', value: fmtInt(getStat(s, 'SB')) },
  { catKey: 'hitter_sacfly', label: 'SF', value: fmtInt(getStat(s, 'SF')) },
  { catKey: 'hitter_bb', label: 'BB', value: fmtInt(getStat(s, 'BB')) },
];

const pitcherCells = (s: PitchingPreviewStats): StatCell[] => [
  { catKey: 'pitcher_g', label: 'G', value: fmtInt(getStat(s, 'G')) },
  { catKey: 'pitcher_gs', label: 'GS', value: fmtInt(getStat(s, 'GS')) },
  { catKey: 'pitcher_ip', label: 'IP', value: fmt(getStat(s, 'IP'), 1) },
  { catKey: 'pitcher_era', label: 'ERA', value: fmt(getStat(s, 'ERA'), 2) },
  { catKey: 'pitcher_sv', label: 'SV', value: fmtInt(getStat(s, 'SV')) },
  { catKey: 'pitcher_record', label: 'W-L', value: `${fmtInt(getStat(s, 'W'))}-${fmtInt(getStat(s, 'L'))}` },
  { catKey: 'pitcher_hits', label: 'HA', value: fmtInt(getStat(s, 'H')) },
  { catKey: 'pitcher_so', label: 'SO', value: fmtInt(getStat(s, 'SO')) },
  { catKey: 'pitcher_walks', label: 'BB', value: fmtInt(getStat(s, 'BB')) },
  { catKey: 'pitcher_walktostrikeout', label: 'K/BB', value: fmt(getStat(s, 'SO/W'), 2) },
  { catKey: 'pitcher_kpernine', label: 'K/9', value: fmt(getStat(s, 'SO9'), 1) },
  { catKey: 'pitcher_gbtofb', label: 'GB/FB', value: fmt(getStat(s, 'GB/FB'), 2) },
  { catKey: 'pitcher_strikepercent', label: 'Strike%', value: fmt(getStat(s, 'Str'), 3) },
  { catKey: 'pitcher_whip', label: 'WHIP', value: fmt(getStat(s, 'WHIP'), 3) },
  { catKey: 'pitcher_baa', label: 'BAA', value: fmt(getStat(s, 'BAbip'), 3) },
];

export const HitterPreviewPage = ({ player, stats }: { player: Player; stats: HitterPreviewStats }) => (
  <PreviewPage player={player} stats={stats} cells={hitterCells(stats)} />
);
export const PitcherPreviewPage = ({ player, stats }: { player: Player; stats: PitchingPreviewStats }) => (
  <PreviewPage player={player} stats={stats} cells={pitcherCells(stats)} />
);

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.pageBackground },
  content: { padding: spacing.lg },
});
