import React from 'react';
import { Alert, Image, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { Avatar } from '@/components/Avatar';
import { Card } from '@/components/Card';
import { deletePost as deletePostApi } from '@/api/posts';
import { updateLikedPosts } from '@/api/user';
import { useAuth } from '@/context/AuthContext';
import type { Post } from '@/types';
import { colors, radius, spacing, typography } from '@/theme';

/**
 * PostCardView — author row (avatar + verified badge), content, optional image, and a like
 * toggle. The owner additionally gets edit/delete controls. Likes + deletes persist through
 * the API and update the cached user.
 */
export function PostCard({
  post,
  onAuthorPress,
  onEdit,
  onDeleted,
}: {
  post: Post;
  onAuthorPress?: (author: string) => void;
  onEdit?: (post: Post) => void;
  onDeleted?: (post: Post) => void;
}) {
  const { user, setUser } = useAuth();
  const liked = user?.userLikedPosts?.includes(post.postId) ?? false;
  const isOwner = !!user && user.username === post.author;

  const toggleLike = async () => {
    if (!user) return;
    const current = user.userLikedPosts ?? [];
    const next = liked ? current.filter((id) => id !== post.postId) : [...current, post.postId];
    await setUser({ ...user, userLikedPosts: next });
    try {
      await updateLikedPosts(next);
    } catch {
      await setUser({ ...user, userLikedPosts: current });
    }
  };

  const confirmDelete = () => {
    Alert.alert('Delete Post', 'Are you sure you want to delete this post?\n\nThis action is permanent.', [
      { text: 'Cancel', style: 'cancel' },
      {
        text: 'Delete',
        style: 'destructive',
        onPress: async () => {
          try {
            await deletePostApi(post.postId);
            onDeleted?.(post);
          } catch {
            Alert.alert('Error', 'Could not delete the post.');
          }
        },
      },
    ]);
  };

  return (
    <Card style={styles.card}>
      <View style={styles.header}>
        <TouchableOpacity
          style={styles.authorRow}
          disabled={!onAuthorPress || !post.author}
          onPress={() => post.author && onAuthorPress?.(post.author)}
        >
          <Avatar uri={post.authorProfilePicture} name={post.author} size={40} />
          <Text style={styles.author} numberOfLines={1}>{post.author ?? 'Anonymous'}</Text>
          <Ionicons name="ribbon" size={14} color={colors.primary} style={styles.badge} />
        </TouchableOpacity>
        <View style={styles.spacer} />
        {isOwner && (
          <>
            <TouchableOpacity onPress={() => onEdit?.(post)} style={styles.ownerBtn}>
              <Ionicons name="pencil" size={20} color={colors.primary} />
            </TouchableOpacity>
            <TouchableOpacity onPress={confirmDelete} style={styles.ownerBtn}>
              <Ionicons name="trash" size={20} color={colors.bad} />
            </TouchableOpacity>
          </>
        )}
      </View>

      {!!post.content && <Text style={styles.content}>{post.content}</Text>}
      {!!post.postImage && <Image source={{ uri: post.postImage }} style={styles.image} resizeMode="cover" />}

      <View style={styles.footer}>
        <TouchableOpacity onPress={toggleLike}>
          <Ionicons name="thumbs-up" size={20} color={liked ? colors.primary : colors.white} />
        </TouchableOpacity>
      </View>
    </Card>
  );
}

const styles = StyleSheet.create({
  card: { backgroundColor: colors.elevated, borderWidth: StyleSheet.hairlineWidth, borderColor: colors.hairline, borderRadius: radius.lg, padding: spacing.lg, marginBottom: spacing.lg },
  header: { flexDirection: 'row', alignItems: 'center' },
  authorRow: { flexDirection: 'row', alignItems: 'center', flexShrink: 1 },
  author: { ...typography.textNorwester, color: colors.white, marginLeft: spacing.sm, flexShrink: 1 },
  badge: { marginLeft: 4 },
  spacer: { flex: 1 },
  ownerBtn: { paddingHorizontal: spacing.sm },
  content: { ...typography.smallText, color: colors.white, marginTop: spacing.md },
  image: { width: 120, height: 120, borderRadius: radius.lg, alignSelf: 'center', marginTop: spacing.md },
  footer: { flexDirection: 'row', justifyContent: 'flex-end', marginTop: spacing.md },
});
