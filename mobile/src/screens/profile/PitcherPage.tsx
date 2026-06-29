import React, { useState } from 'react';
import { ScrollView, StyleSheet, View } from 'react-native';
import { SubTabBar } from '@/components/SubTabBar';
import { PlayerHeader } from '@/components/PlayerHeader';
import { PlayerInfoCard } from '@/components/cards/PlayerInfoCard';
import { StatCard, StatCell } from '@/components/cards/StatCard';
import { PitcherRadarCard } from '@/components/cards/PitcherRadarCard';
import { PitcherPercentilesCard } from '@/components/cards/PitcherPercentilesCard';
import { PitcherInfographics } from '@/components/cards/PitcherInfographics';
import { PitcherCareerCards } from '@/components/cards/PitcherCareerCards';
import { getStat } from '@/types';
import type { PitchingStats, Player } from '@/types';
import { fmt, fmtInt, fmtPct } from '@/utils/format';
import { teamColorByFG } from '@/utils/teams';
import { colors, spacing } from '@/theme';

const TABS = ['Season', 'Infographics', 'Career'];

// Hero snapshot — the line every pitcher page leads with.
const snapshotCells = (s: PitchingStats): StatCell[] => [
  { catKey: 'pitcher_era', label: 'ERA', value: fmt(getStat(s, 'ERA'), 2) },
  { catKey: 'pitcher_record', label: 'W-L', value: `${fmtInt(getStat(s, 'W'))}-${fmtInt(getStat(s, 'L'))}` },
  { catKey: 'pitcher_ip', label: 'IP', value: fmt(getStat(s, 'IP'), 1) },
  { catKey: 'pitcher_so', label: 'SO', value: fmtInt(getStat(s, 'SO')) },
  { catKey: 'pitcher_whip', label: 'WHIP', value: fmt(getStat(s, 'WHIP'), 2) },
  { catKey: 'pitcher_war', label: 'WAR', value: fmt(getStat(s, 'WAR'), 1) },
];

const standardCells = (s: PitchingStats): StatCell[] => [
  { catKey: 'pitcher_g', label: 'G', value: fmtInt(getStat(s, 'G')) },
  { catKey: 'pitcher_gs', label: 'GS', value: fmtInt(getStat(s, 'GS')) },
  { catKey: 'pitcher_sv', label: 'SV', value: fmtInt(getStat(s, 'SV')) },
  { catKey: 'pitcher_so', label: 'SO', value: fmtInt(getStat(s, 'SO')) },
  { catKey: 'pitcher_walks', label: 'BB', value: fmtInt(getStat(s, 'BB')) },
  { catKey: 'pitcher_hr', label: 'HR', value: fmtInt(getStat(s, 'HR')) },
];

const advancedCells = (s: PitchingStats): StatCell[] => [
  { catKey: 'pitcher_xera', label: 'xERA', value: fmt(getStat(s, 'xERA'), 2) },
  { catKey: 'pitcher_fip', label: 'FIP', value: fmt(getStat(s, 'FIP'), 2) },
  { catKey: 'pitcher_kpercent', label: 'K%', value: fmtPct(getStat(s, 'K%')) },
  { catKey: 'pitcher_bbpercent', label: 'BB%', value: fmtPct(getStat(s, 'BB%')) },
  { catKey: 'pitcher_kminusbbpercent', label: 'K-BB%', value: fmtPct(getStat(s, 'K-BB%')) },
  { catKey: 'pitcher_hr9', label: 'HR/9', value: fmt(getStat(s, 'HR/9'), 2) },
  { catKey: 'pitcher_ev', label: 'EV', value: fmt(getStat(s, 'EV'), 1) },
  { catKey: 'pitcher_barrels', label: 'Barrel%', value: fmtPct(getStat(s, 'Barrel%')) },
];

/** Pitcher profile — pinned header/bio over Season / Infographics / Career tabs. */
export function PitcherPage({ player, stats }: { player: Player; stats: PitchingStats }) {
  const [tab, setTab] = useState('Season');
  const teamFG = getStat(stats, 'Team') as string | undefined;
  const mlbamId = player.keyMlbam ?? 0;

  return (
    <View style={styles.container}>
      <PlayerHeader player={player} teamFG={teamFG} />
      <SubTabBar tabs={TABS} selected={tab} onSelect={setTab} />
      <ScrollView contentContainerStyle={styles.content}>
        <PlayerInfoCard mlbamId={mlbamId} />
        {tab === 'Season' && (
          <>
            <StatCard title="Season Snapshot" cells={snapshotCells(stats)} columns={6} />
            <PitcherRadarCard mlbamId={mlbamId} color={teamColorByFG(teamFG)} />
            <PitcherPercentilesCard mlbamId={mlbamId} />
            <StatCard title="Standard" cells={standardCells(stats)} columns={6} />
            <StatCard title="Advanced" cells={advancedCells(stats)} columns={4} />
          </>
        )}
        {tab === 'Infographics' && (
          <PitcherInfographics mlbamId={mlbamId} firstYear={player.mlbPlayedFirst} />
        )}
        {tab === 'Career' && <PitcherCareerCards player={player} />}
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.pageBackground },
  content: { padding: spacing.lg },
});
