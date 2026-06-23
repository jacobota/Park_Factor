import React from 'react';
import { StatCard, StatCell } from '@/components/cards/StatCard';
import { getStat } from '@/types';
import type { StatBag, TeamStats } from '@/types';
import { fmt, fmtInt } from '@/utils/format';

const hittingCells = (b: StatBag): StatCell[] => [
  { catKey: 'teams_hitting_ba', label: 'BA', value: fmt(getStat(b, 'AVG'), 3) },
  { catKey: 'teams_hitting_hits', label: 'H', value: fmtInt(getStat(b, 'H')) },
  { catKey: 'teams_hitting_hr', label: 'HR', value: fmtInt(getStat(b, 'HR')) },
  { catKey: 'teams_hitting_runs', label: 'R', value: fmtInt(getStat(b, 'R')) },
  { catKey: 'teams_hitting_strikeouts', label: 'K', value: fmtInt(getStat(b, 'SO')) },
  { catKey: 'teams_hitting_walks', label: 'BB', value: fmtInt(getStat(b, 'BB')) },
  { catKey: 'teams_hitting_obp', label: 'OBP', value: fmt(getStat(b, 'OBP'), 3) },
  { catKey: 'teams_hitting_slg', label: 'SLG', value: fmt(getStat(b, 'SLG'), 3) },
  { catKey: 'teams_hitting_war', label: 'WAR', value: fmt(getStat(b, 'WAR'), 1) },
  { catKey: 'teams_hitting_ops', label: 'OPS', value: fmt(getStat(b, 'OPS'), 3) },
  { catKey: 'teams_hitting_woba', label: 'wOBA', value: fmt(getStat(b, 'wOBA'), 3) },
  { catKey: 'teams_hitting_wrcplus', label: 'wRC+', value: fmtInt(getStat(b, 'wRC+')) },
  { catKey: 'teams_hitting_babip', label: 'BABIP', value: fmt(getStat(b, 'BABIP'), 3) },
  { catKey: 'teams_hitting_iso', label: 'ISO', value: fmt(getStat(b, 'ISO'), 3) },
  { catKey: 'teams_hitting_bbpercent', label: 'BB%', value: fmt(getStat(b, 'BB%'), 3) },
  { catKey: 'teams_hitting_kpercent', label: 'K%', value: fmt(getStat(b, 'K%'), 3) },
];

const fieldingCells = (f: StatBag): StatCell[] => [
  { catKey: 'teams_fielding_drs', label: 'DRS', value: fmtInt(getStat(f, 'DRS')) },
  { catKey: 'teams_fielding_errors', label: 'E', value: fmtInt(getStat(f, 'E')) },
  { catKey: 'teams_fielding_fieldpercent', label: 'FP', value: fmt(getStat(f, 'FP'), 3) },
  { catKey: 'teams_fielding_oaa', label: 'OAA', value: fmtInt(getStat(f, 'OAA')) },
];

const pitchingCells = (p: StatBag): StatCell[] => [
  { catKey: 'teams_pitching_era', label: 'ERA', value: fmt(getStat(p, 'ERA'), 2) },
  { catKey: 'teams_pitching_ra', label: 'RA', value: fmtInt(getStat(p, 'R')) },
  { catKey: 'teams_pitching_baa', label: 'BAA', value: fmt(getStat(p, 'AVG'), 3) },
  { catKey: 'teams_pitching_ha', label: 'HA', value: fmtInt(getStat(p, 'H')) },
  { catKey: 'teams_pitching_so', label: 'SO', value: fmtInt(getStat(p, 'SO')) },
  { catKey: 'teams_pitching_walks', label: 'BB', value: fmtInt(getStat(p, 'BB')) },
  { catKey: 'teams_pitching_whip', label: 'WHIP', value: fmt(getStat(p, 'WHIP'), 2) },
  { catKey: 'teams_pitching_fbvelo', label: 'FB Velo', value: fmt(getStat(p, 'vFA (pi)'), 1) },
  { catKey: 'teams_pitching_war', label: 'WAR', value: fmt(getStat(p, 'WAR'), 1) },
  { catKey: 'teams_pitching_fip', label: 'FIP', value: fmt(getStat(p, 'FIP'), 2) },
  { catKey: 'teams_pitching_xfip', label: 'xFIP', value: fmt(getStat(p, 'xFIP'), 2) },
  { catKey: 'teams_pitching_siera', label: 'SIERA', value: fmt(getStat(p, 'SIERA'), 2) },
  { catKey: 'teams_pitching_bbpercent', label: 'BB%', value: fmt(getStat(p, 'BB%'), 3) },
  { catKey: 'teams_pitching_kpercent', label: 'K%', value: fmt(getStat(p, 'K%'), 3) },
  { catKey: 'teams_pitching_kminusbbpercent', label: 'K-BB%', value: fmt(getStat(p, 'K-BB%'), 3) },
  { catKey: 'teams_pitching_babip', label: 'BABIP', value: fmt(getStat(p, 'BABIP'), 3) },
];

const pitchingPlusCells = (p: StatBag): StatCell[] => [
  { catKey: 'teams_pitching_stuffplus', label: 'Stuff+', value: fmtInt(getStat(p, 'Stuff+')) },
  { catKey: 'teams_pitching_locationplus', label: 'Location+', value: fmtInt(getStat(p, 'Location+')) },
  { catKey: 'teams_pitching_pitchingplus', label: 'Pitching+', value: fmtInt(getStat(p, 'Pitching+')) },
];

export function TeamHittingSection({ stats }: { stats: TeamStats }) {
  const batting = stats.teamBatting?.[0];
  const fielding = stats.teamFielding?.[0];
  return (
    <>
      {batting && <StatCard title="Hitting" cells={hittingCells(batting)} columns={4} />}
      {fielding && <StatCard title="Fielding" cells={fieldingCells(fielding)} columns={4} />}
    </>
  );
}

export function TeamPitchingSection({ stats }: { stats: TeamStats }) {
  const pitching = stats.teamPitching?.[0];
  if (!pitching) return null;
  return (
    <>
      <StatCard title="Pitching" cells={pitchingCells(pitching)} columns={4} />
      <StatCard title="Pitching Plus" cells={pitchingPlusCells(pitching)} columns={3} />
    </>
  );
}
