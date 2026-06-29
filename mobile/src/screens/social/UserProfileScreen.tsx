import React from 'react';
import { ActivityIndicator, FlatList, StyleSheet, Text, View } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import { getUserProfile } from '@/api/user';
import { getPostsByAuthor } from '@/api/posts';
import { Card } from '@/components/Card';
import { UserProfileCard } from '@/components/cards/UserProfileCard';
import { PostCard } from '@/components/cards/PostCard';
import type { Post } from '@/types';
import { colors, fonts, radius, spacing, typography } from '@/theme';
import type { AccountStackParamList } from '@/navigation/types';

// Both the News and Account stacks expose UserProfile + EditPost with identical params, so the
// screen can be reused in either; the Account list is the superset we type the navigator against.
type Nav = NativeStackNavigationProp<AccountStackParamList>;

/** AccountFromPostView — another user's public profile (overview, bio, and their posts). */
export function UserProfileScreen({ route }: { route: { params: { username: string } } }) {
  const { username } = route.params;
  const navigation = useNavigation<Nav>();
  const qc = useQueryClient();

  const profile = useQuery({ queryKey: ['user-profile', username], queryFn: () => getUserProfile(username) });
  const posts = useQuery({ queryKey: ['posts-by-author', username], queryFn: () => getPostsByAuthor(username) });

  if (profile.isLoading) {
    return (
      <View style={styles.center}>
        <ActivityIndicator color={colors.primary} />
      </View>
    );
  }
  if (!profile.data) {
    return (
      <View style={styles.center}>
        <Text style={styles.message}>Profile unavailable</Text>
      </View>
    );
  }

  const removeFromCache = (post: Post) =>
    qc.setQueryData<Post[]>(['posts-by-author', username], (cur) => (cur ?? []).filter((p) => p.postId !== post.postId));

  return (
    <FlatList<Post>
      data={posts.data ?? []}
      keyExtractor={(p) => p.postId}
      contentContainerStyle={styles.content}
      ListHeaderComponent={
        <>
          <Text style={styles.heading}>{profile.data.username}'s Profile</Text>
          <UserProfileCard user={profile.data} />
          <Card style={styles.bioCard}>
            <Text style={styles.bioTitle}>Bio</Text>
            <View style={styles.divider} />
            <Text style={styles.bioBody}>{profile.data.userBiography || 'N/A'}</Text>
          </Card>
          <Text style={styles.postsHeading}>Posts</Text>
        </>
      }
      renderItem={({ item }) => (
        <PostCard
          post={item}
          onAuthorPress={(u) => navigation.push('UserProfile', { username: u })}
          onEdit={(post) => navigation.navigate('EditPost', { post })}
          onDeleted={removeFromCache}
        />
      )}
      ListEmptyComponent={
        posts.isLoading ? (
          <ActivityIndicator color={colors.primary} style={styles.empty} />
        ) : (
          <Text style={styles.message}>N/A</Text>
        )
      }
    />
  );
}

const styles = StyleSheet.create({
  center: { flex: 1, backgroundColor: colors.pageBackground, alignItems: 'center', justifyContent: 'center' },
  content: { padding: spacing.lg, backgroundColor: colors.pageBackground },
  // Archivo Narrow renders accented usernames; Norwester lacks those glyphs.
  heading: { ...typography.bigTextNorwester, fontFamily: fonts.archivo, color: colors.primary, textAlign: 'center', marginBottom: spacing.md },
  bioCard: { backgroundColor: colors.elevated, borderWidth: StyleSheet.hairlineWidth, borderColor: colors.hairline, borderRadius: radius.lg, padding: spacing.lg, marginBottom: spacing.lg },
  bioTitle: { ...typography.bigTextNorwester, color: colors.white },
  divider: { height: StyleSheet.hairlineWidth, backgroundColor: colors.border, marginVertical: spacing.md },
  bioBody: { ...typography.smallText, color: colors.white },
  postsHeading: { ...typography.textNorwester, color: colors.white, textAlign: 'center', marginBottom: spacing.md },
  empty: { marginTop: spacing.lg },
  message: { ...typography.smallText, color: colors.lightGray, textAlign: 'center', marginTop: spacing.lg },
});
