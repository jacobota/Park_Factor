import React, { useState } from 'react';
import { ActivityIndicator, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { useQuery } from '@tanstack/react-query';
import { ArsenalActionCards } from './ArsenalActionCards';
import { MovementScatterCard } from './MovementScatterCard';
import { PitchShapesTable } from './PitchShapesTable';
import { PitchUsageBar } from './PitchUsageBar';
import { getPitcherArsenalFull } from '@/api/stats';
import { colors, fonts, radius, spacing } from '@/theme';

type Scope = 'season' | 'career';

/** Segmented This Season / Career toggle for the infographics window. */
function ScopeToggle({ scope, onChange }: { scope: Scope; onChange: (s: Scope) => void }) {
  return (
    <View style={styles.toggle}>
      {(['season', 'career'] as Scope[]).map((s) => {
        const active = s === scope;
        return (
          <TouchableOpacity
            key={s}
            onPress={() => onChange(s)}
            style={[styles.segment, active && styles.segmentActive]}
          >
            <Text style={[styles.segmentLabel, { color: active ? colors.secondary : colors.lightGray }]}>
              {s === 'season' ? 'THIS SEASON' : 'CAREER'}
            </Text>
          </TouchableOpacity>
        );
      })}
    </View>
  );
}

/**
 * Infographics tab body: per-pitch Action+ arsenal, pitch mix, movement profile, and shape table,
 * all driven by one event-level query whose window flips between the current season and the
 * player's career via the toggle.
 */
export function PitcherInfographics({ mlbamId, firstYear }: { mlbamId: number; firstYear?: number | null }) {
  const [scope, setScope] = useState<Scope>('season');
  const startYear = scope === 'career' ? firstYear ?? undefined : undefined;

  const { data: pitches, isFetching } = useQuery({
    queryKey: ['pitcher-arsenal-full', mlbamId, startYear ?? 0],
    queryFn: () => getPitcherArsenalFull(mlbamId, startYear),
    enabled: !!mlbamId,
    staleTime: 60 * 60 * 1000,
  });

  return (
    <View>
      <ScopeToggle scope={scope} onChange={setScope} />
      {isFetching && !pitches && <ActivityIndicator color={colors.primary} style={styles.loader} />}
      {pitches && pitches.length > 0 ? (
        <>
          <ArsenalActionCards pitches={pitches} />
          <PitchUsageBar pitches={pitches} />
          <MovementScatterCard pitches={pitches} />
          <PitchShapesTable pitches={pitches} />
        </>
      ) : (
        !isFetching && <Text style={styles.empty}>No pitch-level data available.</Text>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  toggle: {
    flexDirection: 'row',
    backgroundColor: colors.elevated,
    borderRadius: radius.md,
    padding: 4,
    marginBottom: spacing.lg,
  },
  segment: { flex: 1, paddingVertical: spacing.sm, alignItems: 'center', borderRadius: radius.sm },
  segmentActive: { backgroundColor: colors.primary },
  segmentLabel: { fontFamily: fonts.norwester, fontSize: 14, letterSpacing: 1 },
  loader: { marginVertical: spacing.xl },
  empty: { fontFamily: fonts.archivo, fontSize: 16, color: colors.gray, textAlign: 'center', marginTop: spacing.xl },
});
