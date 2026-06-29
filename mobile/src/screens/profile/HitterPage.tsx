import React, { useState } from 'react';
import { ScrollView, StyleSheet, View } from 'react-native';
import { SubTabBar } from '@/components/SubTabBar';
import { PlayerHeader } from '@/components/PlayerHeader';
import { PlayerInfoCard } from '@/components/cards/PlayerInfoCard';
import { StatCard, StatCell } from '@/components/cards/StatCard';
import { HitterRadarCard } from '@/components/cards/HitterRadarCard';
import { HitterPercentilesCard } from '@/components/cards/HitterPercentilesCard';
import { HitterCareerCards } from '@/components/cards/HitterCareerCards';
import { SprayChartCard } from '@/components/cards/SprayChartCard';
import { getStat } from '@/types';
import type { HitterStats, Player } from '@/types';
import { fmt, fmtInt, fmtPct } from '@/utils/format';
import { teamColorByFG } from '@/utils/teams';
import { colors, spacing } from '@/theme';

const TABS = ['Season', 'Infographics', 'Career'];

// Hero snapshot — the line every hitter page leads with.
const snapshotCells = (s: HitterStats): StatCell[] => [
  { catKey: 'hitter_ba', label: 'AVG', value: fmt(getStat(s, 'AVG'), 3) },
  { catKey: 'hitter_ops', label: 'OPS', value: fmt(getStat(s, 'OPS'), 3) },
  { catKey: 'hitter_hr', label: 'HR', value: fmtInt(getStat(s, 'HR')) },
  { catKey: 'hitter_rbi', label: 'RBI', value: fmtInt(getStat(s, 'RBI')) },
  { catKey: 'hitter_sb', label: 'SB', value: fmtInt(getStat(s, 'SB')) },
  { catKey: 'hitter_war', label: 'WAR', value: fmt(getStat(s, 'WAR'), 1) },
];

const standardCells = (s: HitterStats): StatCell[] => [
  { catKey: 'hitter_g', label: 'G', value: fmtInt(getStat(s, 'G')) },
  { catKey: 'hitter_pa', label: 'PA', value: fmtInt(getStat(s, 'PA')) },
  { catKey: 'hitter_h', label: 'H', value: fmtInt(getStat(s, 'H')) },
  { catKey: 'hitter_hr', label: 'HR', value: fmtInt(getStat(s, 'HR')) },
  { catKey: 'hitter_runs', label: 'R', value: fmtInt(getStat(s, 'R')) },
  { catKey: 'hitter_rbi', label: 'RBI', value: fmtInt(getStat(s, 'RBI')) },
  { catKey: 'hitter_sb', label: 'SB', value: fmtInt(getStat(s, 'SB')) },
  { catKey: 'hitter_ba', label: 'AVG', value: fmt(getStat(s, 'AVG'), 3) },
  { catKey: 'hitter_obp', label: 'OBP', value: fmt(getStat(s, 'OBP'), 3) },
  { catKey: 'hitter_slg', label: 'SLG', value: fmt(getStat(s, 'SLG'), 3) },
];

const advancedCells = (s: HitterStats): StatCell[] => [
  { catKey: 'hitter_woba', label: 'wOBA', value: fmt(getStat(s, 'wOBA'), 3) },
  { catKey: 'hitter_xwoba', label: 'xwOBA', value: fmt(getStat(s, 'xwOBA'), 3) },
  { catKey: 'hitter_xba', label: 'xBA', value: fmt(getStat(s, 'xBA'), 3) },
  { catKey: 'hitter_xslg', label: 'xSLG', value: fmt(getStat(s, 'xSLG'), 3) },
  { catKey: 'hitter_iso', label: 'ISO', value: fmt(getStat(s, 'ISO'), 3) },
  { catKey: 'hitter_babip', label: 'BABIP', value: fmt(getStat(s, 'BABIP'), 3) },
  { catKey: 'hitter_bbpercent', label: 'BB%', value: fmtPct(getStat(s, 'BB%')) },
  { catKey: 'hitter_kpercent', label: 'K%', value: fmtPct(getStat(s, 'K%')) },
];

// Batted-ball quality (Statcast) — the Infographics headline strip.
const battedBallCells = (s: HitterStats): StatCell[] => [
  { catKey: 'hitter_ev', label: 'Avg EV', value: fmt(getStat(s, 'EV'), 1) },
  { catKey: 'hitter_maxev', label: 'Max EV', value: fmt(getStat(s, 'maxEV'), 1) },
  { catKey: 'hitter_hardhitpercent', label: 'Hard Hit%', value: fmtPct(getStat(s, 'HardHit%')) },
  { catKey: 'hitter_barrelpercent', label: 'Barrel%', value: fmtPct(getStat(s, 'Barrel%')) },
];

/** Hitter profile — pinned header over Season / Infographics / Career tabs. */
export function HitterPage({ player, stats }: { player: Player; stats: HitterStats }) {
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
            <HitterRadarCard mlbamId={mlbamId} color={teamColorByFG(teamFG)} />
            <HitterPercentilesCard mlbamId={mlbamId} />
            <StatCard title="Standard" cells={standardCells(stats)} columns={5} />
            <StatCard title="Advanced" cells={advancedCells(stats)} columns={4} />
          </>
        )}
        {tab === 'Infographics' && (
          <>
            <StatCard title="Batted Ball Profile" cells={battedBallCells(stats)} columns={4} />
            <SprayChartCard mlbamId={mlbamId} teamFG={teamFG} />
          </>
        )}
        {tab === 'Career' && <HitterCareerCards player={player} />}
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.pageBackground },
  content: { padding: spacing.lg },
});
