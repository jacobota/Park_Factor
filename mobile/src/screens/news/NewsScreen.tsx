import React, { useState } from 'react';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import { TabScreen } from '@/components/TabScreen';
import { LeagueNewsSection } from './LeagueNewsSection';
import { CommunitySection } from './CommunitySection';
import { PostComposer } from './PostComposer';
import { useAuth } from '@/context/AuthContext';
import type { NewsStackParamList } from '@/navigation/types';

/** NewsView — "The Concourse": News / Community / Post (verified-only) subtabs. */
export function NewsScreen({ navigation }: NativeStackScreenProps<NewsStackParamList, 'NewsHome'>) {
  const { user } = useAuth();
  const tabs = ['News', 'Community', ...(user?.verified ? ['Post'] : [])];
  const [tab, setTab] = useState('News');

  return (
    <TabScreen title="The Concourse" tabs={tabs} selected={tab} onSelect={setTab}>
      {tab === 'News' && <LeagueNewsSection navigation={navigation} />}
      {tab === 'Community' && <CommunitySection navigation={navigation} />}
      {tab === 'Post' && <PostComposer />}
    </TabScreen>
  );
}
