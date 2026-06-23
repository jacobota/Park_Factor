import React, { useState } from 'react';
import { ActivityIndicator, StyleSheet, Text, TextInput, TouchableOpacity } from 'react-native';
import { updateEmail, updatePassword, updateUserTag } from '@/api/user';
import { ScreenContainer } from '@/components/ScreenContainer';
import { useAuth } from '@/context/AuthContext';
import type { User } from '@/types';
import { colors, radius, spacing, typography } from '@/theme';

/** Shared single-field settings form (Change Email / Password / User Tag). */
function FieldForm({
  title,
  label,
  initial,
  secure,
  keyboard,
  submit,
}: {
  title: string;
  label: string;
  initial: string;
  secure?: boolean;
  keyboard?: 'email-address' | 'default';
  submit: (value: string) => Promise<void>;
}) {
  const [value, setValue] = useState(initial);
  const [status, setStatus] = useState<{ ok: boolean; message: string } | null>(null);
  const [busy, setBusy] = useState(false);

  const onSave = async () => {
    setBusy(true);
    setStatus(null);
    try {
      await submit(value);
      setStatus({ ok: true, message: 'Saved' });
    } catch (e) {
      setStatus({ ok: false, message: e instanceof Error ? e.message : 'Failed to save' });
    } finally {
      setBusy(false);
    }
  };

  const canSave = value.trim().length > 0 && value !== initial && !busy;

  return (
    <ScreenContainer scroll background={colors.secondary} contentStyle={styles.content}>
      <Text style={styles.title}>{title}</Text>
      <Text style={styles.label}>{label}</Text>
      <TextInput
        value={value}
        onChangeText={setValue}
        secureTextEntry={secure}
        keyboardType={keyboard ?? 'default'}
        autoCapitalize="none"
        autoCorrect={false}
        style={styles.input}
        placeholderTextColor={colors.gray}
      />
      {!!status && (
        <Text style={[styles.status, { color: status.ok ? colors.primary : colors.bad }]}>{status.message}</Text>
      )}
      <TouchableOpacity disabled={!canSave} onPress={onSave} style={[styles.button, !canSave && styles.buttonDisabled]}>
        {busy ? (
          <ActivityIndicator color={colors.secondary} />
        ) : (
          <Text style={[styles.buttonText, !canSave && styles.buttonTextDisabled]}>Save</Text>
        )}
      </TouchableOpacity>
    </ScreenContainer>
  );
}

const patchUser = (set: (u: User) => Promise<void> | void, user: User | null, patch: Partial<User>) => {
  if (user) set({ ...user, ...patch });
};

export function ChangeEmailScreen() {
  const { user, setUser } = useAuth();
  return (
    <FieldForm
      title="Change Email"
      label="New Email"
      initial={user?.email ?? ''}
      keyboard="email-address"
      submit={async (email) => {
        await updateEmail(email);
        patchUser(setUser, user, { email });
      }}
    />
  );
}

export function ChangePasswordScreen() {
  return (
    <FieldForm
      title="Change Password"
      label="New Password"
      initial=""
      secure
      submit={async (password) => {
        await updatePassword(password);
      }}
    />
  );
}

export function ChangeUserTagScreen() {
  const { user, setUser } = useAuth();
  return (
    <FieldForm
      title="User Tag"
      label="New User Tag"
      initial={user?.userTag ?? ''}
      submit={async (userTag) => {
        await updateUserTag(userTag);
        patchUser(setUser, user, { userTag });
      }}
    />
  );
}

const styles = StyleSheet.create({
  content: { padding: spacing.lg },
  title: { ...typography.subtitleNorwester, color: colors.white, textAlign: 'center', marginBottom: spacing.lg },
  label: { ...typography.bigTextArchivo, color: colors.white, opacity: 0.7, marginBottom: spacing.sm },
  input: {
    borderWidth: 2, borderColor: colors.white, borderRadius: radius.sm, padding: spacing.md,
    color: colors.white, ...typography.text,
  },
  status: { ...typography.smallText, textAlign: 'center', marginTop: spacing.md },
  button: { backgroundColor: colors.primary, borderRadius: radius.sm, padding: spacing.md, alignItems: 'center', marginTop: spacing.lg },
  buttonDisabled: { backgroundColor: colors.cardBackground },
  buttonText: { ...typography.bigTextArchivo, color: colors.secondary },
  buttonTextDisabled: { color: colors.gray },
});
