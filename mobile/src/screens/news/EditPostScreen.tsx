import React, { useState } from 'react';
import { ActivityIndicator, StyleSheet, Text, TextInput, TouchableOpacity } from 'react-native';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import { useQueryClient } from '@tanstack/react-query';
import { updatePost } from '@/api/posts';
import { ScreenContainer } from '@/components/ScreenContainer';
import { colors, radius, spacing, typography } from '@/theme';
import type { NewsStackParamList } from '@/navigation/types';

const MAX = 255;

/** EditPostsView — edit a post's text. (Image replacement is deferred; see PostComposer note.) */
export function EditPostScreen({ route, navigation }: NativeStackScreenProps<NewsStackParamList, 'EditPost'>) {
  const { post } = route.params;
  const qc = useQueryClient();
  const [content, setContent] = useState(post.content ?? '');
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const changed = content.trim().length > 0 && content !== (post.content ?? '') && content.length <= MAX;

  const save = async () => {
    setSubmitting(true);
    setError(null);
    try {
      await updatePost(post.postId, { content, postImage: post.postImage ?? '' });
      qc.invalidateQueries({ queryKey: ['posts'] });
      qc.invalidateQueries({ queryKey: ['posts-by-author', post.author] });
      navigation.goBack();
    } catch (e) {
      setError(e instanceof Error ? e.message : 'Failed to update post');
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <ScreenContainer scroll background={colors.secondary} contentStyle={styles.content}>
      <Text style={styles.title}>Edit Post</Text>
      <Text style={styles.label}>Content</Text>
      <TextInput
        value={content}
        onChangeText={setContent}
        multiline
        maxLength={MAX}
        style={styles.input}
        placeholderTextColor={colors.gray}
      />
      <Text style={styles.counter}>{content.length}/{MAX}</Text>
      {!!error && <Text style={styles.error}>{error}</Text>}

      <TouchableOpacity disabled={!changed || submitting} onPress={save} style={[styles.button, (!changed || submitting) && styles.buttonDisabled]}>
        {submitting ? (
          <ActivityIndicator color={colors.secondary} />
        ) : (
          <Text style={[styles.buttonText, (!changed || submitting) && styles.buttonTextDisabled]}>Save</Text>
        )}
      </TouchableOpacity>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  content: { padding: spacing.lg },
  title: { ...typography.subtitleNorwester, color: colors.white, textAlign: 'center', marginBottom: spacing.lg },
  label: { ...typography.bigTextArchivo, color: colors.white, opacity: 0.7, marginBottom: spacing.sm },
  input: {
    borderWidth: 2,
    borderColor: colors.white,
    borderRadius: radius.sm,
    minHeight: 150,
    padding: spacing.md,
    color: colors.white,
    textAlignVertical: 'top',
    ...typography.text,
  },
  counter: { ...typography.smallTextNorwester, color: colors.white, textAlign: 'right', marginTop: spacing.xs },
  error: { ...typography.smallText, color: colors.bad, textAlign: 'center', marginTop: spacing.sm },
  button: { backgroundColor: colors.primary, borderRadius: radius.sm, padding: spacing.md, alignItems: 'center', marginTop: spacing.lg },
  buttonDisabled: { backgroundColor: colors.cardBackground },
  buttonText: { ...typography.bigTextArchivo, color: colors.secondary },
  buttonTextDisabled: { color: colors.gray },
});
