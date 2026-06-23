import React from 'react';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { AccountScreen } from '@/screens/account/AccountScreen';
import {
  ChangeEmailScreen,
  ChangePasswordScreen,
  ChangeUserTagScreen,
} from '@/screens/account/ChangeFieldScreens';
import { ChangeFavoritePlayerScreen, ChangeFavoriteTeamScreen } from '@/screens/account/ChangeFavoriteScreens';
import { UserProfileScreen } from '@/screens/social/UserProfileScreen';
import { EditPostScreen } from '@/screens/news/EditPostScreen';
import { PlayerPage } from '@/screens/profile/PlayerPage';
import { TeamPage } from '@/screens/team/TeamPage';
import { colors } from '@/theme';
import type { AccountStackParamList } from './types';

const Stack = createNativeStackNavigator<AccountStackParamList>();

/** Account tab stack — profile/settings home plus all settings detail + profile destinations. */
export function AccountNavigator() {
  return (
    <Stack.Navigator
      screenOptions={{
        headerStyle: { backgroundColor: colors.secondary },
        headerTintColor: colors.primary,
        headerTitleStyle: { color: colors.white },
        contentStyle: { backgroundColor: colors.pageBackground },
      }}
    >
      <Stack.Screen name="AccountHome" component={AccountScreen} options={{ headerShown: false }} />
      <Stack.Screen name="ChangeEmail" component={ChangeEmailScreen} options={{ title: 'Change Email' }} />
      <Stack.Screen name="ChangePassword" component={ChangePasswordScreen} options={{ title: 'Change Password' }} />
      <Stack.Screen name="ChangeUserTag" component={ChangeUserTagScreen} options={{ title: 'User Tag' }} />
      <Stack.Screen name="ChangeFavoriteTeam" component={ChangeFavoriteTeamScreen} options={{ title: 'Favorite Team' }} />
      <Stack.Screen name="ChangeFavoritePlayer" component={ChangeFavoritePlayerScreen} options={{ title: 'Favorite Player' }} />
      <Stack.Screen name="UserProfile" component={UserProfileScreen} options={{ title: '' }} />
      <Stack.Screen name="EditPost" component={EditPostScreen} options={{ title: 'Edit Post' }} />
      <Stack.Screen name="PlayerPage" component={PlayerPage} options={{ title: '' }} />
      <Stack.Screen name="TeamPage" component={TeamPage} options={{ title: '' }} />
    </Stack.Navigator>
  );
}
