import React, { useState } from 'react';
import { Ionicons } from '@expo/vector-icons';
import { StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { colors, radius, typography } from '@/theme';

/**
 * Custom dropdown (SwiftUI DropDownMenuView). Collapsed shows the selection + chevron;
 * expanded lists options with the active one in mint.
 */
export function DropDownMenu({
  options,
  selected,
  onSelect,
}: {
  options: string[];
  selected: string;
  onSelect: (option: string) => void;
}) {
  const [open, setOpen] = useState(false);

  return (
    <View style={styles.wrapper}>
      <TouchableOpacity style={styles.header} onPress={() => setOpen((o) => !o)} activeOpacity={0.8}>
        <Text style={styles.selected}>{selected}</Text>
        <Ionicons name={open ? 'chevron-up' : 'chevron-down'} size={20} color={colors.primary} />
      </TouchableOpacity>

      {open &&
        options.map((option) => (
          <TouchableOpacity
            key={option}
            style={styles.option}
            onPress={() => {
              onSelect(option);
              setOpen(false);
            }}
          >
            <Text style={[styles.optionText, option === selected && styles.optionActive]}>{option}</Text>
          </TouchableOpacity>
        ))}
    </View>
  );
}

const styles = StyleSheet.create({
  wrapper: {
    backgroundColor: colors.secondary,
    borderRadius: radius.lg,
    marginHorizontal: 16,
    marginVertical: 8,
    overflow: 'hidden',
    zIndex: 100,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 20,
    height: 56,
  },
  selected: { ...typography.bigTextNorwester, color: colors.primary },
  option: { paddingHorizontal: 20, paddingVertical: 14 },
  optionText: { ...typography.bigTextNorwester, color: colors.white },
  optionActive: { color: colors.primary },
});
