import React from 'react';
import { useQuery } from '@tanstack/react-query';
import { StatCard } from './StatCard';
import { getPlayerBio } from '@/api/players';
import type { Player } from '@/types';

/** Player Bio card — B/T, Origin, Position, Height, Weight, Born (PlayerOverviewCardView). */
export function PlayerBioCard({ player }: { player: Player }) {
  const { data: bio } = useQuery({
    queryKey: ['player-bio', player.keyBbref],
    queryFn: () => getPlayerBio(player.keyBbref ?? ''),
    enabled: !!player.keyBbref,
  });

  if (!bio) return null;
  const na = (v?: string | null) => v ?? 'N/A';

  return (
    <StatCard
      title="Player Bio"
      columns={3}
      cells={[
        { label: 'B / T', value: `${na(bio.battingSide)} / ${na(bio.throwingSide)}` },
        { label: 'Origin', value: na(bio.origin) },
        { label: 'Position', value: na(bio.position) },
        { label: 'Height', value: na(bio.height) },
        { label: 'Weight', value: na(bio.weight) },
        { label: 'Born', value: na(bio.born) },
      ]}
    />
  );
}
