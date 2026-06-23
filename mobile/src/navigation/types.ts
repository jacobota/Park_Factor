import type { NewsArticle, Player, Post, User } from '@/types';

/** Auth flow stack (shown when logged out). */
export type AuthStackParamList = {
  Login: undefined;
  Signup: undefined;
  // After signup the user is created + token stored, but onboarding finishes sign-in.
  OnboardingTeams: { user: User; token: string };
  OnboardingPlayers: { user: User; token: string };
};

/**
 * Profile destinations reused across tab stacks (player page from a leaderboard row,
 * team page from a team row, etc.). Each tab embeds these in its own native stack.
 */
export type ProfileStackParamList = {
  PlayerPage: { player: Player };
  TeamPage: { teamAbbr: string };
};

/** Stats tab stack. */
export type StatsStackParamList = ProfileStackParamList & {
  StatsHome: undefined;
};

/** News / Concourse tab stack. */
export type NewsStackParamList = {
  NewsHome: undefined;
  ArticleDetail: { article: NewsArticle };
  UserProfile: { username: string };
  EditPost: { post: Post };
};

/** Following tab stack — embeds the player/team profile destinations. */
export type FollowingStackParamList = ProfileStackParamList & {
  FollowingHome: undefined;
};

/** Account tab stack — profile destinations + settings detail screens. */
export type AccountStackParamList = ProfileStackParamList & {
  AccountHome: undefined;
  UserProfile: { username: string };
  EditPost: { post: Post };
  ChangeEmail: undefined;
  ChangePassword: undefined;
  ChangeUserTag: undefined;
  ChangeFavoriteTeam: undefined;
  ChangeFavoritePlayer: undefined;
};
