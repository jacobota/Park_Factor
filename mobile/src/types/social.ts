import type { Player } from './player';
import type { Team } from './team';

/** Authenticated user (backend already delivers camelCase). */
export interface User {
  username: string;
  admin: boolean;
  email: string;
  favoritePlayer?: Player | null;
  favoriteTeam?: Team | null;
  followingPlayers: Player[];
  followingTeams: Team[];
  password: string;
  profilePicture?: string | null;
  userBiography: string;
  userLikedPosts: string[];
  userTag: string;
  verified: boolean;
}

export const emptyUser = (): User => ({
  username: '',
  admin: false,
  email: '',
  favoritePlayer: null,
  favoriteTeam: null,
  followingPlayers: [],
  followingTeams: [],
  password: '',
  profilePicture: '',
  userBiography: '',
  userLikedPosts: [],
  userTag: '',
  verified: false,
});

export interface UserLoginResponse {
  user: User;
  token: string;
}
export interface UserRegisterResponse {
  message: string;
  user: User;
}

/** Community post. */
export interface Post {
  postId: string;
  author?: string | null;
  authorProfilePicture?: string | null;
  createdAt?: string | null;
  content?: string | null;
  postImage?: string | null;
}

export interface VerifiedUserPostResponse {
  postId: string;
  author: string;
  authorProfilePicture: string;
  content: string;
  postImage: string;
  createdAt: string;
}

/** News article (NewsAPI shape proxied by the backend). */
export interface NewsArticle {
  source: { id?: string | null; name?: string | null };
  author?: string | null;
  title: string;
  description: string;
  url?: string | null;
  urlToImage?: string | null;
  publishedAt?: string | null;
  content: string;
}

/** ISO8601 -> "MMMM dd, yyyy" (Post.formattedCreatedAtDate / NewsArticle.formattedPublishedDate). */
export const formatLongDate = (iso?: string | null): string | null => {
  if (!iso) return null;
  const d = new Date(iso);
  if (isNaN(d.getTime())) return null;
  return d.toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: '2-digit' });
};

/** Compact relative time ("3h", "2d", "1w") for feed meta rows; empty for invalid/missing. */
export const timeAgo = (iso?: string | null): string => {
  if (!iso) return '';
  const then = new Date(iso).getTime();
  if (isNaN(then)) return '';
  const secs = Math.max(0, (Date.now() - then) / 1000);
  if (secs < 60) return 'now';
  const mins = secs / 60;
  if (mins < 60) return `${Math.floor(mins)}m`;
  const hours = mins / 60;
  if (hours < 24) return `${Math.floor(hours)}h`;
  const days = hours / 24;
  if (days < 7) return `${Math.floor(days)}d`;
  return `${Math.floor(days / 7)}w`;
};

/** NewsArticle.cleanedContent — strip leading dateline and trailing "[+N chars]". */
export const cleanedContent = (content: string): string =>
  content
    .replace(/\b[A-Z][a-z]{2} \d{2}, \d{4}, \d{2}:\d{2} (AM|PM) ET\r?\n/, '')
    .replace(/\[\+\d+ chars\]/, '');
