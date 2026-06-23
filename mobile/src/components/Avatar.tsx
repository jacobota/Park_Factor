import React from 'react';
import { Image, StyleSheet, Text, View } from 'react-native';
import { colors, fonts } from '@/theme';

/**
 * Circular avatar with a mint ring. Falls back to a monogram of `name` when no image is
 * available (CLAUDE.md design language: "Monogram + initials placeholders through v1"),
 * replacing the Swift `Image("ParkFactorLogo")` placeholder.
 */
export function Avatar({
  uri,
  name,
  size = 40,
}: {
  uri?: string | null;
  name?: string | null;
  size?: number;
}) {
  const initials = (name ?? '')
    .split(/\s+/)
    .filter(Boolean)
    .slice(0, 2)
    .map((w) => w[0]?.toUpperCase())
    .join('');

  const ring = { width: size, height: size, borderRadius: size / 2 };

  return (
    <View style={[styles.ring, ring]}>
      {uri ? (
        <Image source={{ uri }} style={[ring, styles.img]} resizeMode="cover" />
      ) : (
        <Text style={[styles.initials, { fontSize: size * 0.4 }]}>{initials || '⚾'}</Text>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  ring: {
    borderWidth: 2,
    borderColor: colors.primary,
    backgroundColor: colors.secondary,
    alignItems: 'center',
    justifyContent: 'center',
    overflow: 'hidden',
  },
  img: { borderWidth: 0 },
  initials: { fontFamily: fonts.norwester, color: colors.primary },
});
