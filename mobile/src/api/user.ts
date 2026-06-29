import { supabase } from './supabaseClient';
import { ApiError } from './client';
import { profileToUser, type ProfileRow } from './profileMap';
import type { Player, Team, User } from '@/types';

/**
 * Profile mutations against public.profiles (RLS restricts each user to their own row). Email and
 * password go through Supabase Auth. Likes live in posts.ts (post_likes join table).
 */

async function currentUserId(): Promise<string> {
  const { data } = await supabase.auth.getUser();
  if (!data.user) throw new ApiError(401, 'Not authenticated');
  return data.user.id;
}

async function updateProfile(patch: Record<string, unknown>): Promise<void> {
  const id = await currentUserId();
  const { error } = await supabase.from('profiles').update(patch).eq('id', id);
  if (error) throw new ApiError(400, error.message);
}

/** Followed players (stored as JSONB Player[]). */
export const updateFollowingPlayers = (followingPlayers: Player[]) =>
  updateProfile({ following_players: followingPlayers });

/** Followed teams (stored as JSONB Team[]). */
export const updateFollowingTeams = (followingTeams: Team[]) =>
  updateProfile({ following_teams: followingTeams });

/** Set (or clear with null) the favorite team. */
export const updateFavoriteTeam = (favoriteTeam: Team | null) =>
  updateProfile({ favorite_team: favoriteTeam });

/** Set (or clear with null) the favorite player. */
export const updateFavoritePlayer = (favoritePlayer: Player | null) =>
  updateProfile({ favorite_player: favoritePlayer });

/** Update the profile bio (≤255 chars). */
export const updateUserBiography = (userBiography: string) =>
  updateProfile({ user_biography: userBiography });

/** Update the @-style user tag. */
export const updateUserTag = (userTag: string) => updateProfile({ user_tag: userTag });

/** Change the account email (via Supabase Auth). */
export async function updateEmail(email: string): Promise<void> {
  const { error } = await supabase.auth.updateUser({ email });
  if (error) throw new ApiError(error.status ?? 400, error.message);
}

/** Change the account password (via Supabase Auth). */
export async function updatePassword(password: string): Promise<void> {
  const { error } = await supabase.auth.updateUser({ password });
  if (error) throw new ApiError(error.status ?? 400, error.message);
}

/** Another user's public profile (email is not exposed for other users). */
export async function getUserProfile(username: string): Promise<User> {
  const { data, error } = await supabase.from('profiles').select('*').eq('username', username).single();
  if (error) throw new ApiError(404, error.message);
  return profileToUser(data as ProfileRow, '', []);
}

/**
 * Delete the signed-in account. Removing the profile cascades the user's posts/likes; full removal
 * of the auth.users row needs the Admin API (TODO: Edge Function) — we sign out here so the session
 * doesn't linger.
 */
export async function deleteAccount(): Promise<void> {
  const id = await currentUserId();
  const { error } = await supabase.from('profiles').delete().eq('id', id);
  if (error) throw new ApiError(400, error.message);
  await supabase.auth.signOut();
}
