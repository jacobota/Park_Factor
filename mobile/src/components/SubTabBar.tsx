import React from 'react';
import { ScrollView, StyleSheet, Text, TouchableOpacity } from 'react-native';
import { colors, typography } from '@/theme';

/** Horizontal text toggle (the StatsView Teams/Players switch): active mint, inactive gray. */
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
      scrollEnabled={false}
    >
      {tabs.map((tab) => (
        <TouchableOpacity key={tab} onPress={() => onSelect(tab)} style={styles.tab}>
          <Text style={[styles.label, { color: selected === tab ? colors.primary : colors.gray }]}>{tab}</Text>
        </TouchableOpacity>
      ))}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  row: { paddingHorizontal: 16, alignItems: 'center' },
  tab: { paddingVertical: 8, paddingHorizontal: 16 },
  label: { ...typography.textNorwester },
});
