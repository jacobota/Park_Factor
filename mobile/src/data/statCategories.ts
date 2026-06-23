import data from '@/assets/statcategory.json';
import type { StatCategory } from '@/types';

/** Stat explanation metadata keyed by stat id (e.g. "hitter_ba"), loaded from statcategory.json. */
export const statCategories = data as Record<string, StatCategory>;

export const getStatCategory = (key: string): StatCategory | undefined => statCategories[key];
