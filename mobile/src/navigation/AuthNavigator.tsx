import React from 'react';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { LoginScreen } from '@/screens/auth/LoginScreen';
import { SignupScreen } from '@/screens/auth/SignupScreen';
import { OnboardingPlayersScreen, OnboardingTeamsScreen } from '@/screens/auth/OnboardingScreens';
import { colors } from '@/theme';
import type { AuthStackParamList } from './types';

const Stack = createNativeStackNavigator<AuthStackParamList>();

export function AuthNavigator() {
  return (
    <Stack.Navigator
      screenOptions={{
        headerShown: false,
        contentStyle: { backgroundColor: colors.secondary },
      }}
    >
      <Stack.Screen name="Login" component={LoginScreen} />
      <Stack.Screen name="Signup" component={SignupScreen} />
      <Stack.Screen name="OnboardingTeams" component={OnboardingTeamsScreen} />
      <Stack.Screen name="OnboardingPlayers" component={OnboardingPlayersScreen} />
    </Stack.Navigator>
  );
}
