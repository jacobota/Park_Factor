import React, { useState } from 'react';
import { ActivityIndicator, ScrollView, StyleSheet, View } from 'react-native';
import { useQuery } from '@tanstack/react-query';
import { TeamHeader } from '@/components/TeamHeader';
import { SubTabBar } from '@/components/SubTabBar';
import { getTeamSeasonStats } from '@/api/stats';
import { TeamScheduleSection } from './TeamScheduleSection';
import { TeamHittingSection, TeamPitchingSection } from './TeamStatSections';
import type { Team } from '@/types';
import { colors, spacing } from '@/theme';

const TABS = ['Schedule', 'Hitting', 'Pitching'];

/** RespectiveTeamPageView — header + Schedule/Hitting/Pitching subtabs for a resolved team. */
export function RespectiveTeamPage({ team }: { team: Team }) {
  const [tab, setTab] = useState('Schedule');
  const stats = useQuery({
    queryKey: ['team-season', team.teamIDfg],
    queryFn: () => getTeamSeasonStats(team.teamIDfg),
    enabled: tab !== 'Schedule',
  });

  return (
    <View style={styles.container}>
      <TeamHeader team={team} />
      <SubTabBar tabs={TABS} selected={tab} onSelect={setTab} />

      {tab === 'Schedule' ? (
        <TeamScheduleSection teamAbbr={team.teamIDBR} />
      ) : stats.isLoading ? (
        <View style={styles.center}>
          <ActivityIndicator color={colors.primary} />
        </View>
      ) : (
        <ScrollView contentContainerStyle={styles.content}>
          {stats.data && tab === 'Hitting' && <TeamHittingSection stats={stats.data} />}
          {stats.data && tab === 'Pitching' && <TeamPitchingSection stats={stats.data} />}
        </ScrollView>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.pageBackground },
  content: { padding: spacing.lg },
  center: { flex: 1, alignItems: 'center', justifyContent: 'center' },
});
