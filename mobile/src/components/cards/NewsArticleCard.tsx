import React from 'react';
import { StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import Svg, { Defs, RadialGradient, Rect, Stop } from 'react-native-svg';
import { Avatar } from '@/components/Avatar';
import { Card } from '@/components/Card';
import { Eyebrow } from '@/components/Eyebrow';
import { timeAgo } from '@/types';
import type { NewsArticle } from '@/types';
import { colors, fonts, radius, spacing, typography } from '@/theme';

/** Warm radial glow in the card's top-right corner (the hero card's accent). */
function Glow() {
  return (
    <Svg style={StyleSheet.absoluteFill} pointerEvents="none">
      <Defs>
        <RadialGradient id="newsGlow" cx="82%" cy="6%" r="62%">
          <Stop offset="0" stopColor="#C9A24B" stopOpacity="0.4" />
          <Stop offset="1" stopColor="#C9A24B" stopOpacity="0" />
        </RadialGradient>
      </Defs>
      <Rect x="0" y="0" width="100%" height="100%" fill="url(#newsGlow)" />
    </Svg>
  );
}

/** Featured (top-story) card — glow, eyebrow, large headline, description, source pill. */
export function FeaturedNewsCard({ article, onPress }: { article: NewsArticle; onPress: () => void }) {
  const source = article.source?.name ?? 'Featured';
  return (
    <TouchableOpacity activeOpacity={0.85} onPress={onPress} style={[styles.card, styles.featured]}>
      <Glow />
      <Eyebrow label={source} secondary={timeAgo(article.publishedAt) || undefined} />
      <Text style={styles.featuredTitle}>{article.title}</Text>
      {!!article.description && <Text style={styles.featuredDesc} numberOfLines={2}>{article.description}</Text>}
      {!!article.author && (
        <View style={styles.pill}>
          <Text style={styles.pillLabel}>BY</Text>
          <Text style={styles.pillValue} numberOfLines={1}>{article.author}</Text>
        </View>
      )}
    </TouchableOpacity>
  );
}

/** Compact feed card — meta row (source · time), headline, stat line, and a source chip. */
export function NewsListCard({ article, onPress }: { article: NewsArticle; onPress: () => void }) {
  const source = article.source?.name ?? 'MLB';
  const ago = timeAgo(article.publishedAt);
  return (
    <Card onPress={onPress} style={styles.card}>
      <View style={styles.metaRow}>
        <Text style={styles.source}>{source.toUpperCase()}</Text>
        {!!ago && <Text style={styles.ago}>{ago}</Text>}
      </View>
      <Text style={styles.title}>{article.title}</Text>
      {!!article.description && <Text style={styles.desc} numberOfLines={2}>{article.description}</Text>}
      <View style={styles.chip}>
        <Avatar name={source} size={28} />
        <View style={styles.chipText}>
          <Text style={styles.chipName} numberOfLines={1}>{source}</Text>
          {!!article.author && <Text style={styles.chipSub} numberOfLines={1}>{article.author}</Text>}
        </View>
      </View>
    </Card>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: colors.elevated,
    borderRadius: radius.lg,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: colors.hairline,
    padding: spacing.lg,
    marginBottom: spacing.lg,
    overflow: 'hidden',
  },
  featured: { paddingVertical: spacing.xl },

  featuredTitle: { fontFamily: fonts.norwester, fontSize: 30, color: colors.white, marginTop: spacing.md, lineHeight: 32 },
  featuredDesc: { ...typography.smallText, color: colors.lightGray, marginTop: spacing.sm },
  pill: {
    flexDirection: 'row',
    alignItems: 'center',
    alignSelf: 'flex-start',
    borderWidth: 1,
    borderColor: colors.good,
    borderRadius: radius.sm,
    paddingVertical: 6,
    paddingHorizontal: 10,
    marginTop: spacing.lg,
  },
  pillLabel: { fontFamily: fonts.norwester, fontSize: 11, letterSpacing: 1, color: colors.gray, marginRight: 8 },
  pillValue: { fontFamily: fonts.norwester, fontSize: 14, color: colors.good, maxWidth: 220 },

  metaRow: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', marginBottom: spacing.sm },
  source: { fontFamily: fonts.norwester, fontSize: 12, letterSpacing: 1.2, color: colors.good },
  ago: { fontFamily: fonts.archivo, fontSize: 13, color: colors.gray },
  title: { fontFamily: fonts.norwester, fontSize: 20, color: colors.white, lineHeight: 23 },
  desc: { ...typography.smallText, color: colors.lightGray, marginTop: spacing.xs },
  chip: { flexDirection: 'row', alignItems: 'center', marginTop: spacing.md },
  chipText: { marginLeft: spacing.sm, flex: 1 },
  chipName: { fontFamily: fonts.norwester, fontSize: 15, color: colors.white },
  chipSub: { fontFamily: fonts.archivo, fontSize: 12, color: colors.gray, marginTop: 1, letterSpacing: 0.3 },
});
