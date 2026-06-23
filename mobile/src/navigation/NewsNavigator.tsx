import React from 'react';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { NewsScreen } from '@/screens/news/NewsScreen';
import { ArticleDetailScreen } from '@/screens/news/ArticleDetailScreen';
import { EditPostScreen } from '@/screens/news/EditPostScreen';
import { UserProfileScreen } from '@/screens/social/UserProfileScreen';
import { colors } from '@/theme';
import type { NewsStackParamList } from './types';

const Stack = createNativeStackNavigator<NewsStackParamList>();

/** News / Concourse tab stack — feed plus article, post-edit, and user-profile destinations. */
export function NewsNavigator() {
  return (
    <Stack.Navigator
      screenOptions={{
        headerStyle: { backgroundColor: colors.secondary },
        headerTintColor: colors.primary,
        headerTitleStyle: { color: colors.white },
        contentStyle: { backgroundColor: colors.pageBackground },
      }}
    >
      <Stack.Screen name="NewsHome" component={NewsScreen} options={{ headerShown: false }} />
      <Stack.Screen name="ArticleDetail" component={ArticleDetailScreen} options={{ title: '' }} />
      <Stack.Screen name="EditPost" component={EditPostScreen} options={{ title: 'Edit Post' }} />
      <Stack.Screen name="UserProfile" component={UserProfileScreen} options={{ title: '' }} />
    </Stack.Navigator>
  );
}
