import React from 'react';
import { Image, Linking, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import { ScreenContainer } from '@/components/ScreenContainer';
import { cleanedContent, formatLongDate } from '@/types';
import { colors, spacing, typography } from '@/theme';
import type { NewsStackParamList } from '@/navigation/types';

/** NewsArticleDetailedPageView — full article with source metadata and a "Read more" link. */
export function ArticleDetailScreen({ route }: NativeStackScreenProps<NewsStackParamList, 'ArticleDetail'>) {
  const { article } = route.params;
  const date = formatLongDate(article.publishedAt);

  return (
    <ScreenContainer scroll background={colors.secondary} contentStyle={styles.content}>
      {!!article.urlToImage && <Image source={{ uri: article.urlToImage }} style={styles.image} resizeMode="cover" />}
      <Text style={styles.title}>{article.title}</Text>

      <View style={styles.meta}>
        {!!article.source?.name && <Text style={styles.metaText}>{article.source.name}</Text>}
        <Text style={styles.metaText}>By {article.author ?? 'Anonymous'}</Text>
        {!!date && <Text style={styles.metaText}>{date}</Text>}
      </View>

      <Text style={styles.body}>{cleanedContent(article.content ?? '')}</Text>

      {!!article.url && (
        <TouchableOpacity style={styles.readMore} onPress={() => Linking.openURL(article.url!)}>
          <Text style={styles.readMoreLabel}>Read more: </Text>
          <Text style={styles.link} numberOfLines={1}>{article.url}</Text>
        </TouchableOpacity>
      )}
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  content: { padding: spacing.lg },
  image: { width: '100%', height: 240, borderRadius: 10 },
  title: { ...typography.subtitleNorwester, color: colors.primary, textAlign: 'center', marginTop: spacing.md },
  meta: { marginTop: spacing.md },
  metaText: { ...typography.smallText, color: colors.gray, marginTop: 2 },
  body: { ...typography.text, color: colors.white, marginTop: spacing.lg },
  readMore: { flexDirection: 'row', marginTop: spacing.lg },
  readMoreLabel: { ...typography.smallText, color: colors.white },
  link: { ...typography.smallText, color: colors.primary, flexShrink: 1 },
});
