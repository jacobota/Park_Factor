//
//  TeamPitchingSeasonStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/18/25.
//

import SwiftUI

struct TeamPitchingSeasonStatsView: View {
    var teamStats: TeamStats
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            ScrollView {
                VStack {
                    TeamPitchingDisplayStatsView(teamStats: teamStats)
                }
                .padding(20)
            }
        }
    }
}

#Preview {
    TeamPitchingSeasonStatsView(teamStats: TeamStats(teamBatting: [TeamBatting(average: 0.23, age: 29, babip: 0.262, walks: 45, bbPercentage: 0.067, bbToK: 0.27, bsr: 0.8, cs: 2, hits: 140, hr: 30, iso: 0.189, kPercentage: 0.245, obp: 0.292, ops: 0.711, runs: 79, sb: 9, slg: 0.419, strikeout: 165, war: 2, woba: 0.311, wrcPlus: 102, wsb: -0.2)], teamFielding: [TeamFielding(drs: -11, errors: 11, fieldingPercentage: 0.983, oaa: 1)], teamPitching: [TeamPitching(average: 0.251, babip: 0.282, walks: 70, bbPercentage: 0.104, era: 4.76, fip: 4.9, gbPercentage: 0.437, hitsAllowed: 150, hrPerFb: 0.143, kPercentage: 0.195, kMinusBbPercentage: 0.091, losses: 9, lobPercentage: 0.714, locationPlus: 101, pitchingPlus: 97, runs: 90, siera: 4.33, strikeouts: 131, saves: 6, stuffPlus: 97, wins: 9, war: 0.2, whip: 1.4, vfaPi: 93.6, xfip: 4.41)]))
}
