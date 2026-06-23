/** StatCategory — explanation metadata loaded from assets/statcategory.json. */
export interface StatCategory {
  name: string;
  description: string;
  why: string;
  formula: string;
}

export * from './player';
export * from './team';
export * from './stats';
export * from './percentiles';
export * from './pitch';
export * from './social';
export * from './schedule';
export * from './leaderboard';
