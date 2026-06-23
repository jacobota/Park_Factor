import React from 'react';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { FollowingScreen } from '@/screens/following/FollowingScreen';
import { PlayerPage } from '@/screens/profile/PlayerPage';
import { TeamPage } from '@/screens/team/TeamPage';
import { colors } from '@/theme';
import type { FollowingStackParamList } from './types';

const Stack = createNativeStackNavigator<FollowingStackParamList>();

/** Following tab stack — follow management plus the shared player/team profile destinations. */
export function FollowingNavigator() {
  return (
    <Stack.Navigator
      screenOptions={{
        headerStyle: { backgroundColor: colors.secondary },
        headerTintColor: colors.primary,
        headerTitleStyle: { color: colors.white },
        contentStyle: { backgroundColor: colors.pageBackground },
      }}
    >
      <Stack.Screen name="FollowingHome" component={FollowingScreen} options={{ headerShown: false }} />
      <Stack.Screen name="PlayerPage" component={PlayerPage} options={{ title: '' }} />
      <Stack.Screen name="TeamPage" component={TeamPage} options={{ title: '' }} />
    </Stack.Navigator>
  );
}
