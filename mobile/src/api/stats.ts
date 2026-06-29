import { api } from './client';
import { leaderboardError, mapPlayer, normalizeLeaderboard } from '@/types';
import type {
  ArsenalPitch,
  HitterPercentile,
  HitterPreviewStats,
  HitterStats,
  Leaderboard,
  PitcherPercentile,
  PitchingPreviewStats,
  PitchingStats,
  PitchType,
  Player,
  PlayerPeople,
  PlayerRaw,
  RawLeaderboard,
  Team,
  TeamStats,
} from '@/types';

/** Leaderboard envelopes returned by the Node backend. */
interface HitterLeaderboardResponse { playerHittingLeaderboard?: RawLeaderboard | null }
interface PitcherLeaderboardResponse { playerPitchingLeaderboard?: RawLeaderboard | null }
interface TeamHittingLeaderboardResponse { teamHittingLeaderboard?: RawLeaderboard | null }
interface TeamPitchingLeaderboardResponse { teamPitchingLeaderboard?: RawLeaderboard | null }

/** Normalize an envelope, surfacing the backend's upstream error (e.g. FanGraphs 403) if present. */
const toLeaderboard = (inner: RawLeaderboard | null | undefined): Leaderboard => {
  const err = leaderboardError(inner);
  if (err) throw new Error(err);
  return normalizeLeaderboard(inner);
};

export const getHitterLeaderboard = async (): Promise<Leaderboard> =>
  toLeaderboard((await api.get<HitterLeaderboardResponse>('/hitters/stats/leaderboard')).playerHittingLeaderboard);

export const getPitcherLeaderboard = async (): Promise<Leaderboard> =>
  toLeaderboard((await api.get<PitcherLeaderboardResponse>('/pitchers/stats/leaderboard')).playerPitchingLeaderboard);

export const getTeamHittingLeaderboard = async (): Promise<Leaderboard> =>
  toLeaderboard((await api.get<TeamHittingLeaderboardResponse>('/teamStats/leaderboard/hitting')).teamHittingLeaderboard);

export const getTeamPitchingLeaderboard = async (): Promise<Leaderboard> =>
  toLeaderboard((await api.get<TeamPitchingLeaderboardResponse>('/teamStats/leaderboard/pitching')).teamPitchingLeaderboard);

/** GET /players/player-id/:first/:last — returns matching player records. */
export const lookupPlayerByName = async (first: string, last: string): Promise<Player[]> => {
  const raw = await api.get<PlayerRaw[]>(`/players/player-id/${first}/${last}`);
  return (raw ?? []).map(mapPlayer);
};

/** GET /players/mlb-players — full active-player list (for lookup search). */
export const getAllPlayers = async (): Promise<Player[]> => {
  const raw = await api.get<PlayerRaw[]>('/players/mlb-players');
  return (raw ?? []).map(mapPlayer);
};

/** GET /teams/mlb-teams — full team list. */
export const getAllTeams = () => api.get<Team[]>('/teams/mlb-teams');

/** Season stat bags for a single player (null when the player isn't of that type / unavailable). */
export const getHitterSeasonStats = async (fgId: number, mlbamId: number): Promise<HitterStats | null> =>
  (await api.get<{ hitter_stats?: HitterStats | null }>(`/hitters/stats/current-season/${fgId}/${mlbamId}`))
    .hitter_stats ?? null;

export const getPitcherSeasonStats = async (fgId: number, mlbamId: number): Promise<PitchingStats | null> =>
  (await api.get<{ pitcher_stats?: PitchingStats[] | null }>(`/pitchers/stats/current-season/${fgId}/${mlbamId}`))
    .pitcher_stats?.[0] ?? null;

/** Preview (minor/rookie) stats for players without FanGraphs season data. */
export const getHitterPreviewStats = async (mlbamId: number): Promise<HitterPreviewStats[] | null> =>
  (await api.get<{ hitter_preview_stats?: HitterPreviewStats[] | null }>(
    `/hitters/stats/current-season-preview/${mlbamId}`,
  )).hitter_preview_stats ?? null;

export const getPitcherPreviewStats = async (mlbamId: number): Promise<PitchingPreviewStats[] | null> =>
  (await api.get<{ pitcher_preview_stats?: PitchingPreviewStats[] | null }>(
    `/pitchers/stats/current-season-preview/${mlbamId}`,
  )).pitcher_preview_stats ?? null;

/** Statcast percentile bags (0-100) for the radar + percentile bars. */
export const getHitterPercentiles = async (mlbamId: number): Promise<HitterPercentile | null> =>
  (await api.get<{ hitter_percentile?: HitterPercentile[] | null }>(`/hitters/stats/percentiles/${mlbamId}`))
    .hitter_percentile?.[0] ?? null;

export const getPitcherPercentiles = async (mlbamId: number): Promise<PitcherPercentile | null> =>
  (await api.get<{ pitcher_percentile?: PitcherPercentile[] | null }>(`/pitchers/stats/percentiles/${mlbamId}`))
    .pitcher_percentile?.[0] ?? null;

/** GET /pitchers/stats/pitcher-arsenal/:mlbamId — per-pitch movement + usage. */
export const getPitcherArsenal = async (mlbamId: number): Promise<PitchType[]> =>
  (await api.get<{ pitcher_arsenal?: PitchType[] | null }>(`/pitchers/stats/pitcher-arsenal/${mlbamId}`))
    .pitcher_arsenal ?? [];

/**
 * GET /pitchers/stats/arsenal-full/:mlbamId — event-level per-pitch velo/break/spin + Action+.
 * Pass `startYear` to widen the window from the current season back to a career span.
 */
export const getPitcherArsenalFull = async (mlbamId: number, startYear?: number): Promise<ArsenalPitch[]> => {
  const q = startYear ? `?start-year=${startYear}` : '';
  return (
    await api.get<{ pitcher_arsenal_full?: ArsenalPitch[] | null }>(`/pitchers/stats/arsenal-full/${mlbamId}${q}`)
  ).pitcher_arsenal_full ?? [];
};

/** GET /players/people/:mlbamId — header bio (number, B/T, height, weight, born, age). */
export const getPlayerPeople = async (mlbamId: number): Promise<PlayerPeople | null> =>
  (await api.get<{ player_people?: PlayerPeople | null }>(`/players/people/${mlbamId}`)).player_people ?? null;

/** GET /teamStats/current-season/:teamIDfg — team batting/pitching/fielding aggregates. */
export const getTeamSeasonStats = async (teamIDfg: number): Promise<TeamStats> => {
  const r = await api.get<{
    team_batting?: TeamStats['teamBatting'];
    team_pitching?: TeamStats['teamPitching'];
    team_fielding?: TeamStats['teamFielding'];
  }>(`/teamStats/current-season/${teamIDfg}`);
  return { teamBatting: r.team_batting, teamPitching: r.team_pitching, teamFielding: r.team_fielding };
};
