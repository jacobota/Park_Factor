import { api } from './client';
import type { HittingCareerStats, PitchingCareerStats, PlayerBio } from '@/types';

interface PlayerBioRaw {
  Bats?: string | null;
  Born?: string | null;
  Height?: string | null;
  Origin?: string | null;
  Position?: string | null;
  Throws?: string | null;
  Weight?: string | null;
}

/** GET /players/player-bio/:bbrefId — biographical info. */
export const getPlayerBio = async (bbrefId: string): Promise<PlayerBio | null> => {
  const r = await api.get<{ player_bio?: PlayerBioRaw | null }>(`/players/player-bio/${bbrefId}`);
  const b = r.player_bio;
  if (!b) return null;
  return {
    battingSide: b.Bats,
    born: b.Born,
    height: b.Height,
    origin: b.Origin,
    position: b.Position,
    throwingSide: b.Throws,
    weight: b.Weight,
  };
};

/** GET /hitters/stats/career/:fgId/:firstYear/:lastYear — per-season career rows. */
export const getHitterCareer = async (
  fgId: number,
  firstYear: number,
  lastYear: number,
): Promise<HittingCareerStats[]> =>
  (await api.get<{ hitting_career_stats?: HittingCareerStats[] | null }>(
    `/hitters/stats/career/${fgId}/${firstYear}/${lastYear}`,
  )).hitting_career_stats ?? [];

/** GET /pitchers/stats/career/:fgId/:firstYear/:lastYear — per-season career rows. */
export const getPitcherCareer = async (
  fgId: number,
  firstYear: number,
  lastYear: number,
): Promise<PitchingCareerStats[]> =>
  (await api.get<{ pitching_career_stats?: PitchingCareerStats[] | null }>(
    `/pitchers/stats/career/${fgId}/${firstYear}/${lastYear}`,
  )).pitching_career_stats ?? [];
