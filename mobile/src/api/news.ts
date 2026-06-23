import { api } from './client';
import type { NewsArticle } from '@/types';

/** NewsAPI envelope proxied by the backend. */
interface NewsResponse {
  articles?: NewsArticle[] | null;
}

/**
 * GET /news/ (all) or /news/:team — league news. The backend wraps NewsAPI, which returns
 * `{ articles: [...] }`; some article images/urls can be null, so callers guard those.
 */
export const getNews = async (team?: string): Promise<NewsArticle[]> => {
  const path = team && team !== 'All' ? `/news/${encodeURIComponent(team)}` : '/news/';
  const r = await api.get<NewsResponse | NewsArticle[]>(path);
  // The "all" route returns the raw NewsAPI body; the team route returns it too.
  const articles = Array.isArray(r) ? r : r.articles;
  return articles ?? [];
};

/** Team names used by the news filter (matches the Swift FilterNewsView list). */
export const NEWS_FILTER_TEAMS = [
  'Angels', 'Astros', 'Athletics', 'Blue Jays', 'Braves', 'Brewers', 'Cardinals', 'Cubs',
  'Diamondbacks', 'Dodgers', 'Giants', 'Guardians', 'Mariners', 'Marlins', 'Mets', 'Nationals',
  'Orioles', 'Padres', 'Phillies', 'Pirates', 'Rangers', 'Rays', 'Red Sox', 'Reds', 'Rockies',
  'Royals', 'Tigers', 'Twins', 'White Sox', 'Yankees',
];
