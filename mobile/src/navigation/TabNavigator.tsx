import React from 'react';
import { Ionicons } from '@expo/vector-icons';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { AccountScreen, ConcourseScreen, FollowingScreen } from '@/screens/Placeholder';
import { StatsNavigator } from './StatsNavigator';
import { colors } from '@/theme';

export type TabParamList = {
  Stats: undefined;
  Concourse: undefined;
  Following: undefined;
  Account: undefined;
};

const Tab = createBottomTabNavigator<TabParamList>();

const ICONS: Record<keyof TabParamList, keyof typeof Ionicons.glyphMap> = {
  Stats: 'stats-chart',
  Concourse: 'newspaper',
  Following: 'flag',
  Account: 'person',
};

/** TabBarView — 4 tabs, Stats first (matches Swift default selection). */
export function TabNavigator() {
  return (
    <Tab.Navigator
      initialRouteName="Stats"
      screenOptions={({ route }) => ({
        headerShown: false,
        tabBarActiveTintColor: colors.primary,
        tabBarInactiveTintColor: colors.lightGray,
        tabBarStyle: { backgroundColor: colors.secondary, borderTopColor: colors.border },
        sceneStyle: { backgroundColor: colors.secondary },
        tabBarIcon: ({ color, size }) => (
          <Ionicons name={ICONS[route.name]} color={color} size={size} />
        ),
      })}
    >
      <Tab.Screen name="Stats" component={StatsNavigator} />
      <Tab.Screen name="Concourse" component={ConcourseScreen} />
      <Tab.Screen name="Following" component={FollowingScreen} />
      <Tab.Screen name="Account" component={AccountScreen} />
    </Tab.Navigator>
  );
}
