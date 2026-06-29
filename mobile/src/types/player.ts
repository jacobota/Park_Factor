/** Player identity — from Flask playerid_lookup (snake_case JSON). */
export interface Player {
  keyBbref?: string | null;
  keyFangraphs?: number | null;
  keyMlbam?: number | null;
  keyRetro?: string | null;
  mlbPlayedFirst?: number | null;
  mlbPlayedLast?: number | null;
  nameFirst?: string | null;
  nameLast?: string | null;
}

/** Raw JSON shape as delivered by the API for a player record. */
export interface PlayerRaw {
  key_bbref?: string | null;
  key_fangraphs?: number | null;
  key_mlbam?: number | null;
  key_retro?: string | null;
  mlb_played_first?: number | null;
  mlb_played_last?: number | null;
  name_first?: string | null;
  name_last?: string | null;
}

export const mapPlayer = (r: PlayerRaw): Player => ({
  keyBbref: r.key_bbref,
  keyFangraphs: r.key_fangraphs,
  keyMlbam: r.key_mlbam,
  keyRetro: r.key_retro,
  mlbPlayedFirst: r.mlb_played_first,
  mlbPlayedLast: r.mlb_played_last,
  nameFirst: r.name_first,
  nameLast: r.name_last,
});

const cap = (s: string) => (s ? s.charAt(0).toUpperCase() + s.slice(1) : s);

/** Player.fullName computed property. */
export const playerFullName = (p: Player): string =>
  `${cap(p.nameFirst ?? '')} ${cap(p.nameLast ?? '')}`.trim();

/** Header/bio from the MLB Stats API people endpoint (richer than the bbref bio). */
export interface PlayerPeople {
  fullName?: string | null;
  number?: string | null;
  position?: string | null;
  bats?: string | null;
  throws?: string | null;
  height?: string | null;
  weight?: number | null;
  born?: string | null;
  age?: number | null;
}

/** Player biographical info — backend wraps as { player_bio: {...} } with TitleCase keys. */
export interface PlayerBio {
  battingSide?: string | null; // "Bats"
  born?: string | null; // "Born"
  height?: string | null; // "Height"
  origin?: string | null; // "Origin"
  position?: string | null; // "Position"
  throwingSide?: string | null; // "Throws"
  weight?: string | null; // "Weight"
}
