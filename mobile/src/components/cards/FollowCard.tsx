import React from 'react';
import { Image, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { colors, fonts, radius, spacing, typography } from '@/theme';

/**
 * FollowingPageTeamCard / FollowingPagePlayerCard, unified. A circular logo/headshot + name
 * (tappable to navigate), with a check/plus toggle on the right. The image sits on a white
 * disc so transparent MLB logos stay visible.
 */
export function FollowCard({
  imageUri,
  name,
  isSelected,
  onToggle,
  onPress,
}: {
  imageUri?: string | null;
  name: string;
  isSelected: boolean;
  onToggle: () => void;
  onPress?: () => void;
}) {
  return (
    <View style={styles.card}>
      <TouchableOpacity style={styles.left} disabled={!onPress} onPress={onPress}>
        <View style={styles.disc}>
          {!!imageUri && <Image source={{ uri: imageUri }} style={styles.img} resizeMode="contain" />}
        </View>
        <Text style={styles.name} numberOfLines={2}>{name}</Text>
      </TouchableOpacity>
      <TouchableOpacity onPress={onToggle} style={styles.toggle}>
        <Ionicons
          name={isSelected ? 'checkmark-circle' : 'add-circle'}
          size={30}
          color={isSelected ? colors.primary : colors.white}
        />
      </TouchableOpacity>
    </View>
  );
}

const DISC = 56;
const styles = StyleSheet.create({
  card: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.elevated,
    borderRadius: radius.md,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: colors.hairline,
    padding: spacing.md,
    marginBottom: spacing.md,
  },
  left: { flexDirection: 'row', alignItems: 'center', flex: 1 },
  disc: { width: DISC, height: DISC, borderRadius: DISC / 2, backgroundColor: colors.white, alignItems: 'center', justifyContent: 'center', overflow: 'hidden' },
  img: { width: DISC, height: DISC },
  // Archivo Narrow renders accented names (José, Muñoz); Norwester lacks those glyphs.
  name: { ...typography.textNorwester, fontFamily: fonts.archivo, color: colors.white, marginLeft: spacing.lg, flex: 1 },
  toggle: { paddingLeft: spacing.md },
});
