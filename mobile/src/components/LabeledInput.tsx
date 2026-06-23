import React, { useState } from 'react';
import { StyleSheet, Text, TextInput, TextInputProps, View } from 'react-native';
import { colors, radius, typography } from '@/theme';

/**
 * Labeled text field used on the auth forms. The label + border switch to mint on focus,
 * matching the SwiftUI focus styling.
 */
export function LabeledInput({
  label,
  value,
  onChangeText,
  secureTextEntry,
  ...rest
}: {
  label: string;
  value: string;
  onChangeText: (text: string) => void;
  secureTextEntry?: boolean;
} & Omit<TextInputProps, 'value' | 'onChangeText' | 'secureTextEntry'>) {
  const [focused, setFocused] = useState(false);
  const accent = focused ? colors.primary : colors.white;

  return (
    <View style={styles.wrapper}>
      <Text style={[styles.label, { color: accent, opacity: focused ? 1 : 0.6 }]}>{label}</Text>
      <TextInput
        value={value}
        onChangeText={onChangeText}
        secureTextEntry={secureTextEntry}
        onFocus={() => setFocused(true)}
        onBlur={() => setFocused(false)}
        autoCapitalize="none"
        autoCorrect={false}
        style={[styles.input, { color: accent, borderColor: accent }]}
        {...rest}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  wrapper: { marginBottom: 16 },
  label: { ...typography.subtitleArchivo, marginBottom: 6 },
  input: {
    backgroundColor: colors.secondary,
    borderWidth: 2,
    borderRadius: radius.sm,
    paddingHorizontal: 12,
    paddingVertical: 10,
    ...typography.text,
  },
});
