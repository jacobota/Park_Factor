import { api } from './client';
import type { Post } from '@/types';

/** Body for creating/updating a verified-user post. */
export interface PostInput {
  content: string;
  authorProfilePicture?: string;
  postImage?: string;
}

interface CreatePostResponse {
  postId: string;
  author: string;
  authorProfilePicture: string;
  content: string;
  postImage: string;
  createdAt: string;
}

/** GET /verifiedPosts/ — every community post (newest first comes from the backend order). */
export const getAllPosts = () => api.get<Post[]>('/verifiedPosts/', { auth: true });

/** GET /verifiedPosts/postId/:id — single post (used to hydrate the user's liked posts). */
export const getPostById = (postId: string) =>
  api.get<Post>(`/verifiedPosts/postId/${postId}`, { auth: true });

/** GET /verifiedPosts/author/:username — all posts by one author. */
export const getPostsByAuthor = (username: string) =>
  api.get<Post[]>(`/verifiedPosts/author/${username}`, { auth: true });

/** POST /verifiedPosts/create — verified users only. */
export const createPost = (body: PostInput) =>
  api.post<CreatePostResponse>('/verifiedPosts/create', { auth: true, body });

/** PUT /verifiedPosts/update/:id — edit own post content/image. */
export const updatePost = (postId: string, body: PostInput) =>
  api.put(`/verifiedPosts/update/${postId}`, { auth: true, body });

/** DELETE /verifiedPosts/delete/:id — author removes their own post. */
export const deletePost = (postId: string) =>
  api.delete(`/verifiedPosts/delete/${postId}`, { auth: true });
