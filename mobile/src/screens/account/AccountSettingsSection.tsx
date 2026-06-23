import React from 'react';
import { Alert, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { deleteAccount } from '@/api/user';
import { ScreenContainer } from '@/components/ScreenContainer';
import { useAuth } from '@/context/AuthContext';
import { colors, radius, spacing, typography } from '@/theme';
import type { AccountStackParamList } from '@/navigation/types';

type Nav = NativeStackNavigationProp<AccountStackParamList, 'AccountHome'>;

/** AccountSettingsView — profile/account update links plus logout & delete. */
export function AccountSettingsSection({ navigation }: { navigation: Nav }) {
  const { signOut } = useAuth();

  const confirmLogout = () =>
    Alert.alert('Confirm Logout', 'Are you sure you want to logout?', [
      { text: 'Cancel', style: 'cancel' },
      { text: 'Logout', style: 'destructive', onPress: signOut },
    ]);

  const confirmDelete = () =>
    Alert.alert('Delete Account', 'Are you sure you want to delete your Park Factor account?\n\nThis action is permanent.', [
      { text: 'Cancel', style: 'cancel' },
      {
        text: 'Delete',
        style: 'destructive',
        onPress: async () => {
          try {
            await deleteAccount();
          } finally {
            await signOut();
          }
        },
      },
    ]);

  return (
    <ScreenContainer scroll edges={[]} background={colors.pageBackground} contentStyle={styles.content}>
      <Text style={styles.section}>Update Profile Overview</Text>
      <Row label="Change Profile Picture" onPress={() => Alert.alert('Coming soon', 'Profile picture upload is being reworked to use secure backend uploads.')} />
      <Row label="User Tag" onPress={() => navigation.navigate('ChangeUserTag')} />
      <Row label="Favorite Team" onPress={() => navigation.navigate('ChangeFavoriteTeam')} />
      <Row label="Favorite Player" onPress={() => navigation.navigate('ChangeFavoritePlayer')} />

      <Text style={styles.section}>Update Account Information</Text>
      <Row label="Change Email" onPress={() => navigation.navigate('ChangeEmail')} />
      <Row label="Change Password" onPress={() => navigation.navigate('ChangePassword')} />

      <Row label="Logout" onPress={confirmLogout} destructive />
      <Row label="Delete Account" onPress={confirmDelete} destructive />
    </ScreenContainer>
  );
}

const Row = ({ label, onPress, destructive }: { label: string; onPress: () => void; destructive?: boolean }) => (
  <TouchableOpacity onPress={onPress} style={[styles.row, destructive && styles.rowDestructive]}>
    <Text style={[styles.rowLabel, destructive && styles.rowLabelDestructive]}>{label}</Text>
  </TouchableOpacity>
);

const styles = StyleSheet.create({
  content: { padding: spacing.lg },
  section: { ...typography.textNorwester, color: colors.primary, marginTop: spacing.lg, marginBottom: spacing.sm },
  row: { backgroundColor: colors.elevated, borderWidth: StyleSheet.hairlineWidth, borderColor: colors.hairline, borderRadius: 30, paddingVertical: spacing.lg, alignItems: 'center', marginBottom: spacing.md },
  rowDestructive: { backgroundColor: colors.bad },
  rowLabel: { ...typography.subtitleNorwester, color: colors.primary },
  rowLabelDestructive: { color: colors.white },
});
