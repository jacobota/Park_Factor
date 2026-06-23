import React, { useState } from 'react';
import { View } from 'react-native';
import { DropDownMenu } from '@/components/DropDownMenu';
import { LeaderboardList } from '@/components/leaderboard/LeaderboardList';
import { getTeamHittingLeaderboard, getTeamPitchingLeaderboard } from '@/api/stats';
import { HITTING_LEADERBOARD, PITCHING_LEADERBOARD } from './leaderboardConfig';
import { AllTeamsList, TeamFollowingList } from './TeamSubsections';

const SECTIONS = ['Leaderboards', 'Following Teams', 'All Teams'];
const LEADERBOARD_TYPES = ['Team Hitting', 'Team Pitching'];

export function TeamStatsSection() {
  const [section, setSection] = useState('Leaderboards');
  const [boardType, setBoardType] = useState('Team Hitting');

  return (
    <View>
      <DropDownMenu options={SECTIONS} selected={section} onSelect={setSection} />

      {section === 'Leaderboards' && (
        <>
          <DropDownMenu options={LEADERBOARD_TYPES} selected={boardType} onSelect={setBoardType} />
          {boardType === 'Team Hitting' ? (
            <LeaderboardList
              queryKey={['leaderboard', 'team-hitting']}
              queryFn={getTeamHittingLeaderboard}
              config={HITTING_LEADERBOARD}
              variant="team"
            />
          ) : (
            <LeaderboardList
              queryKey={['leaderboard', 'team-pitching']}
              queryFn={getTeamPitchingLeaderboard}
              config={PITCHING_LEADERBOARD}
              variant="team"
            />
          )}
        </>
      )}

      {section === 'Following Teams' && <TeamFollowingList />}
      {section === 'All Teams' && <AllTeamsList />}
    </View>
  );
}
