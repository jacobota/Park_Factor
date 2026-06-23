import React, { useState } from 'react';
import { View } from 'react-native';
import { DropDownMenu } from '@/components/DropDownMenu';
import { LeaderboardList } from '@/components/leaderboard/LeaderboardList';
import { getHitterLeaderboard, getPitcherLeaderboard } from '@/api/stats';
import { HITTING_LEADERBOARD, PITCHING_LEADERBOARD } from './leaderboardConfig';
import { PlayerFollowingList, PlayerLookupList } from './PlayerSubsections';

const SECTIONS = ['Leaderboards', 'Following Players', 'Player Lookup'];
const LEADERBOARD_TYPES = ['Hitting', 'Pitching'];

export function PlayerStatsSection() {
  const [section, setSection] = useState('Leaderboards');
  const [boardType, setBoardType] = useState('Hitting');

  return (
    <View>
      <DropDownMenu options={SECTIONS} selected={section} onSelect={setSection} />

      {section === 'Leaderboards' && (
        <>
          <DropDownMenu options={LEADERBOARD_TYPES} selected={boardType} onSelect={setBoardType} />
          {boardType === 'Hitting' ? (
            <LeaderboardList
              queryKey={['leaderboard', 'hitter']}
              queryFn={getHitterLeaderboard}
              config={HITTING_LEADERBOARD}
              variant="player"
            />
          ) : (
            <LeaderboardList
              queryKey={['leaderboard', 'pitcher']}
              queryFn={getPitcherLeaderboard}
              config={PITCHING_LEADERBOARD}
              variant="player"
              isPitching
            />
          )}
        </>
      )}

      {section === 'Following Players' && <PlayerFollowingList />}
      {section === 'Player Lookup' && <PlayerLookupList />}
    </View>
  );
}
