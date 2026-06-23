import React from 'react';
import { StyleSheet, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { colors, typography } from '@/theme';

/** Rounded mint-outlined search field with a Clear button (PlayerSearchBarView). */
export function PlayerSearchBar({
  value,
  onChangeText,
  placeholder = 'Search players',
}: {
  value: string;
  onChangeText: (text: string) => void;
  placeholder?: string;
}) {
  return (
    <View style={styles.row}>
      <TextInput
        value={value}
        onChangeText={onChangeText}
        placeholder={placeholder}
        placeholderTextColor={colors.gray}
        autoCapitalize="none"
        autoCorrect={false}
        style={styles.input}
      />
      <TouchableOpacity onPress={() => onChangeText('')} style={styles.clear}>
        <Text style={styles.clearText}>Clear</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  row: { flexDirection: 'row', alignItems: 'center', padding: 10 },
  input: {
    flex: 1,
    padding: 10,
    borderRadius: 30,
    borderWidth: 4,
    borderColor: colors.primary,
    backgroundColor: colors.secondary,
    color: colors.primary,
    ...typography.text,
  },
  clear: { padding: 10 },
  clearText: { ...typography.text, color: colors.primary },
});
