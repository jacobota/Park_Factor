import React, { useState } from 'react';
import { ScrollView, StyleSheet, View } from 'react-native';
import { SubTabBar } from '@/components/SubTabBar';
import { PlayerHeader } from '@/components/PlayerHeader';
import { PlayerBioCard } from '@/components/cards/PlayerBioCard';
import { StatCard, StatCell } from '@/components/cards/StatCard';
import { PitcherRadarCard } from '@/components/cards/PitcherRadarCard';
import { PitcherPercentilesCard } from '@/components/cards/PitcherPercentilesCard';
import { PitcherCareerCards } from '@/components/cards/PitcherCareerCards';
import { PitchArsenalCard } from '@/components/cards/PitchArsenalCard';
import { getStat } from '@/types';
import type { PitchingStats, Player } from '@/types';
import { fmt, fmtInt } from '@/utils/format';
import { teamColorByFG } from '@/utils/teams';
import { colors, spacing } from '@/theme';

const TABS = ['Overview', 'Season', 'Career', 'Visuals'];

const overviewCells = (s: PitchingStats): StatCell[] => [
  { catKey: 'pitcher_g', label: 'G', value: fmtInt(getStat(s, 'G')) },
  { catKey: 'pitcher_gs', label: 'GS', value: fmtInt(getStat(s, 'GS')) },
  { catKey: 'pitcher_sv', label: 'SV', value: fmtInt(getStat(s, 'SV')) },
  { catKey: 'pitcher_era', label: 'ERA', value: fmt(getStat(s, 'ERA'), 2) },
  { catKey: 'pitcher_ip', label: 'IP', value: fmt(getStat(s, 'IP'), 1) },
  { catKey: 'pitcher_war', label: 'WAR', value: fmt(getStat(s, 'WAR'), 1) },
];

const standardCells = (s: PitchingStats): StatCell[] => [
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

const advancedCells = (s: PitchingStats): StatCell[] => [
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

/** PitchersPageView — header + Overview/Season/Career/Visuals subtabs. */
export function PitcherPage({ player, stats }: { player: Player; stats: PitchingStats }) {
  const [tab, setTab] = useState('Overview');
  const teamFG = getStat(stats, 'Team') as string | undefined;
  const mlbamId = player.keyMlbam ?? 0;

  return (
    <View style={styles.container}>
      <PlayerHeader player={player} teamFG={teamFG} />
      <SubTabBar tabs={TABS} selected={tab} onSelect={setTab} />
      <ScrollView contentContainerStyle={styles.content}>
        {tab === 'Overview' && (
          <>
            <PlayerBioCard player={player} />
            <StatCard title="2025 Season Overview" cells={overviewCells(stats)} />
            <PitcherRadarCard mlbamId={mlbamId} color={teamColorByFG(teamFG)} />
          </>
        )}
        {tab === 'Season' && (
          <>
            <StatCard title="Standard" cells={standardCells(stats)} />
            <StatCard title="Advanced" cells={advancedCells(stats)} />
            <PitcherPercentilesCard mlbamId={mlbamId} />
          </>
        )}
        {tab === 'Career' && <PitcherCareerCards player={player} />}
        {tab === 'Visuals' && <PitchArsenalCard mlbamId={mlbamId} />}
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.pageBackground },
  content: { padding: spacing.lg },
});
