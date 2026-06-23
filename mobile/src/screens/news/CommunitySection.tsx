import React from 'react';
import { ActivityIndicator, FlatList, StyleSheet, Text, View } from 'react-native';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { getAllPosts } from '@/api/posts';
import { PostCard } from '@/components/cards/PostCard';
import type { Post } from '@/types';
import { colors, spacing, typography } from '@/theme';
import type { NewsStackParamList } from '@/navigation/types';

type Nav = NativeStackNavigationProp<NewsStackParamList, 'NewsHome'>;

/** ConcourseView — community feed of verified-user posts. */
export function CommunitySection({ navigation }: { navigation: Nav }) {
  const qc = useQueryClient();
  const { data, isLoading, isError } = useQuery({ queryKey: ['posts'], queryFn: getAllPosts });

  const removeFromCache = (post: Post) =>
    qc.setQueryData<Post[]>(['posts'], (cur) => (cur ?? []).filter((p) => p.postId !== post.postId));

  return (
    <FlatList<Post>
      data={data ?? []}
      keyExtractor={(p) => p.postId}
      style={styles.fill}
      contentContainerStyle={styles.content}
      renderItem={({ item }) => (
        <PostCard
          post={item}
          onAuthorPress={(username) => navigation.navigate('UserProfile', { username })}
          onEdit={(post) => navigation.navigate('EditPost', { post })}
          onDeleted={removeFromCache}
        />
      )}
      ListEmptyComponent={
        isLoading ? (
          <ActivityIndicator color={colors.primary} style={styles.empty} />
        ) : (
          <Text style={styles.message}>{isError ? 'Posts unavailable' : 'No posts yet'}</Text>
        )
      }
    />
  );
}

const styles = StyleSheet.create({
  fill: { flex: 1 },
  content: { padding: spacing.lg, flexGrow: 1 },
  empty: { marginTop: spacing.xl },
  message: { ...typography.smallText, color: colors.lightGray, textAlign: 'center', marginTop: spacing.xl },
});
