/**
 * Single source of truth for MLB team identity.
 *
 * Replaces the many duplicated `switch` statements in the Swift app:
 *   - Team.teamName / teamCity / teamMascot          (keyed by Baseball-Reference abbr)
 *   - HitterStats.teamName / PitchingStats.teamName  (keyed by FanGraphs abbr)
 *   - GameDetails.teamMascot / oppTeamMascot         (keyed by FanGraphs abbr)
 *   - HitterPreviewStats / PitchingPreviewStats      (keyed by full city + league)
 *
 * `brAbbr` is the Baseball-Reference code (used by Team). `fgAbbr` matches it except
 * for the Athletics (BR "OAK" vs FG "ATH"). `previewCity` is the full city string from
 * the Baseball-Reference preview feed, disambiguated by `league` for shared cities.
 */

export type League = 'AL' | 'NL';

export interface TeamInfo {
  brAbbr: string;
  fgAbbr: string;
  league: League;
  fullName: string;
  city: string;
  mascot: string;
  previewCity: string;
}

export const TEAMS: TeamInfo[] = [
  // AL West
  { brAbbr: 'LAA', fgAbbr: 'LAA', league: 'AL', fullName: 'Los Angeles Angels', city: 'Los Angeles', mascot: 'Angels', previewCity: 'Los Angeles' },
  { brAbbr: 'SEA', fgAbbr: 'SEA', league: 'AL', fullName: 'Seattle Mariners', city: 'Seattle', mascot: 'Mariners', previewCity: 'Seattle' },
  { brAbbr: 'TEX', fgAbbr: 'TEX', league: 'AL', fullName: 'Texas Rangers', city: 'Texas', mascot: 'Rangers', previewCity: 'Texas' },
  { brAbbr: 'HOU', fgAbbr: 'HOU', league: 'AL', fullName: 'Houston Astros', city: 'Houston', mascot: 'Astros', previewCity: 'Houston' },
  { brAbbr: 'OAK', fgAbbr: 'ATH', league: 'AL', fullName: 'Oakland Athletics', city: 'Sacramento', mascot: 'Athletics', previewCity: 'Oakland' },
  // AL Central
  { brAbbr: 'CHW', fgAbbr: 'CHW', league: 'AL', fullName: 'Chicago White Sox', city: 'Chicago', mascot: 'White Sox', previewCity: 'Chicago' },
  { brAbbr: 'MIN', fgAbbr: 'MIN', league: 'AL', fullName: 'Minnesota Twins', city: 'Minnesota', mascot: 'Twins', previewCity: 'Minnesota' },
  { brAbbr: 'KCR', fgAbbr: 'KCR', league: 'AL', fullName: 'Kansas City Royals', city: 'Kansas City', mascot: 'Royals', previewCity: 'Kansas City' },
  { brAbbr: 'DET', fgAbbr: 'DET', league: 'AL', fullName: 'Detroit Tigers', city: 'Detroit', mascot: 'Tigers', previewCity: 'Detroit' },
  { brAbbr: 'CLE', fgAbbr: 'CLE', league: 'AL', fullName: 'Cleveland Guardians', city: 'Cleveland', mascot: 'Guardians', previewCity: 'Cleveland' },
  // AL East
  { brAbbr: 'NYY', fgAbbr: 'NYY', league: 'AL', fullName: 'New York Yankees', city: 'New York', mascot: 'Yankees', previewCity: 'New York' },
  { brAbbr: 'BOS', fgAbbr: 'BOS', league: 'AL', fullName: 'Boston Red Sox', city: 'Boston', mascot: 'Red Sox', previewCity: 'Boston' },
  { brAbbr: 'TBR', fgAbbr: 'TBR', league: 'AL', fullName: 'Tampa Bay Rays', city: 'Tampa Bay', mascot: 'Rays', previewCity: 'Tampa Bay' },
  { brAbbr: 'TOR', fgAbbr: 'TOR', league: 'AL', fullName: 'Toronto Blue Jays', city: 'Toronto', mascot: 'Blue Jays', previewCity: 'Toronto' },
  { brAbbr: 'BAL', fgAbbr: 'BAL', league: 'AL', fullName: 'Baltimore Orioles', city: 'Baltimore', mascot: 'Orioles', previewCity: 'Baltimore' },
  // NL West
  { brAbbr: 'SFG', fgAbbr: 'SFG', league: 'NL', fullName: 'San Francisco Giants', city: 'San Francisco', mascot: 'Giants', previewCity: 'San Francisco' },
  { brAbbr: 'LAD', fgAbbr: 'LAD', league: 'NL', fullName: 'Los Angeles Dodgers', city: 'Los Angeles', mascot: 'Dodgers', previewCity: 'Los Angeles' },
  { brAbbr: 'SDP', fgAbbr: 'SDP', league: 'NL', fullName: 'San Diego Padres', city: 'San Diego', mascot: 'Padres', previewCity: 'San Diego' },
  { brAbbr: 'ARI', fgAbbr: 'ARI', league: 'NL', fullName: 'Arizona Diamondbacks', city: 'Arizona', mascot: 'Diamondbacks', previewCity: 'Arizona' },
  { brAbbr: 'COL', fgAbbr: 'COL', league: 'NL', fullName: 'Colorado Rockies', city: 'Colorado', mascot: 'Rockies', previewCity: 'Colorado' },
  // NL Central
  { brAbbr: 'CHC', fgAbbr: 'CHC', league: 'NL', fullName: 'Chicago Cubs', city: 'Chicago', mascot: 'Cubs', previewCity: 'Chicago' },
  { brAbbr: 'CIN', fgAbbr: 'CIN', league: 'NL', fullName: 'Cincinnati Reds', city: 'Cincinnati', mascot: 'Reds', previewCity: 'Cincinnati' },
  { brAbbr: 'PIT', fgAbbr: 'PIT', league: 'NL', fullName: 'Pittsburgh Pirates', city: 'Pittsburgh', mascot: 'Pirates', previewCity: 'Pittsburgh' },
  { brAbbr: 'MIL', fgAbbr: 'MIL', league: 'NL', fullName: 'Milwaukee Brewers', city: 'Milwaukee', mascot: 'Brewers', previewCity: 'Milwaukee' },
  { brAbbr: 'STL', fgAbbr: 'STL', league: 'NL', fullName: 'St. Louis Cardinals', city: 'St. Louis', mascot: 'Cardinals', previewCity: 'St. Louis' },
  // NL East
  { brAbbr: 'NYM', fgAbbr: 'NYM', league: 'NL', fullName: 'New York Mets', city: 'New York', mascot: 'Mets', previewCity: 'New York' },
  { brAbbr: 'WSN', fgAbbr: 'WSN', league: 'NL', fullName: 'Washington Nationals', city: 'Washington', mascot: 'Nationals', previewCity: 'Washington' },
  { brAbbr: 'MIA', fgAbbr: 'MIA', league: 'NL', fullName: 'Miami Marlins', city: 'Miami', mascot: 'Marlins', previewCity: 'Miami' },
  { brAbbr: 'ATL', fgAbbr: 'ATL', league: 'NL', fullName: 'Atlanta Braves', city: 'Atlanta', mascot: 'Braves', previewCity: 'Atlanta' },
  { brAbbr: 'PHI', fgAbbr: 'PHI', league: 'NL', fullName: 'Philadelphia Phillies', city: 'Philadelphia', mascot: 'Phillies', previewCity: 'Philadelphia' },
];

