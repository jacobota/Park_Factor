import { api } from './client';
import type { GameDetails, Team } from '@/types';

/** GET /teams/team-id/:abbr — resolve a Team by Baseball-Reference abbreviation. */
export const getTeamByAbbr = (abbr: string) => api.get<Team[]>(`/teams/team-id/${abbr}`);

/** GET /teams/team-schedule/:abbr — full schedule & results (OAK is requested as ATH). */
export const getTeamSchedule = async (abbr: string): Promise<GameDetails[]> => {
  const requestAbbr = abbr === 'OAK' ? 'ATH' : abbr;
  const r = await api.get<{ schedule_and_results?: GameDetails[] | null }>(`/teams/team-schedule/${requestAbbr}`);
  return r.schedule_and_results ?? [];
};
