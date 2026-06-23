import { api } from './client';
import type { Player, Team } from '@/types';

/** PUT /users/update/followingPlayers — persist the user's followed-players list. */
export const updateFollowingPlayers = (followingPlayers: Player[]) =>
  api.put('/users/update/followingPlayers', { auth: true, body: { followingPlayers } });

/** PUT /users/update/followingTeams — persist the user's followed-teams list. */
export const updateFollowingTeams = (followingTeams: Team[]) =>
  api.put('/users/update/followingTeams', { auth: true, body: { followingTeams } });
