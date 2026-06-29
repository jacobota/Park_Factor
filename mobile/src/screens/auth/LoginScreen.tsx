import React, { useState } from 'react';
import { Image, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import { ScreenContainer } from '@/components/ScreenContainer';
import { LabeledInput } from '@/components/LabeledInput';
import { PrimaryButton } from '@/components/PrimaryButton';
import { useAuth } from '@/context/AuthContext';
import { login } from '@/api/auth';
import { ApiError } from '@/api/client';
import { colors, typography } from '@/theme';
import type { AuthStackParamList } from '@/navigation/types';

type Props = NativeStackScreenProps<AuthStackParamList, 'Login'>;

export function LoginScreen({ navigation }: Props) {
  const { signIn } = useAuth();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');

  const isFormValid = email.length > 0 && password.length > 0;

  const onLogin = async () => {
    try {
      setError('');
      const res = await login(email, password);
      await signIn(res.user, res.token);
    } catch (e) {
      setError(e instanceof ApiError ? e.message : 'Something went wrong. Please try again.');
    }
  };

  return (
    <ScreenContainer scroll contentStyle={styles.content}>
      <Text style={styles.title}>Welcome to Park Factor</Text>
      <Image source={require('@/assets/ParkFactorLogo.jpg')} style={styles.logo} resizeMode="contain" />

      {!!error && <Text style={styles.error}>{error}</Text>}

      <View style={styles.form}>
        <LabeledInput
          label="Email"
          value={email}
          onChangeText={setEmail}
          keyboardType="email-address"
          autoCapitalize="none"
        />
        <LabeledInput label="Password" value={password} onChangeText={setPassword} secureTextEntry />
        <PrimaryButton title="Login" onPress={onLogin} disabled={!isFormValid} style={styles.button} />
      </View>

      <View style={styles.footer}>
        <Text style={styles.footerText}>Don't have an account? </Text>
        <TouchableOpacity onPress={() => navigation.navigate('Signup')}>
          <Text style={styles.link}>Sign up</Text>
        </TouchableOpacity>
      </View>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  content: { alignItems: 'center', paddingHorizontal: '10%', paddingVertical: 32 },
  title: { ...typography.title, color: colors.white, fontWeight: 'bold', textAlign: 'center' },
  logo: { width: 200, height: 200, marginVertical: 16, borderRadius: 12 },
  error: { ...typography.text, color: colors.bad, textAlign: 'center', marginBottom: 12 },
  form: { width: '100%', marginTop: 8 },
  button: { alignSelf: 'center', minWidth: '50%', marginTop: 24 },
  footer: { flexDirection: 'row', marginTop: 32, alignItems: 'center' },
  footerText: { ...typography.smallText, color: colors.white },
  link: { ...typography.smallText, color: colors.primary },
});
