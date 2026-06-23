import React, { useState } from 'react';
import { Modal, ScrollView, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { getStatCategory } from '@/data/statCategories';
import { ScreenContainer } from '@/components/ScreenContainer';
import { colors, radius, spacing, typography } from '@/theme';

export interface StatCell {
  /** statcategory.json key — when set, the label is tappable and opens its explanation. */
  catKey?: string;
  label: string;
  value: string;
}

/**
 * Titled black card with a wrapped grid of stat cells. Consolidates the many
 * Hitter/Pitcher Basic/Advanced/Overview/Career card views — tapping a stat label opens
 * the StatExplanation sheet (SwiftUI `.sheet(StatExplanationView)`).
 */
export function StatCard({
  title,
  cells,
  columns = 5,
}: {
  title: string;
  cells: StatCell[];
  columns?: number;
}) {
  const [selected, setSelected] = useState<string | null>(null);
  const basis = `${100 / columns}%`;

  return (
    <View style={styles.card}>
      <Text style={styles.title}>{title}</Text>
      <View style={styles.grid}>
        {cells.map((cell, i) => (
          <View key={`${cell.label}-${i}`} style={[styles.cell, { flexBasis: basis as `${number}%` }]}>
            <TouchableOpacity disabled={!cell.catKey} onPress={() => cell.catKey && setSelected(cell.catKey)}>
              <Text style={styles.label}>{cell.label}</Text>
            </TouchableOpacity>
            <Text style={styles.value}>{cell.value}</Text>
          </View>
        ))}
      </View>

      <StatExplanationModal statKey={selected} onClose={() => setSelected(null)} />
    </View>
  );
}

/** Bottom-sheet style modal explaining a single stat (name / description / importance / formula). */
export function StatExplanationModal({
  statKey,
  onClose,
}: {
  statKey: string | null;
  onClose: () => void;
}) {
  const stat = statKey ? getStatCategory(statKey) : undefined;

  return (
    <Modal visible={!!statKey} animationType="slide" presentationStyle="pageSheet" onRequestClose={onClose}>
      <ScreenContainer scroll background={colors.pageBackground} contentStyle={styles.sheet}>
        <TouchableOpacity onPress={onClose} style={styles.close}>
          <Text style={styles.closeText}>Done</Text>
        </TouchableOpacity>
        {stat ? (
          <>
            <Text style={styles.statName}>{stat.name}</Text>
            <Section heading="Description:" body={stat.description} />
            <Section heading="Importance:" body={stat.why} />
            <Section heading="Formula:" body={stat.formula} />
          </>
        ) : (
          <Text style={styles.statName}>Unable to find Stat</Text>
        )}
      </ScreenContainer>
    </Modal>
  );
}

const Section = ({ heading, body }: { heading: string; body: string }) => (
  <View style={styles.section}>
    <Text style={styles.heading}>{heading}</Text>
    <Text style={styles.body}>{body}</Text>
  </View>
);

const styles = StyleSheet.create({
  card: { backgroundColor: colors.secondary, borderRadius: radius.md, padding: spacing.lg, marginBottom: spacing.sm },
  title: { ...typography.subtitleNorwester, color: colors.white, marginBottom: spacing.md },
  grid: { flexDirection: 'row', flexWrap: 'wrap', rowGap: spacing.md },
  cell: { alignItems: 'center' },
  label: { ...typography.smallText, color: colors.gray, marginBottom: 4 },
  value: { ...typography.smallText, color: colors.white },

  sheet: { padding: spacing.xl },
  close: { alignSelf: 'flex-end', padding: spacing.sm },
  closeText: { ...typography.smallText, color: colors.primary },
  statName: { ...typography.subtitleNorwester, color: colors.white, textAlign: 'center', marginBottom: spacing.xl },
  section: { marginBottom: spacing.xl },
  heading: { ...typography.subtitleNorwester, color: colors.white, marginBottom: spacing.xs },
  body: { ...typography.bigTextArchivo, color: colors.white },
});
