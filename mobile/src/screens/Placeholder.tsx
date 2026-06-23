import React from 'react';
import { StyleSheet, Text } from 'react-native';
import { ScreenContainer } from '@/components/ScreenContainer';
import { PrimaryButton } from '@/components/PrimaryButton';
import { useAuth } from '@/context/AuthContext';
import { colors, typography } from '@/theme';

/** Temporary tab content — each real tab screen lands in a later task. */
export function Placeholder({ title }: { title: string }) {
  return (
    <ScreenContainer contentStyle={styles.center}>
      <Text style={styles.title}>{title}</Text>
      <Text style={styles.subtitle}>Coming soon</Text>
    </ScreenContainer>
  );
}

export const ConcourseScreen = () => <Placeholder title="Concourse" />;
export const FollowingScreen = () => <Placeholder title="Following" />;

/** Account placeholder keeps a sign-out so the auth flow is testable end-to-end. */
export function AccountScreen() {
  const { user, signOut } = useAuth();
  return (
    <ScreenContainer contentStyle={styles.center}>
      <Text style={styles.title}>Account</Text>
      {!!user && <Text style={styles.subtitle}>Signed in as {user.username}</Text>}
      <PrimaryButton title="Sign out" onPress={signOut} style={styles.button} />
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  center: { alignItems: 'center', justifyContent: 'center' },
  title: { ...typography.title, color: colors.primary },
  subtitle: { ...typography.smallText, color: colors.lightGray, marginTop: 8 },
  button: { marginTop: 32, minWidth: '50%' },
});
