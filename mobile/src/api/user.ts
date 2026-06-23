import { api } from './client';
import type { Player, Team, User } from '@/types';

/** PUT /users/update/followingPlayers — persist the user's followed-players list. */
export const updateFollowingPlayers = (followingPlayers: Player[]) =>
  api.put('/users/update/followingPlayers', { auth: true, body: { followingPlayers } });

/** PUT /users/update/followingTeams — persist the user's followed-teams list. */
export const updateFollowingTeams = (followingTeams: Team[]) =>
  api.put('/users/update/followingTeams', { auth: true, body: { followingTeams } });

/** PUT /users/update/favoriteTeam — set (or clear, with null) the favorite team. */
export const updateFavoriteTeam = (favoriteTeam: Team | null) =>
  api.put('/users/update/favoriteTeam', { auth: true, body: { favoriteTeam } });

/** PUT /users/update/favoritePlayer — set (or clear, with null) the favorite player. */
export const updateFavoritePlayer = (favoritePlayer: Player | null) =>
  api.put('/users/update/favoritePlayer', { auth: true, body: { favoritePlayer } });

/** PUT /users/update/userBiography — update the profile bio (≤255 chars). */
export const updateUserBiography = (userBiography: string) =>
  api.put('/users/update/userBiography', { auth: true, body: { userBiography } });

/** PUT /users/update/userTag — update the @-style user tag. */
export const updateUserTag = (userTag: string) =>
  api.put('/users/update/userTag', { auth: true, body: { userTag } });

/** PUT /users/update/email — change the account email. */
export const updateEmail = (email: string) =>
  api.put('/users/update/email', { auth: true, body: { email } });

/** PUT /users/update/password — change the account password. */
export const updatePassword = (password: string) =>
  api.put('/users/update/password', { auth: true, body: { password } });

/** PUT /users/update/userLikedPosts — persist the user's liked-post id list. */
export const updateLikedPosts = (likedPosts: string[]) =>
  api.put('/users/update/userLikedPosts', { auth: true, body: { likedPosts } });

/** GET /users/profile/:username — another user's public profile. */
export const getUserProfile = (username: string) =>
  api.get<User>(`/users/profile/${username}`, { auth: true });

/** DELETE /users/delete — permanently delete the signed-in account. */
export const deleteAccount = () => api.delete('/users/delete', { auth: true });
