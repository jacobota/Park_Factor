import React from 'react';
import { ActivityIndicator, StyleSheet, Text, View } from 'react-native';
import { useQuery } from '@tanstack/react-query';
import { PlayerLeaderboardRow, TeamLeaderboardRow } from './LeaderboardRow';
import { Card } from '@/components/Card';
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

        // Bar fill = the value's quality within this board (floored so leaders still read full).
        const values = entries.map((e) => e.value);
        const max = Math.max(...values);
        const min = Math.min(...values);
        const fillFor = (v: number) => {
          if (max === min) return 1;
          const norm = (v - min) / (max - min);
          const quality = stat.lowerIsBetter ? 1 - norm : norm;
          return 0.5 + 0.5 * quality;
        };

        return (
          <Card key={stat.key} style={styles.card}>
            <Text style={styles.title}>{stat.title}</Text>
            {!!stat.description && (
              // Show only the plain stat name — drop any " — qualifier" clause.
              <Text style={styles.description}>{stat.description.split(/\s[—-]\s/)[0]}</Text>
            )}
            <View style={styles.rows}>
              {entries.map((entry, index) =>
                variant === 'player' ? (
                  <PlayerLeaderboardRow
                    key={index}
                    index={index}
                    entry={entry}
                    decimals={stat.decimals}
                    fill={fillFor(entry.value)}
                    isPitching={isPitching}
                  />
                ) : (
                  <TeamLeaderboardRow
                    key={index}
                    index={index}
                    entry={entry}
                    decimals={stat.decimals}
                    fill={fillFor(entry.value)}
                  />
                ),
              )}
            </View>
          </Card>
        );
      })}
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: colors.elevated,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: colors.hairline,
    borderRadius: radius.lg,
    padding: spacing.lg,
    marginHorizontal: spacing.lg,
    marginVertical: spacing.sm,
  },
  title: { ...typography.textNorwester, color: colors.white, fontSize: 18, letterSpacing: 0.3 },
  description: { ...typography.smallTextNorwester, color: colors.gray, fontSize: 11, letterSpacing: 0.5, marginTop: 1 },
  rows: { marginTop: spacing.sm },
  state: { marginTop: 40 },
  error: { ...typography.text, color: colors.bad, textAlign: 'center', marginTop: 40 },
});
