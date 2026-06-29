import { supabase } from './supabaseClient';
import { ApiError } from './client';
import { rowToPost, type PostRow } from './profileMap';
import type { Post } from '@/types';

/** Body for creating/updating a post. authorProfilePicture is ignored (author is embedded). */
export interface PostInput {
  content: string;
  authorProfilePicture?: string;
  postImage?: string;
}

// Embed the author's live username + avatar so the feed is always current (no denormalized copy).
// Hint the FK explicitly (posts_author_id_fkey): post_likes adds a second posts↔profiles path, so
// an unqualified `profiles` embed is ambiguous.
const POST_SELECT =
  'id, content, post_image, created_at, author:profiles!posts_author_id_fkey(username, profile_picture)';

/** GET feed — every post, newest first. */
export async function getAllPosts(): Promise<Post[]> {
  const { data, error } = await supabase
    .from('posts')
    .select(POST_SELECT)
    .order('created_at', { ascending: false });
  if (error) throw new ApiError(400, error.message);
  return (data as unknown as PostRow[]).map(rowToPost);
}

/** GET a single post (used to hydrate the user's liked posts). */
export async function getPostById(postId: string): Promise<Post> {
  const { data, error } = await supabase.from('posts').select(POST_SELECT).eq('id', postId).single();
  if (error) throw new ApiError(404, error.message);
  return rowToPost(data as unknown as PostRow);
}

/** GET all posts by one author. Resolve username → id first, then filter by author_id. */
export async function getPostsByAuthor(username: string): Promise<Post[]> {
  const { data: prof, error: pe } = await supabase
    .from('profiles')
    .select('id')
    .eq('username', username)
    .single();
  if (pe) throw new ApiError(404, pe.message);
  const { data, error } = await supabase
    .from('posts')
    .select(POST_SELECT)
    .eq('author_id', prof.id)
    .order('created_at', { ascending: false });
  if (error) throw new ApiError(400, error.message);
  return (data as unknown as PostRow[]).map(rowToPost);
}

/** Create a post (verified users only — enforced by RLS). author_id defaults to the caller. */
export async function createPost(body: PostInput): Promise<Post> {
  const { data, error } = await supabase
    .from('posts')
    .insert({ content: body.content, post_image: body.postImage || null })
    .select(POST_SELECT)
    .single();
  if (error) throw new ApiError(400, error.message);
  return rowToPost(data as unknown as PostRow);
}

/** Edit own post content/image. */
export async function updatePost(postId: string, body: PostInput): Promise<Post> {
  const { data, error } = await supabase
    .from('posts')
    .update({ content: body.content, post_image: body.postImage || null })
    .eq('id', postId)
    .select(POST_SELECT)
    .single();
  if (error) throw new ApiError(400, error.message);
  return rowToPost(data as unknown as PostRow);
}

/** Delete own post (or any post if admin — enforced by RLS). */
export async function deletePost(postId: string): Promise<void> {
  const { error } = await supabase.from('posts').delete().eq('id', postId);
  if (error) throw new ApiError(400, error.message);
}

// ── Likes (post_likes join table) ─────────────────────────────────────────────
async function currentUserId(): Promise<string> {
  const { data } = await supabase.auth.getUser();
  if (!data.user) throw new ApiError(401, 'Not authenticated');
  return data.user.id;
}

/** Like a post (atomic insert). */
export async function likePost(postId: string): Promise<void> {
  const userId = await currentUserId();
  const { error } = await supabase.from('post_likes').insert({ user_id: userId, post_id: postId });
  if (error) throw new ApiError(400, error.message);
}

/** Unlike a post (atomic delete). */
export async function unlikePost(postId: string): Promise<void> {
  const userId = await currentUserId();
  const { error } = await supabase
    .from('post_likes')
    .delete()
    .eq('user_id', userId)
    .eq('post_id', postId);
  if (error) throw new ApiError(400, error.message);
}

/** Number of likes on a post. */
export async function getLikeCount(postId: string): Promise<number> {
  const { count, error } = await supabase
    .from('post_likes')
    .select('*', { count: 'exact', head: true })
    .eq('post_id', postId);
  if (error) throw new ApiError(400, error.message);
  return count ?? 0;
}
