import type { Player } from '@/types';

/**
 * Leaderboards return display names without accents; the player-id lookup needs the accented
 * form. This ports the hardcoded fixups from PlayerType*LeaderboardHelperView.
 * TODO: replace with a proper name-normalization / id map once the data layer is rebuilt.
 */
export function resolveLeaderboardName(displayName: string): { first: string; last: string } {
  const parts = displayName.split(' ');
  let first = parts[0] ?? '';
  let last = parts[1] ?? '';

  if (first === 'Fernando' && last === 'Tatis') last = 'Tatís';
  else if (first === 'Jose' && last === 'Ramirez') { first = 'José'; last = 'Ramírez'; }
  else if (first === 'J.P.') first = 'j. p.';
  else if (first === 'Jung' && last === 'Hoo') { first = 'Jung Hoo'; last = 'Lee'; }
  else if (first === 'Elly' && last === 'De') { first = 'Elly'; last = 'de la cruz'; }
  else if (first === 'Luis' && last === 'Arraez') last = 'Arráez';
  else if (first === 'Adolis' && last === 'Garcia') last = 'García';
  else if (first === 'Teoscar' && last === 'Hernandez') last = 'Hernández';
  else if (first === 'Randy' && last === 'Rodriguez') { first = 'Randy'; last = 'Rodríguez'; }
  else if (first === 'Matthew' && last === 'Boyd') first = 'Matt';
  else if (first === 'Andres' && last === 'Munoz') { first = 'Andrés'; last = 'Muñoz'; }
  else if (first === 'Jhoan' && last === 'Duran') last = 'Durán';
  else if (first === 'Seranthony' && last === 'Dominguez') last = 'Domínguez';

  return { first, last };
}

/** Pick the right record when multiple players share a name (historical duplicates). */
export function pickLeaderboardPlayer(
  results: Player[],
  first: string,
  last: string,
  isPitching: boolean,
): Player | undefined {
  if (results.length === 0) return undefined;
  const useSecond =
    (first === 'Will' && last === 'Smith' && !isPitching) ||
    (first === 'Jacob' && last === 'Wilson') ||
    (first === 'José' && last === 'Ramírez');
  return useSecond && results.length > 1 ? results[1] : results[0];
}
