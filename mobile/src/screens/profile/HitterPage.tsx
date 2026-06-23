import React, { useState } from 'react';
import { ScrollView, StyleSheet, View } from 'react-native';
import { SubTabBar } from '@/components/SubTabBar';
import { PlayerHeader } from '@/components/PlayerHeader';
import { PlayerBioCard } from '@/components/cards/PlayerBioCard';
import { StatCard, StatCell } from '@/components/cards/StatCard';
import { HitterRadarCard } from '@/components/cards/HitterRadarCard';
import { HitterPercentilesCard } from '@/components/cards/HitterPercentilesCard';
import { HitterCareerCards } from '@/components/cards/HitterCareerCards';
import { SprayChartCard } from '@/components/cards/SprayChartCard';
import { getStat } from '@/types';
import type { HitterStats, Player } from '@/types';
import { fmt, fmtInt } from '@/utils/format';
import { teamColorByFG } from '@/utils/teams';
import { colors, spacing } from '@/theme';

const TABS = ['Overview', 'Season', 'Career', 'Visuals'];

const overviewCells = (s: HitterStats): StatCell[] => [
  { catKey: 'hitter_g', label: 'G', value: fmtInt(getStat(s, 'G')) },
  { catKey: 'hitter_ba', label: 'BA', value: fmt(getStat(s, 'AVG'), 3) },
  { catKey: 'hitter_hr', label: 'HR', value: fmtInt(getStat(s, 'HR')) },
  { catKey: 'hitter_ops', label: 'OPS', value: fmt(getStat(s, 'OPS'), 3) },
  { catKey: 'hitter_war', label: 'WAR', value: fmt(getStat(s, 'WAR'), 1) },
];

const standardCells = (s: HitterStats): StatCell[] => [
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

const advancedCells = (s: HitterStats): StatCell[] => [
  { catKey: 'hitter_wrcplus', label: 'wRC+', value: fmtInt(getStat(s, 'wRC+')) },
  { catKey: 'hitter_xwoba', label: 'xwOBA', value: fmt(getStat(s, 'xwOBA'), 3) },
  { catKey: 'hitter_bbpercent', label: 'BB%', value: fmt(getStat(s, 'BB%'), 3) },
  { catKey: 'hitter_kpercent', label: 'K%', value: fmt(getStat(s, 'K%'), 3) },
  { catKey: 'hitter_babip', label: 'BABIP', value: fmt(getStat(s, 'BABIP'), 3) },
  { catKey: 'hitter_war', label: 'WAR', value: fmt(getStat(s, 'WAR'), 1) },
  { catKey: 'hitter_iso', label: 'ISO', value: fmt(getStat(s, 'ISO'), 3) },
  { catKey: 'hitter_drs', label: 'DRS', value: fmtInt(getStat(s, 'DRS')) },
  { catKey: 'hitter_oaa', label: 'OAA', value: fmtInt(getStat(s, 'OAA')) },
  { catKey: 'hitter_bsr', label: 'BsR', value: fmt(getStat(s, 'BsR'), 1) },
];

/** HittersPageView — header + Overview/Season/Career/Visuals subtabs. */
export function HitterPage({ player, stats }: { player: Player; stats: HitterStats }) {
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
            <HitterRadarCard mlbamId={mlbamId} color={teamColorByFG(teamFG)} />
          </>
        )}
        {tab === 'Season' && (
          <>
            <StatCard title="Standard" cells={standardCells(stats)} />
            <StatCard title="Advanced" cells={advancedCells(stats)} />
            <HitterPercentilesCard mlbamId={mlbamId} />
          </>
        )}
        {tab === 'Career' && <HitterCareerCards player={player} />}
        {tab === 'Visuals' && <SprayChartCard mlbamId={mlbamId} teamFG={teamFG} />}
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.pageBackground },
  content: { padding: spacing.lg },
});
