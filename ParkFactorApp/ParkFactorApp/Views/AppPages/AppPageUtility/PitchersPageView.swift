//
//  PitchersPageView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/15/25.
//

import SwiftUI

struct PitchersPageView: View {
    var savedUser: SavedUser
    var player: Player
    var pitchingStatsHelper: PitchingStatsHelper
    
    var body: some View {
        Text("Pitcher \(player.fullName)")
    }
}

#Preview {
    PitchersPageView(savedUser: SavedUser(), player: Player(keyBbref: "glasnty01", keyFangraphs: 14374, keyMlbam: 607192, keyRetro: "glast001", mlbPlayedFirst: 2016, mlbPlayedLast: 2025, nameFirst: "tyler", nameLast: "glasnow"), pitchingStatsHelper: PitchingStatsHelper(pitchingStats: [PitchingStats(babip: 0.185, walks: 9, walkPercentage: 0.161, barrelPercentage: 0.069, completeGames: 0, changeupPercentage: nil, curveballPercentage: 0.232, era: 4.85, exitVelocity: 86.5, fastballPercentage: 0.494, cutterPercentage: nil, fip: 4.69, splitterPercentage: nil, games: 3, groundBallPercentage: 0.379, gamesStarted: 3, hardHitPercentage: 0.276, inningsPitched: 13, strikeoutPercentage: 0.304, strikeoutMinusWalkPercentage: 0.143, losses: 0, locationPlusChangeup: nil, locationPlusCurveball: 78, locationPlusFastball: 83, locationPlusCutter: nil, locationPlusOther: nil, locationPlusSplitter: nil, locationPlusKnuckleCurve: nil, locationPlusSinker: 95, locationPlusSlider: 87, locationPlus: 84, oSwingPercentage: 0.174, pitchPlusChangeup: nil, pitchPlusCurveball: 75, pitchPlusFastball: 91, pitchPlusCutter: nil, pitchPlusOther: nil, pitchPlusSplitter: nil, pitchPlusKnuckleCurve: nil, pitchPlusSinker: 98, pitchPlusSlider: 87, pitchingPlus: 87, sinkerPercentage: 0.084, siera: 4.03, sliderPercentage: 0.19, strikeouts: 17, saves: 0, stuffPlusChangeup: nil, stuffPlusCurveball: 92, stuffPlusFastball: 103, stuffPlusCutter: nil, stuffPlusOther: nil, stuffPlusSplitter: nil, stuffPlusKnuckleCurve: nil, stuffPlusSinker: 93, stuffPlusSlider: 89, stuffPlus: 97, team: "LAD", wins: 1, war: 0.1, whip: 1.23, velocityChangeup: nil, velocityCurveball: 82.1, velocityFastball: 95.6, velocityCutter: nil, velocitySplitter: nil, velocitySinker: 95.5, velocitySlider: 90.2, expectedEra: 3.53, expectedFip: 4.12)]))
}