const byBR = new Map(TEAMS.map((t) => [t.brAbbr, t]));
const byFG = new Map(TEAMS.map((t) => [t.fgAbbr, t]));

/** Look up by Baseball-Reference abbreviation (Team model). */
export const teamByBR = (abbr?: string | null): TeamInfo | undefined =>
  abbr ? byBR.get(abbr) : undefined;

/** Look up by FanGraphs abbreviation (stats + schedule models). */
export const teamByFG = (abbr?: string | null): TeamInfo | undefined =>
  abbr ? byFG.get(abbr) : undefined;

/** Look up by full city + league (preview-stat models, which share cities across leagues). */
export const teamByCity = (city?: string | null, level?: string | null): TeamInfo | undefined => {
  if (!city) return undefined;
  const league: League | undefined =
    level === 'Maj-AL' ? 'AL' : level === 'Maj-NL' ? 'NL' : undefined;
  return TEAMS.find((t) => t.previewCity === city && (league === undefined || t.league === league));
};

/** Mascot helpers matching the Swift computed properties; fall back to "Free Agent". */
export const mascotByFG = (abbr?: string | null): string => teamByFG(abbr)?.mascot ?? 'Free Agent';
export const mascotByCity = (city?: string | null, level?: string | null): string =>
  teamByCity(city, level)?.mascot ?? 'Free Agent';

/**
 * Primary team colors (hex), keyed by Baseball-Reference abbr. Replaces the duplicated
 * getTeamColor() switch in the leaderboard helper views. Used only behind player headshots.
 */
const TEAM_COLORS: Record<string, string> = {
  LAA: '#B80021', SEA: '#00455C', TEX: '#003D94', HOU: '#002E52', OAK: '#00784A',
  CHW: '#1A1A1A', MIN: '#003366', KCR: '#0061BF', DET: '#00294F', CLE: '#990000',
  NYY: '#1F294A', BOS: '#821721', TBR: '#00336B', TOR: '#0066CC', BAL: '#FF6100',
  SFG: '#D66121', LAD: '#0061AB', SDP: '#614A00', ARI: '#730017', COL: '#4F1770',
  CHC: '#00529C', CIN: '#D90329', PIT: '#FAC72E', MIL: '#003366', STL: '#C20A24',
  NYM: '#0057B5', WSN: '#8A0026', MIA: '#FF6600', ATL: '#4A172E', PHI: '#9C172E',
};

/** ssref logo-file overrides where the logo code differs from the BR abbr. */
const LOGO_OVERRIDES: Record<string, string> = { LAA: 'ANA', TBR: 'TBD', MIA: 'FLA' };

const WHITE = '#FFFFFF';

export const teamColor = (info?: TeamInfo): string => (info ? TEAM_COLORS[info.brAbbr] ?? WHITE : WHITE);
export const teamColorByFG = (abbr?: string | null): string => teamColor(teamByFG(abbr));

/** Baseball-Reference team logo URL (used in team leaderboard rows). */
export const teamLogoUrl = (info?: TeamInfo): string | undefined => {
  if (!info) return undefined;
  const code = LOGO_OVERRIDES[info.brAbbr] ?? info.brAbbr;
  return `https://cdn.ssref.net/req/202502211/tlogo/br/${code}.png`;
};
export const teamLogoUrlByFG = (abbr?: string | null): string | undefined => teamLogoUrl(teamByFG(abbr));
