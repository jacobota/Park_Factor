import React, { useState } from 'react';
import { ActivityIndicator, StyleSheet, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { getPostById, getPostsByAuthor } from '@/api/posts';
import { updateUserBiography } from '@/api/user';
import { Card } from '@/components/Card';
import { ScreenContainer } from '@/components/ScreenContainer';
import { UserProfileCard } from '@/components/cards/UserProfileCard';
import { PostCard } from '@/components/cards/PostCard';
import { SubTabBar } from '@/components/SubTabBar';
import { useAuth } from '@/context/AuthContext';
import type { Post } from '@/types';
import { colors, radius, spacing, typography } from '@/theme';
import type { AccountStackParamList } from '@/navigation/types';

const MAX = 255;
type Nav = NativeStackNavigationProp<AccountStackParamList, 'AccountHome'>;

/** AccountPageView — profile overview, editable bio, and Liked / Your posts. */
export function AccountProfileSection({ navigation }: { navigation: Nav }) {
  const { user } = useAuth();
  const [postTab, setPostTab] = useState('Liked Posts');
  if (!user) return null;

  const tabs = ['Liked Posts', ...(user.verified ? ['Your Posts'] : [])];

  return (
    <ScreenContainer scroll edges={[]} background={colors.pageBackground} contentStyle={styles.content}>
      <UserProfileCard user={user} />
      <BioCard />
      <Card style={styles.postsCard}>
        <SubTabBar tabs={tabs} selected={postTab} onSelect={setPostTab} />
        <View style={styles.divider} />
        {postTab === 'Liked Posts' ? <LikedPosts navigation={navigation} /> : <YourPosts navigation={navigation} />}
      </Card>
    </ScreenContainer>
  );
}

/** Editable biography card (≤255 chars). */
function BioCard() {
  const { user, setUser } = useAuth();
  const [editing, setEditing] = useState(false);
  const [bio, setBio] = useState(user?.userBiography ?? '');
  const [error, setError] = useState<string | null>(null);

  const save = async () => {
    if (!user) return;
    if (bio.length > MAX) {
      setError('Bio exceeds character limit');
      return;
    }
    setError(null);
    await setUser({ ...user, userBiography: bio });
    try {
      await updateUserBiography(bio);
      setEditing(false);
    } catch (e) {
      setError(e instanceof Error ? e.message : 'Failed to save bio');
    }
  };

  return (
    <Card style={styles.card}>
      <View style={styles.cardHeader}>
        <Text style={styles.cardTitle}>Bio</Text>
        <TouchableOpacity onPress={() => setEditing((v) => !v)}>
          <Ionicons name="pencil" size={22} color={editing ? colors.primary : colors.white} />
        </TouchableOpacity>
      </View>
      <View style={styles.divider} />
      {editing ? (
        <>
          <TextInput value={bio} onChangeText={setBio} multiline maxLength={MAX} style={styles.input} />
          <View style={styles.bioFooter}>
            <TouchableOpacity onPress={save} style={styles.saveBtn}>
              <Text style={styles.saveText}>Save</Text>
            </TouchableOpacity>
            <Text style={styles.counter}>{bio.length}/{MAX}</Text>
          </View>
          {!!error && <Text style={styles.error}>{error}</Text>}
        </>
      ) : (
        <Text style={styles.bioBody}>{user?.userBiography || 'N/A'}</Text>
      )}
    </Card>
  );
}

/** AccountPageLikedPostsView — hydrate each liked post id, newest first. */
function LikedPosts({ navigation }: { navigation: Nav }) {
  const { user } = useAuth();
  const qc = useQueryClient();
  const ids = user?.userLikedPosts ?? [];

  const { data, isLoading } = useQuery({
    queryKey: ['liked-posts', ids],
    queryFn: async () => {
      const settled = await Promise.allSettled(ids.map(getPostById));
      return settled
        .filter((r): r is PromiseFulfilledResult<Post> => r.status === 'fulfilled' && !!r.value)
        .map((r) => r.value)
        .reverse();
    },
  });

  const remove = (post: Post) =>
    qc.setQueryData<Post[]>(['liked-posts', ids], (cur) => (cur ?? []).filter((p) => p.postId !== post.postId));

  return <PostList posts={data} loading={isLoading} navigation={navigation} onDeleted={remove} />;
}

/** AccountPageYourPostsView — the verified user's own posts. */
function YourPosts({ navigation }: { navigation: Nav }) {
  const { user } = useAuth();
  const qc = useQueryClient();
  const username = user?.username ?? '';
  const { data, isLoading } = useQuery({
    queryKey: ['posts-by-author', username],
    queryFn: () => getPostsByAuthor(username),
  });

  const remove = (post: Post) =>
    qc.setQueryData<Post[]>(['posts-by-author', username], (cur) => (cur ?? []).filter((p) => p.postId !== post.postId));

  return <PostList posts={data} loading={isLoading} navigation={navigation} onDeleted={remove} />;
}

function PostList({
  posts,
  loading,
  navigation,
  onDeleted,
}: {
  posts?: Post[];
  loading: boolean;
  navigation: Nav;
  onDeleted: (post: Post) => void;
}) {
  if (loading) return <ActivityIndicator color={colors.primary} style={styles.empty} />;
  if (!posts || posts.length === 0) return <Text style={styles.na}>N/A</Text>;
  return (
    <View>
      {posts.map((post) => (
        <PostCard
          key={post.postId}
          post={post}
          onAuthorPress={(username) => navigation.navigate('UserProfile', { username })}
          onEdit={(p) => navigation.navigate('EditPost', { post: p })}
          onDeleted={onDeleted}
        />
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  content: { padding: spacing.lg },
  card: { backgroundColor: colors.elevated, borderWidth: StyleSheet.hairlineWidth, borderColor: colors.hairline, borderRadius: radius.lg, padding: spacing.lg, marginBottom: spacing.lg },
  cardHeader: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' },
  cardTitle: { ...typography.bigTextNorwester, color: colors.white },
  divider: { height: StyleSheet.hairlineWidth, backgroundColor: colors.border, marginVertical: spacing.md },
  bioBody: { ...typography.smallText, color: colors.white },
  input: {
    borderWidth: 2, borderColor: colors.white, borderRadius: radius.sm, minHeight: 120,
    padding: spacing.md, color: colors.white, textAlignVertical: 'top', ...typography.text,
  },
  bioFooter: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', marginTop: spacing.md },
  saveBtn: { backgroundColor: colors.primary, borderRadius: radius.sm, paddingVertical: spacing.sm, paddingHorizontal: spacing.xl },
  saveText: { ...typography.text, color: colors.secondary },
  counter: { ...typography.smallTextNorwester, color: colors.primary },
  error: { ...typography.smallText, color: colors.bad, marginTop: spacing.sm },
  postsCard: { backgroundColor: colors.elevated, borderWidth: StyleSheet.hairlineWidth, borderColor: colors.hairline, borderRadius: radius.lg, padding: spacing.lg },
  empty: { marginVertical: spacing.lg },
  na: { ...typography.bigTextNorwester, color: colors.white, textAlign: 'center', marginVertical: spacing.lg },
});
