/**
 * Team identity record (Lahman-style columns from the backend).
 * Display names (full name / city / mascot) come from `utils/teams.ts` via teamByBR(teamIDBR),
 * replacing the giant switch statements that lived on the Swift Team model.
 */
export interface Team {
  franchID: string;
  lgID: string;
  teamID: string;
  teamIDBR: string;
  teamIDfg: number;
  teamIDretro: string;
  yearID: number;
}
