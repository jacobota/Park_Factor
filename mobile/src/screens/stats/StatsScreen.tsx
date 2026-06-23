import React, { useState } from 'react';
import { ScrollView, StyleSheet } from 'react-native';
import { ScreenContainer } from '@/components/ScreenContainer';
import { TabHeader } from '@/components/TabHeader';
import { SubTabBar } from '@/components/SubTabBar';
import { PlayerStatsSection } from './PlayerStatsSection';
import { TeamStatsSection } from './TeamStatsSection';
import { colors } from '@/theme';

const TABS = ['Teams', 'Players'];

/** StatsView — header, Teams/Players toggle, then the selected section. */
export function StatsScreen() {
  const [tab, setTab] = useState('Teams');

  return (
    <ScreenContainer background={colors.pageBackground}>
      <TabHeader title="Stats" />
      <SubTabBar tabs={TABS} selected={tab} onSelect={setTab} />
      <ScrollView contentContainerStyle={styles.content}>
        {tab === 'Teams' ? <TeamStatsSection /> : <PlayerStatsSection />}
      </ScrollView>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  content: { paddingTop: 8, paddingBottom: 32 },
});
