import type { Player, Post, Team, User } from '@/types';

/**
 * Mapping between Supabase rows (snake_case) and the app's TS types (camelCase). Keeping this in
 * one place lets auth/user/posts stay thin and consistent.
 */

/** A row from public.profiles. follows/favorites are stored as JSONB objects. */
export interface ProfileRow {
  id: string;
  username: string;
  admin: boolean;
  verified: boolean;
  user_tag: string;
  user_biography: string;
  profile_picture: string | null;
  favorite_team: Team | null;
  favorite_player: Player | null;
  following_teams: Team[] | null;
  following_players: Player[] | null;
}

/**
 * Build the app's User from a profile row. `email` comes from auth.users (not the profile), and
 * `likedPostIds` is a client-side cache loaded from post_likes so PostCard's liked-check works.
 */
export const profileToUser = (p: ProfileRow, email: string, likedPostIds: string[]): User => ({
  username: p.username,
  admin: p.admin,
  email,
  favoritePlayer: p.favorite_player ?? null,
  favoriteTeam: p.favorite_team ?? null,
  followingPlayers: p.following_players ?? [],
  followingTeams: p.following_teams ?? [],
  password: '', // never sent by Supabase; kept for type compatibility
  profilePicture: p.profile_picture ?? '',
  userBiography: p.user_biography,
  userLikedPosts: likedPostIds,
  userTag: p.user_tag,
  verified: p.verified,
});

/** A post row with the author profile embedded via PostgREST (`author:profiles(...)`). */
export interface PostRow {
  id: string;
  content: string;
  post_image: string | null;
  created_at: string;
  author: { username: string; profile_picture: string | null } | null;
}

export const rowToPost = (r: PostRow): Post => ({
  postId: r.id,
  author: r.author?.username ?? null,
  authorProfilePicture: r.author?.profile_picture ?? null,
  content: r.content,
  postImage: r.post_image,
  createdAt: r.created_at,
});
