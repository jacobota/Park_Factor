import React from 'react';
import { Image, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { updateFollowingTeams } from '@/api/user';
import { useAuth } from '@/context/AuthContext';
import type { Team } from '@/types';
import { teamByBR } from '@/utils/teams';
import { colors, typography } from '@/theme';

/** Team profile header: logo, mascot, and a follow star toggle. */
export function TeamHeader({ team }: { team: Team }) {
  const { user, setUser } = useAuth();
  const following = user?.followingTeams ?? [];
  const isFollowing = following.some((t) => t.teamIDBR === team.teamIDBR);

  const toggleFollow = async () => {
    if (!user) return;
    const next = isFollowing
      ? following.filter((t) => t.teamIDBR !== team.teamIDBR)
      : [...following, team];
    await setUser({ ...user, followingTeams: next });
    try {
      await updateFollowingTeams(next);
    } catch {
      await setUser({ ...user, followingTeams: following });
    }
  };

  return (
    <View style={styles.row}>
      <View style={styles.logo}>
        <Image
          source={{ uri: `https://cdn.ssref.net/req/202502211/tlogo/br/${team.franchID}.png` }}
          style={styles.logoImg}
          resizeMode="contain"
        />
      </View>
      <Text style={styles.name} numberOfLines={1} adjustsFontSizeToFit>
        {teamByBR(team.teamIDBR)?.mascot ?? team.teamIDBR}
      </Text>
      <TouchableOpacity onPress={toggleFollow} style={styles.star}>
        <Ionicons name={isFollowing ? 'star' : 'star-outline'} size={34} color={isFollowing ? colors.primary : colors.white} />
      </TouchableOpacity>
    </View>
  );
}

const LOGO = 90;
const styles = StyleSheet.create({
  row: { flexDirection: 'row', alignItems: 'center', paddingHorizontal: 20, paddingVertical: 12 },
  logo: { width: LOGO, height: LOGO, borderRadius: LOGO / 2, backgroundColor: colors.white, alignItems: 'center', justifyContent: 'center', overflow: 'hidden' },
  logoImg: { width: LOGO, height: LOGO },
  name: { ...typography.subtitleNorwester, color: colors.white, flex: 1, marginLeft: 16 },
  star: { paddingLeft: 12 },
});
