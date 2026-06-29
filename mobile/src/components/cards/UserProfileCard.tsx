import React from 'react';
import { Image, StyleSheet, Text, View } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { Avatar } from '@/components/Avatar';
import { Card } from '@/components/Card';
import { playerHeadshotUrl } from '@/utils/images';
import { playerFullName } from '@/types';
import type { User } from '@/types';
import { colors, fonts, radius, spacing, typography } from '@/theme';

/**
 * Account overview block (AccountPageView / AccountFromPostView header): avatar, username +
 * verified badge, user tag, and favorite team / player tiles.
 */
export function UserProfileCard({ user }: { user: User }) {
  const team = user.favoriteTeam;
  const player = user.favoritePlayer;

  return (
    <Card style={styles.card}>
      <View style={styles.headerRow}>
        <Avatar uri={user.profilePicture} name={user.username} size={75} />
        <View style={styles.identity}>
          <View style={styles.usernameRow}>
            <Text style={styles.username} numberOfLines={1}>{user.username}</Text>
            {user.verified && <Ionicons name="ribbon" size={18} color={colors.primary} style={styles.badge} />}
          </View>
          {!!user.userTag && <Text style={styles.tag}>{user.userTag}</Text>}
        </View>
      </View>

      <View style={styles.divider} />

      <View style={styles.favorites}>
        <Favorite label="Favorite Team">
          <View style={styles.disc}>
            {team ? (
              <Image
                source={{ uri: `https://cdn.ssref.net/req/202502211/tlogo/br/${team.franchID}.png` }}
                style={styles.discImg}
                resizeMode="contain"
              />
            ) : (
              <Ionicons name="baseball" size={28} color={colors.gray} />
            )}
          </View>
          <Text style={styles.favName}>{team?.teamIDBR ?? 'N/A'}</Text>
        </Favorite>

        <Favorite label="Favorite Player">
          <Avatar uri={player ? playerHeadshotUrl(player.keyMlbam) : undefined} name={player ? playerFullName(player) : ''} size={50} />
          <Text style={styles.favName}>{player ? playerFullName(player) : 'N/A'}</Text>
        </Favorite>
      </View>
    </Card>
  );
}

const Favorite = ({ label, children }: { label: string; children: React.ReactNode }) => (
  <View style={styles.favorite}>
    <Text style={styles.favLabel}>{label}</Text>
    {children}
  </View>
);

const DISC = 50;
const styles = StyleSheet.create({
  card: { backgroundColor: colors.elevated, borderWidth: StyleSheet.hairlineWidth, borderColor: colors.hairline, borderRadius: radius.lg, padding: spacing.lg, marginBottom: spacing.lg },
  headerRow: { flexDirection: 'row', alignItems: 'center' },
  identity: { marginLeft: spacing.lg, flex: 1 },
  usernameRow: { flexDirection: 'row', alignItems: 'center' },
  // Archivo Narrow renders accented names/usernames; Norwester lacks those glyphs.
  username: { ...typography.usernameNorwester, fontFamily: fonts.archivo, color: colors.white, flexShrink: 1 },
  badge: { marginLeft: 6 },
  tag: { ...typography.smallTextNorwester, fontFamily: fonts.archivo, color: colors.white, opacity: 0.5, marginTop: spacing.xs },
  divider: { height: StyleSheet.hairlineWidth, backgroundColor: colors.border, marginVertical: spacing.md },
  favorites: { flexDirection: 'row', justifyContent: 'space-around' },
  favorite: { alignItems: 'center' },
  favLabel: { ...typography.smallTextNorwester, color: colors.white, opacity: 0.5, marginBottom: spacing.sm },
  disc: { width: DISC, height: DISC, borderRadius: DISC / 2, backgroundColor: colors.white, alignItems: 'center', justifyContent: 'center', overflow: 'hidden' },
  discImg: { width: DISC, height: DISC },
  favName: { ...typography.smallTextNorwester, fontFamily: fonts.archivo, color: colors.white, opacity: 0.8, marginTop: spacing.sm },
});
