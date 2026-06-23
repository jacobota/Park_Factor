import React from 'react';
import { ActivityIndicator, StyleSheet, Text, View } from 'react-native';
import { useQuery } from '@tanstack/react-query';
import { PlayerLeaderboardRow, TeamLeaderboardRow } from './LeaderboardRow';
import type { LeaderboardStat } from '@/screens/stats/leaderboardConfig';
import { colors, radius, spacing, typography } from '@/theme';
import type { Leaderboard } from '@/types';

/**
 * Renders a full leaderboard: one titled card per configured stat that exists in the data.
 * Replaces PlayerHitting/Pitching + TeamHitting/Pitching leaderboard views (one component,
 * config-driven, variant chooses the row type).
 */
export function LeaderboardList({
  queryKey,
  queryFn,
  config,
  variant,
  isPitching = false,
}: {
  queryKey: string[];
  queryFn: () => Promise<Leaderboard>;
  config: LeaderboardStat[];
  variant: 'player' | 'team';
  isPitching?: boolean;
}) {
  const { data, isLoading, isError, error } = useQuery({ queryKey, queryFn });

  if (isLoading) return <ActivityIndicator color={colors.primary} style={styles.state} />;
  if (isError || !data) {
    const message = error instanceof Error ? error.message : "Couldn't load leaderboards.";
    return <Text style={styles.error}>{message}</Text>;
  }

  return (
    <View>
      {config.map((stat) => {
        const entries = data[stat.key];
        if (!entries || entries.length === 0) return null;
        return (
          <View key={stat.key} style={styles.card}>
            <Text style={styles.title}>{stat.title}</Text>
            {entries.map((entry, index) =>
              variant === 'player' ? (
                <PlayerLeaderboardRow
                  key={index}
                  index={index}
                  entry={entry}
                  decimals={stat.decimals}
                  isPitching={isPitching}
                />
              ) : (
                <TeamLeaderboardRow key={index} index={index} entry={entry} decimals={stat.decimals} />
              ),
            )}
          </View>
        );
      })}
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: colors.secondary,
    borderRadius: radius.lg,
    padding: spacing.lg,
    marginHorizontal: spacing.lg,
    marginVertical: spacing.sm,
  },
  title: { ...typography.subtitleNorwester, color: colors.primary, marginBottom: spacing.sm },
  state: { marginTop: 40 },
  error: { ...typography.text, color: colors.bad, textAlign: 'center', marginTop: 40 },
});
