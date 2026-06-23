import React from 'react';
import { Image, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { updateFollowingPlayers } from '@/api/user';
import { useAuth } from '@/context/AuthContext';
import { playerFullName } from '@/types';
import type { Player } from '@/types';
import { playerHeadshotUrl } from '@/utils/images';
import { mascotByFG, teamColorByFG } from '@/utils/teams';
import { colors, typography } from '@/theme';

/**
 * Player profile header: headshot (team color), name, team, and a follow star toggle.
 * Pass `teamFG` to derive color+name from the FanGraphs abbr, or `teamColor`/`teamName`
 * directly (preview stats key team by city, not abbreviation).
 */
export function PlayerHeader({
  player,
  teamFG,
  teamColor,
  teamName,
}: {
  player: Player;
  teamFG?: string;
  teamColor?: string;
  teamName?: string;
}) {
  const { user, setUser } = useAuth();
  const following = user?.followingPlayers ?? [];
  const isFollowing = following.some((p) => p.keyMlbam === player.keyMlbam);

  const avatarColor = teamColor ?? (teamFG ? teamColorByFG(teamFG) : colors.white);
  const displayTeam = teamName ?? (teamFG ? mascotByFG(teamFG) : undefined);

  const toggleFollow = async () => {
    if (!user) return;
    const next = isFollowing
      ? following.filter((p) => p.keyMlbam !== player.keyMlbam)
      : [...following, player];
    // Optimistic local update, then persist.
    await setUser({ ...user, followingPlayers: next });
    try {
      await updateFollowingPlayers(next);
    } catch {
      await setUser({ ...user, followingPlayers: following }); // revert on failure
    }
  };

  return (
    <View style={styles.row}>
      <View style={[styles.avatar, { backgroundColor: avatarColor }]}>
        <Image source={{ uri: playerHeadshotUrl(player.keyMlbam) }} style={styles.avatarImg} />
      </View>
      <View style={styles.info}>
        <Text style={styles.name} numberOfLines={1} adjustsFontSizeToFit>
          {playerFullName(player)}
        </Text>
        {!!displayTeam && <Text style={styles.team}>{displayTeam}</Text>}
      </View>
      <TouchableOpacity onPress={toggleFollow} style={styles.star}>
        <Ionicons
          name={isFollowing ? 'star' : 'star-outline'}
          size={34}
          color={isFollowing ? colors.primary : colors.white}
        />
      </TouchableOpacity>
    </View>
  );
}

const AVATAR = 90;
const styles = StyleSheet.create({
  row: { flexDirection: 'row', alignItems: 'center', paddingHorizontal: 20, paddingVertical: 12 },
  avatar: { width: AVATAR, height: AVATAR, borderRadius: AVATAR / 2, overflow: 'hidden' },
  avatarImg: { width: AVATAR, height: AVATAR },
  info: { flex: 1, marginLeft: 16 },
  name: { ...typography.subtitleNorwester, color: colors.white },
  team: { ...typography.textNorwester, color: colors.white, marginTop: 4 },
  star: { paddingLeft: 12 },
});
