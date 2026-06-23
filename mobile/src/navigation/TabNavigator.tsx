import React from 'react';
import { Ionicons } from '@expo/vector-icons';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { StatsNavigator } from './StatsNavigator';
import { NewsNavigator } from './NewsNavigator';
import { FollowingNavigator } from './FollowingNavigator';
import { AccountNavigator } from './AccountNavigator';
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
        tabBarStyle: { backgroundColor: colors.secondary, borderTopColor: colors.border, paddingTop: 6 },
        tabBarLabelStyle: { fontSize: 10, paddingBottom: 2 },
        sceneStyle: { backgroundColor: colors.secondary },
        tabBarIcon: ({ color }) => <Ionicons name={ICONS[route.name]} color={color} size={20} />,
      })}
    >
      <Tab.Screen name="Stats" component={StatsNavigator} />
      <Tab.Screen name="Concourse" component={NewsNavigator} />
      <Tab.Screen name="Following" component={FollowingNavigator} />
      <Tab.Screen name="Account" component={AccountNavigator} />
    </Tab.Navigator>
  );
}
