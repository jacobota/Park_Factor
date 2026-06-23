import React, { useState } from 'react';
import { ActivityIndicator, FlatList, Modal, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useQuery } from '@tanstack/react-query';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { getNews, NEWS_FILTER_TEAMS } from '@/api/news';
import { FeaturedNewsCard, NewsListCard } from '@/components/cards/NewsArticleCard';
import { SectionLabel } from '@/components/SectionLabel';
import type { NewsArticle } from '@/types';
import { colors, radius, spacing, typography } from '@/theme';
import type { NewsStackParamList } from '@/navigation/types';

type Nav = NativeStackNavigationProp<NewsStackParamList, 'NewsHome'>;

/** LeagueNewsView — a featured top story over a "LATEST" feed, with an optional team filter. */
export function LeagueNewsSection({ navigation }: { navigation: Nav }) {
  const [filter, setFilter] = useState('All');
  const [pickerOpen, setPickerOpen] = useState(false);

  const { data, isLoading, isError } = useQuery({
    queryKey: ['news', filter],
    queryFn: () => getNews(filter),
  });

  const open = (article: NewsArticle) => navigation.navigate('ArticleDetail', { article });
  const articles = data ?? [];
  const featured = articles[0];
  const rest = articles.slice(1);

  const filterControl = (
    <TouchableOpacity style={styles.filterBtn} onPress={() => setPickerOpen(true)}>
      <Ionicons name="filter" size={15} color={colors.primary} />
      <Text style={styles.filterText}>{filter === 'All' ? 'Filter' : filter}</Text>
    </TouchableOpacity>
  );

  return (
    <View style={styles.container}>
      <FlatList<NewsArticle>
        style={styles.fill}
        data={rest}
        keyExtractor={(a, i) => `${a.url ?? a.title}-${i}`}
        contentContainerStyle={styles.content}
        ListHeaderComponent={
          featured ? (
            <>
              <FeaturedNewsCard article={featured} onPress={() => open(featured)} />
              <SectionLabel label="Latest" right={filterControl} />
            </>
          ) : null
        }
        renderItem={({ item }) => <NewsListCard article={item} onPress={() => open(item)} />}
        ListEmptyComponent={
          isLoading ? (
            <ActivityIndicator color={colors.primary} style={styles.empty} />
          ) : (
            <Text style={styles.message}>{isError ? 'News unavailable' : 'No articles found'}</Text>
          )
        }
      />

      <TeamFilterModal
        visible={pickerOpen}
        selected={filter}
        onSelect={(team) => {
          setFilter((cur) => (cur === team ? 'All' : team));
          setPickerOpen(false);
        }}
        onClose={() => setPickerOpen(false)}
      />
    </View>
  );
}

/** FilterNewsView — team list as a bottom sheet; tapping the active team clears the filter. */
function TeamFilterModal({
  visible,
  selected,
  onSelect,
  onClose,
}: {
  visible: boolean;
  selected: string;
  onSelect: (team: string) => void;
  onClose: () => void;
}) {
  return (
    <Modal visible={visible} animationType="slide" presentationStyle="pageSheet" onRequestClose={onClose}>
      <View style={styles.sheet}>
        <View style={styles.sheetHeader}>
          <Text style={styles.sheetTitle}>Filter by Team</Text>
          <TouchableOpacity onPress={onClose}>
            <Text style={styles.done}>Done</Text>
          </TouchableOpacity>
        </View>
        <FlatList
          data={['All', ...NEWS_FILTER_TEAMS]}
          keyExtractor={(t) => t}
          contentContainerStyle={styles.sheetList}
          renderItem={({ item }) => {
            const active = selected === item || (item === 'All' && selected === 'All');
            return (
              <TouchableOpacity
                onPress={() => onSelect(item)}
                style={[styles.chip, { backgroundColor: active ? colors.primary : colors.secondary }]}
              >
                <Text style={[styles.chipText, { color: active ? colors.secondary : colors.primary }]}>{item}</Text>
              </TouchableOpacity>
            );
          }}
        />
      </View>
    </Modal>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.secondary },
  fill: { flex: 1 },
  content: { padding: spacing.lg, flexGrow: 1 },
  filterBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: colors.border,
    borderRadius: radius.sm,
    paddingVertical: 4,
    paddingHorizontal: 10,
  },
  filterText: { ...typography.smallTextNorwester, fontSize: 13, color: colors.primary, marginLeft: 5 },
  empty: { marginTop: spacing.xl },
  message: { ...typography.smallText, color: colors.lightGray, textAlign: 'center', marginTop: spacing.xl },

  sheet: { flex: 1, backgroundColor: colors.pageBackground },
  sheetHeader: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', padding: spacing.lg },
  sheetTitle: { ...typography.subtitleNorwester, color: colors.primary },
  done: { ...typography.text, color: colors.primary },
  sheetList: { paddingHorizontal: spacing.lg, paddingBottom: spacing.xl },
  chip: {
    borderWidth: 3,
    borderColor: colors.primary,
    borderRadius: 30,
    paddingVertical: spacing.md,
    alignItems: 'center',
    marginBottom: spacing.md,
  },
  chipText: { ...typography.bigTextNorwester },
});
