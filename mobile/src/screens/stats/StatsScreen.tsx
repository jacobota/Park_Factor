import React, { useState } from 'react';
import { ScrollView, StyleSheet } from 'react-native';
import { TabScreen } from '@/components/TabScreen';
import { PlayerStatsSection } from './PlayerStatsSection';
import { TeamStatsSection } from './TeamStatsSection';

const TABS = ['Teams', 'Players'];

/** StatsView — header, Teams/Players toggle, then the selected section. */
export function StatsScreen() {
  const [tab, setTab] = useState('Teams');

  return (
    <TabScreen title="Stats" tabs={TABS} selected={tab} onSelect={setTab}>
      <ScrollView style={styles.scroll} contentContainerStyle={styles.content}>
        {tab === 'Teams' ? <TeamStatsSection /> : <PlayerStatsSection />}
      </ScrollView>
    </TabScreen>
  );
}

const styles = StyleSheet.create({
  scroll: { flex: 1 },
  content: { paddingBottom: 24 },
});
