import React, { useState } from 'react';
import { ActivityIndicator, StyleSheet, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { useQueryClient } from '@tanstack/react-query';
import { createPost } from '@/api/posts';
import { useAuth } from '@/context/AuthContext';
import { Card } from '@/components/Card';
import { ScreenContainer } from '@/components/ScreenContainer';
import { colors, radius, spacing, typography } from '@/theme';

const MAX = 255;

/**
 * PostTemplateView — compose a post to the Concourse. Image attachment is deferred: the Swift
 * app uploaded directly to S3 with embedded credentials, which we intentionally do not port to
 * the client (the backend should mint pre-signed URLs instead). Text posts work end-to-end.
 */
export function PostComposer() {
  const { user } = useAuth();
  const qc = useQueryClient();
  const [content, setContent] = useState('');
  const [status, setStatus] = useState<{ ok: boolean; message: string } | null>(null);
  const [submitting, setSubmitting] = useState(false);

  const canPost = content.trim().length > 0 && content.length <= MAX && !submitting;

  const submit = async () => {
    setSubmitting(true);
    setStatus(null);
    try {
      await createPost({ content, authorProfilePicture: user?.profilePicture ?? '' });
      setContent('');
      setStatus({ ok: true, message: 'Successfully created post' });
      qc.invalidateQueries({ queryKey: ['posts'] });
    } catch (e) {
      setStatus({ ok: false, message: e instanceof Error ? e.message : 'Failed to create post' });
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <ScreenContainer scroll edges={[]} background={colors.pageBackground} contentStyle={styles.content}>
      <Card style={styles.card}>
        <Text style={styles.title}>Post to the Concourse</Text>

        <Text style={styles.label}>Content</Text>
        <TextInput
          value={content}
          onChangeText={setContent}
          placeholder="Share your take…"
          placeholderTextColor={colors.gray}
          multiline
          maxLength={MAX}
          style={styles.input}
        />
        <Text style={styles.counter}>{content.length}/{MAX}</Text>

        {!!status && (
          <Text style={[styles.status, { color: status.ok ? colors.primary : colors.bad }]}>{status.message}</Text>
        )}

        <TouchableOpacity disabled={!canPost} onPress={submit} style={[styles.button, !canPost && styles.buttonDisabled]}>
          {submitting ? (
            <ActivityIndicator color={colors.secondary} />
          ) : (
            <Text style={[styles.buttonText, !canPost && styles.buttonTextDisabled]}>Post</Text>
          )}
        </TouchableOpacity>
      </Card>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  content: { padding: spacing.lg },
  card: { backgroundColor: colors.elevated, borderWidth: StyleSheet.hairlineWidth, borderColor: colors.hairline, borderRadius: radius.lg, padding: spacing.lg },
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
  status: { ...typography.smallText, textAlign: 'center', marginTop: spacing.sm },
  button: { backgroundColor: colors.primary, borderRadius: radius.sm, padding: spacing.md, alignItems: 'center', marginTop: spacing.lg },
  buttonDisabled: { backgroundColor: colors.cardBackground },
  buttonText: { ...typography.bigTextArchivo, color: colors.secondary },
  buttonTextDisabled: { color: colors.gray },
});
