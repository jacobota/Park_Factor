import React from 'react';
import { ScrollView, StyleSheet, Text, TouchableOpacity } from 'react-native';
import { colors, fonts, radius } from '@/theme';

/**
 * Horizontal segmented toggle. Uppercase, letter-spaced labels; the active tab is wrapped in a
 * thin mint outline (the "Concourse" look). Inactive tabs keep a transparent border so heights
 * stay aligned.
 */
export function SubTabBar({
  tabs,
  selected,
  onSelect,
}: {
  tabs: string[];
  selected: string;
  onSelect: (tab: string) => void;
}) {
  return (
    <ScrollView
      horizontal
      showsHorizontalScrollIndicator={false}
      contentContainerStyle={styles.row}
    >
      {tabs.map((tab) => {
        const active = selected === tab;
        return (
          <TouchableOpacity
            key={tab}
            onPress={() => onSelect(tab)}
            style={[styles.tab, { borderColor: active ? colors.primary : 'transparent' }]}
          >
            <Text style={[styles.label, { color: active ? colors.primary : colors.gray }]}>{tab.toUpperCase()}</Text>
          </TouchableOpacity>
        );
      })}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  row: { paddingHorizontal: 14, alignItems: 'center' },
  tab: { paddingVertical: 5, paddingHorizontal: 11, marginRight: 8, borderRadius: radius.sm, borderWidth: 1 },
  label: { fontFamily: fonts.norwester, fontSize: 13, letterSpacing: 1.2 },
});
