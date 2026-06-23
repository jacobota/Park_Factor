import React from 'react';
import { StyleSheet, Text } from 'react-native';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import { ScreenContainer } from '@/components/ScreenContainer';
import { PrimaryButton } from '@/components/PrimaryButton';
import { useAuth } from '@/context/AuthContext';
import { colors, typography } from '@/theme';
import type { AuthStackParamList } from '@/navigation/types';

/**
 * TODO: real onboarding (favorite-team + favorite-player selection) is ported in a
 * later pass — see Swift FollowingTeamsView / FollowingPlayersView. For now these
 * placeholders carry the flow through and complete sign-in.
 */

export function OnboardingTeamsScreen({
  navigation,
  route,
}: NativeStackScreenProps<AuthStackParamList, 'OnboardingTeams'>) {
  return (
    <ScreenContainer contentStyle={styles.center}>
      <Text style={styles.title}>Pick your teams</Text>
      <Text style={styles.subtitle}>Favorite-team selection coming soon.</Text>
      <PrimaryButton
        title="Continue"
        onPress={() => navigation.navigate('OnboardingPlayers', route.params)}
        style={styles.button}
      />
    </ScreenContainer>
  );
}

export function OnboardingPlayersScreen({
  route,
}: NativeStackScreenProps<AuthStackParamList, 'OnboardingPlayers'>) {
  const { signIn } = useAuth();
  return (
    <ScreenContainer contentStyle={styles.center}>
      <Text style={styles.title}>Pick your players</Text>
      <Text style={styles.subtitle}>Favorite-player selection coming soon.</Text>
      <PrimaryButton
        title="Enter Park Factor"
        onPress={() => signIn(route.params.user, route.params.token)}
        style={styles.button}
      />
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  center: { alignItems: 'center', justifyContent: 'center', paddingHorizontal: 24 },
  title: { ...typography.title, color: colors.white, fontWeight: 'bold', textAlign: 'center' },
  subtitle: { ...typography.smallText, color: colors.lightGray, marginTop: 8, textAlign: 'center' },
  button: { marginTop: 32, minWidth: '60%' },
});
