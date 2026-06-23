/** MLB headshot ("silo") URL for a player by their MLBAM id. */
export const playerHeadshotUrl = (keyMlbam?: number | null): string =>
  `https://img.mlbstatic.com/mlb-photos/image/upload/w_180,d_people:generic:headshot:silo:current.png,q_auto:best,f_auto/v1/people/${
    keyMlbam ?? 1
  }/headshot/silo/current`;
