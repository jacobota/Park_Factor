import React from 'react';
import { StyleSheet, Text, TouchableOpacity, ViewStyle } from 'react-native';
import { colors, radius, typography } from '@/theme';

/**
 * The mint pill button used on the auth screens: filled mint when enabled,
 * transparent with a white outline when disabled.
 */
export function PrimaryButton({
  title,
  onPress,
  disabled = false,
  style,
}: {
  title: string;
  onPress: () => void;
  disabled?: boolean;
  style?: ViewStyle;
}) {
  return (
    <TouchableOpacity
      onPress={onPress}
      disabled={disabled}
      activeOpacity={0.8}
      style={[styles.button, disabled ? styles.disabled : styles.enabled, style]}
    >
      <Text style={[styles.label, { color: disabled ? colors.gray : colors.secondary }]}>{title}</Text>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  button: {
    paddingVertical: 12,
    paddingHorizontal: 24,
    borderRadius: radius.sm,
    borderWidth: 2,
    borderColor: colors.white,
    alignItems: 'center',
    justifyContent: 'center',
  },
  enabled: { backgroundColor: colors.primary },
  disabled: { backgroundColor: 'transparent' },
  label: { ...typography.subtitleArchivo },
});
