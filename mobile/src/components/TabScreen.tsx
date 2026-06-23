import React from 'react';
import { StyleSheet, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { TabHeader } from './TabHeader';
import { SubTabBar } from './SubTabBar';
import { colors } from '@/theme';

/**
 * Shared shell for the four root tabs (Stats / Concourse / Following / Account). The status-bar
 * inset is applied as padding on the header band only (not via a flex SafeAreaView), so the
 * content area always gets the full remaining height — no double-counted notch gap.
 */
export function TabScreen({
  title,
  tabs,
  selected,
  onSelect,
  children,
}: {
  title: string;
  tabs?: string[];
  selected?: string;
  onSelect?: (tab: string) => void;
  children: React.ReactNode;
}) {
  const insets = useSafeAreaInsets();
  return (
    <View style={styles.root}>
      <View style={[styles.header, { paddingTop: insets.top + 10 }]}>
        <TabHeader title={title} />
        {tabs && selected !== undefined && onSelect && (
          <SubTabBar tabs={tabs} selected={selected} onSelect={onSelect} />
        )}
      </View>
      <View style={styles.content}>{children}</View>
    </View>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1, backgroundColor: colors.pageBackground },
  header: {
    backgroundColor: colors.secondary,
    paddingBottom: 10,
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderBottomColor: colors.hairline,
  },
  content: { flex: 1, backgroundColor: colors.pageBackground },
});
