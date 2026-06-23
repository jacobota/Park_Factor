import type { Player, User } from '@/types';

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
