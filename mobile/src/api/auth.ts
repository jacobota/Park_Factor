import { supabase } from './supabaseClient';
import { ApiError } from './client';
import { profileToUser, type ProfileRow } from './profileMap';
import type { User, UserLoginResponse, UserRegisterResponse } from '@/types';

/**
 * Auth via Supabase. Login is by EMAIL (Supabase's identifier); username still drives display.
 * The returned shapes ({ user, token } / { message, user }) match what the screens already expect,
 * so LoginScreen / SignupScreen / onboarding keep working with minimal changes.
 */

/** Post ids the user has liked — cached on User so PostCard's liked-check is a local lookup. */
async function fetchLikedPostIds(userId: string): Promise<string[]> {
  const { data } = await supabase.from('post_likes').select('post_id').eq('user_id', userId);
  return (data ?? []).map((r) => r.post_id as string);
}

/** Load the full app User (profile + email + liked post ids). */
async function loadUser(userId: string, email: string): Promise<User> {
  const { data, error } = await supabase.from('profiles').select('*').eq('id', userId).single();
  if (error) throw new ApiError(404, error.message);
  const likedPostIds = await fetchLikedPostIds(userId);
  return profileToUser(data as ProfileRow, email, likedPostIds);
}

/** Sign in with email + password; returns the user and the session access token. */
export async function login(email: string, password: string): Promise<UserLoginResponse> {
  const { data, error } = await supabase.auth.signInWithPassword({ email, password });
  if (error) throw new ApiError(error.status ?? 400, error.message);
  const user = await loadUser(data.user.id, data.user.email ?? email);
  return { user, token: data.session?.access_token ?? '' };
}

/** Create the account; the handle_new_user trigger seeds the profile (username from metadata). */
export async function register(
  username: string,
  email: string,
  password: string,
): Promise<UserRegisterResponse> {
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: { data: { username } },
  });
  if (error) throw new ApiError(error.status ?? 400, error.message);
  if (!data.user) throw new ApiError(400, 'Sign up failed');
  const user = await loadUser(data.user.id, data.user.email ?? email);
  return { message: 'Account created', user };
}

/** Validate the stored session and return the current user (used on app bootstrap). */
export async function fetchProfile(): Promise<User> {
  const { data, error } = await supabase.auth.getUser();
  if (error || !data.user) throw new ApiError(401, error?.message ?? 'Not authenticated');
  return loadUser(data.user.id, data.user.email ?? '');
}
