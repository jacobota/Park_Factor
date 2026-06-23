import React from 'react';
import { DarkTheme, NavigationContainer, Theme } from '@react-navigation/native';
import { useAuth } from '@/context/AuthContext';
import { LoadingScreen } from '@/components/LoadingScreen';
import { colors } from '@/theme';
import { AuthNavigator } from './AuthNavigator';
import { TabNavigator } from './TabNavigator';

const navTheme: Theme = {
  ...DarkTheme,
  colors: {
    ...DarkTheme.colors,
    background: colors.secondary,
    card: colors.secondary,
    primary: colors.primary,
    border: colors.border,
    text: colors.white,
  },
};

/** Auth gate — mirrors ContentView: loading -> login flow -> tab bar. */
export function RootNavigator() {
  const { isLoggedIn, isBootstrapping } = useAuth();

  if (isBootstrapping) return <LoadingScreen />;

  return (
    <NavigationContainer theme={navTheme}>
      {isLoggedIn ? <TabNavigator /> : <AuthNavigator />}
    </NavigationContainer>
  );
}
