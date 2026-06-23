import React from 'react';
import { Image, StyleSheet, Text, View } from 'react-native';
import type { GameDetails } from '@/types';
import { Card } from '@/components/Card';
import { mascotByFG, teamLogoUrlByFG } from '@/utils/teams';
import { colors, radius, spacing, typography } from '@/theme';

/**
 * TeamGameDetailsCardView — one matchup. `tm`/`opp` are normalized so the home team always
 * sits on the right; scores and decisions (W/L/SV) only render once a game has been played.
 */
export function TeamGameCard({ game, label }: { game?: GameDetails | null; label?: string }) {
  if (!game) {
    return (
      <Card style={styles.card}>
        <Text style={styles.empty}>No Game Scheduled</Text>
      </Card>
    );
  }

  const isHome = game.Home_Away === 'Home';
  // Home: opponent on the left, our team on the right; away flips it.
  const left = isHome ? game.Opp : game.Tm;
  const right = isHome ? game.Tm : game.Opp;
  const leftScore = isHome ? game.RA : game.R;
  const rightScore = isHome ? game.R : game.RA;
  const played = game.R != null;

  return (
    <Card style={styles.card}>
      <Text style={styles.heading}>{label ?? game.Date ?? 'N/A'}</Text>

      <View style={styles.matchup}>
        <Side abbr={left} score={played ? leftScore : undefined} />
        <Text style={styles.vs}>vs</Text>
        <Side abbr={right} score={played ? rightScore : undefined} />
      </View>

      {played && (
        <View style={styles.decisions}>
          <Text style={styles.decision} numberOfLines={1}>W: {game.Win ?? 'N/A'}</Text>
          <Text style={styles.decision} numberOfLines={1}>L: {game.Loss ?? 'N/A'}</Text>
          <Text style={styles.decision} numberOfLines={1}>SV: {game.Save ?? 'N/A'}</Text>
        </View>
      )}
    </Card>
  );
}

const Side = ({ abbr, score }: { abbr?: string | null; score?: number | null }) => {
  const uri = teamLogoUrlByFG(abbr);
  return (
    <View style={styles.side}>
      <Text style={styles.mascot} numberOfLines={1} adjustsFontSizeToFit>{mascotByFG(abbr)}</Text>
      <View style={styles.logo}>
        {uri && <Image source={{ uri }} style={styles.logoImg} resizeMode="contain" />}
      </View>
      {score != null && <Text style={styles.score}>{score}</Text>}
    </View>
  );
};

const LOGO = 72;
const styles = StyleSheet.create({
  card: { backgroundColor: colors.elevated, borderWidth: StyleSheet.hairlineWidth, borderColor: colors.hairline, borderRadius: radius.md, padding: spacing.lg, marginBottom: spacing.lg },
  empty: { ...typography.subtitleNorwester, color: colors.white, textAlign: 'center', paddingVertical: spacing.lg },
  heading: { ...typography.subtitleNorwester, color: colors.white, textAlign: 'center', marginBottom: spacing.md },
  matchup: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' },
  side: { flex: 1, alignItems: 'center' },
  mascot: { ...typography.smallText, color: colors.white, marginBottom: spacing.sm },
  logo: { width: LOGO, height: LOGO, borderRadius: LOGO / 2, backgroundColor: colors.white, alignItems: 'center', justifyContent: 'center', overflow: 'hidden' },
  logoImg: { width: LOGO, height: LOGO },
  score: { ...typography.subtitleNorwester, color: colors.white, marginTop: spacing.sm },
  vs: { ...typography.smallText, color: colors.gray, marginHorizontal: spacing.sm },
  decisions: { marginTop: spacing.lg },
  decision: { ...typography.smallText, color: colors.white, textAlign: 'center', marginBottom: 2 },
});
