import React from 'react';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { StatsScreen } from '@/screens/stats/StatsScreen';
import { PlayerPage } from '@/screens/profile/PlayerPage';
import { TeamPageScreen } from '@/screens/profile/ProfileStubs';
import { colors } from '@/theme';
import type { StatsStackParamList } from './types';

const Stack = createNativeStackNavigator<StatsStackParamList>();

/** Stats tab stack — list screen plus the player/team profile destinations. */
export function StatsNavigator() {
  return (
    <Stack.Navigator
      screenOptions={{
        headerStyle: { backgroundColor: colors.secondary },
        headerTintColor: colors.primary,
        headerTitleStyle: { color: colors.white },
        contentStyle: { backgroundColor: colors.pageBackground },
      }}
    >
      <Stack.Screen name="StatsHome" component={StatsScreen} options={{ headerShown: false }} />
      <Stack.Screen name="PlayerPage" component={PlayerPage} options={{ title: '' }} />
      <Stack.Screen name="TeamPage" component={TeamPageScreen} options={{ title: '' }} />
    </Stack.Navigator>
  );
}
