import React, { useState } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import { ScreenContainer } from '@/components/ScreenContainer';
import { LabeledInput } from '@/components/LabeledInput';
import { PrimaryButton } from '@/components/PrimaryButton';
import { login, register } from '@/api/auth';
import { ApiError } from '@/api/client';
import { setToken } from '@/api/storage';
import { colors, typography } from '@/theme';
import type { AuthStackParamList } from '@/navigation/types';

type Props = NativeStackScreenProps<AuthStackParamList, 'Signup'>;

export function SignupScreen({ navigation }: Props) {
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [error, setError] = useState('');

  const fieldsFilled = !!username && !!email && !!password && !!confirmPassword;
  const passwordsMatch = password === confirmPassword;
  const isFormValid = fieldsFilled && passwordsMatch;

  const onSignup = async () => {
    try {
      setError('');
      // Register, then auto-login (by email) so the user can pick favorites during onboarding.
      await register(username, email, password);
      const res = await login(email, password);
      // Store the token now (onboarding makes authed calls) but defer sign-in until
      // onboarding finishes, so the auth gate keeps us in the onboarding flow.
      await setToken(res.token);
      navigation.navigate('OnboardingTeams', { user: res.user, token: res.token });
    } catch (e) {
      setError(e instanceof ApiError ? e.message : 'Something went wrong. Please try again.');
    }
  };

  return (
    <ScreenContainer scroll contentStyle={styles.content}>
      <Text style={styles.title}>Sign up to Park Factor</Text>

      {!!error && <Text style={styles.error}>{error}</Text>}

      <View style={styles.form}>
        <LabeledInput label="Username" value={username} onChangeText={setUsername} />
        <LabeledInput label="Email" value={email} onChangeText={setEmail} keyboardType="email-address" />
        <LabeledInput label="Password" value={password} onChangeText={setPassword} secureTextEntry />
        <LabeledInput
          label="Confirm Password"
          value={confirmPassword}
          onChangeText={setConfirmPassword}
          secureTextEntry
        />
        <PrimaryButton title="Sign up" onPress={onSignup} disabled={!isFormValid} style={styles.button} />
      </View>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  content: { alignItems: 'center', paddingHorizontal: '10%', paddingVertical: 32 },
  title: { ...typography.title, color: colors.white, fontWeight: 'bold', textAlign: 'center', marginBottom: 20 },
  error: { ...typography.text, color: colors.bad, textAlign: 'center', marginBottom: 12 },
  form: { width: '100%' },
  button: { alignSelf: 'center', minWidth: '50%', marginTop: 24 },
});
