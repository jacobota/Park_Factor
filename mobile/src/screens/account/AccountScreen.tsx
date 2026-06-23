import React, { useState } from 'react';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import { TabScreen } from '@/components/TabScreen';
import { AccountProfileSection } from './AccountProfileSection';
import { AccountSettingsSection } from './AccountSettingsSection';
import type { AccountStackParamList } from '@/navigation/types';

/** AccountView — Account / Settings subtabs. */
export function AccountScreen({ navigation }: NativeStackScreenProps<AccountStackParamList, 'AccountHome'>) {
  const [tab, setTab] = useState('Account');
  return (
    <TabScreen title="Account" tabs={['Account', 'Settings']} selected={tab} onSelect={setTab}>
      {tab === 'Account' ? (
        <AccountProfileSection navigation={navigation} />
      ) : (
        <AccountSettingsSection navigation={navigation} />
      )}
    </TabScreen>
  );
}
