//
//  PitcherStatsOverviewView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/17/25.
//

import SwiftUI

struct PitcherStatsOverviewView: View {
    var player: Player
    var pitchingStatsHelper: PitchingStatsHelper
    
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            ScrollView {
                VStack {
                    PlayerOverviewCardView(player: player)
                        .padding(.bottom, 10)
                    PitcherOverviewStatsCardView(player: player, pitchingStatsHelper: pitchingStatsHelper)
                        .padding(.bottom, 10)
                    PitcherSpiderGraphView(player: player, color: getTeamColor())
                }
                .padding(20)
            }
        }
    }
    
    private func getTeamColor() -> Color {
        switch pitchingStatsHelper.pitchingStats?[0].team {
        case "LAA":
            return Color(red: 0.72, green: 0.0, blue: 0.13)
        case "SEA":
            return Color(red: 0.0, green: 0.27, blue: 0.36)
        case "TEX":
            return Color(red: 0.0, green: 0.24, blue: 0.58)
        case "HOU":
            return Color(red: 0.0, green: 0.18, blue: 0.32)
        case "ATH":
            return Color(red: 0.0, green: 0.47, blue: 0.29)
        case "CHW":
            return Color(red: 0.1, green: 0.1, blue: 0.1)
        case "MIN":
            return Color(red: 0.0, green: 0.2, blue: 0.4)
        case "KCR":
            return Color(red: 0.0, green: 0.38, blue: 0.75)
        case "DET":
            return Color(red: 0.0, green: 0.16, blue: 0.31)
        case "CLE":
            return Color(red: 0.6, green: 0.0, blue: 0.0)
        case "NYY":
            return Color(red: 0.12, green: 0.16, blue: 0.29)
        case "BOS":
            return Color(red: 0.51, green: 0.09, blue: 0.13)
        case "TBR":
            return Color(red: 0.0, green: 0.2, blue: 0.42)
        case "TOR":
            return Color(red: 0.0, green: 0.4, blue: 0.8)
        case "BAL":
            return Color(red: 1.0, green: 0.38, blue: 0.0)
        case "SFG":
            return Color(red: 0.84, green: 0.38, blue: 0.13)
        case "LAD":
            return Color(red: 0.0, green: 0.38, blue: 0.67)
        case "SDP":
            return Color(red: 0.38, green: 0.29, blue: 0.0)
        case "ARI":
            return Color(red: 0.45, green: 0.0, blue: 0.09)
        case "COL":
            return Color(red: 0.31, green: 0.09, blue: 0.44)
        case "CHC":
            return Color(red: 0.0, green: 0.32, blue: 0.61)
        case "CIN":
            return Color(red: 0.85, green: 0.01, blue: 0.16)
        case "PIT":
            return Color(red: 0.98, green: 0.78, blue: 0.18)
        case "MIL":
            return Color(red: 0.0, green: 0.2, blue: 0.4)
        case "STL":
            return Color(red: 0.76, green: 0.04, blue: 0.14)
        case "NYM":
            return Color(red: 0.0, green: 0.34, blue: 0.71)
        case "WSN":
            return Color(red: 0.54, green: 0.0, blue: 0.15)
        case "MIA":
            return Color(red: 1.0, green: 0.4, blue: 0.0)
        case "ATL":
            return Color(red: 0.29, green: 0.09, blue: 0.18)
        case "PHI":
            return Color(red: 0.61, green: 0.09, blue: 0.18)
        default:
            return Color.white
        }
    }
}

#Preview {
    PitcherStatsOverviewView(player: Player(keyBbref: "glasnty01", keyFangraphs: 14374, keyMlbam: 607192, keyRetro: "glast001", mlbPlayedFirst: 2016, mlbPlayedLast: 2025, nameFirst: "tyler", nameLast: "glasnow"), pitchingStatsHelper: PitchingStatsHelper(pitchingStats: [PitchingStats(babip: 0.185, walks: 9, walkPercentage: 0.161, barrelPercentage: 0.069, completeGames: 0, changeupPercentage: nil, curveballPercentage: 0.232, era: 4.85, exitVelocity: 86.5, fastballPercentage: 0.494, cutterPercentage: nil, fip: 4.69, splitterPercentage: nil, games: 3, groundBallPercentage: 0.379, gamesStarted: 3, hardHitPercentage: 0.276, inningsPitched: 13, strikeoutPercentage: 0.304, strikeoutMinusWalkPercentage: 0.143, losses: 0, locationPlusChangeup: nil, locationPlusCurveball: 78, locationPlusFastball: 83, locationPlusCutter: nil, locationPlusOther: nil, locationPlusSplitter: nil, locationPlusKnuckleCurve: nil, locationPlusSinker: 95, locationPlusSlider: 87, locationPlus: 84, oSwingPercentage: 0.174, pitchPlusChangeup: nil, pitchPlusCurveball: 75, pitchPlusFastball: 91, pitchPlusCutter: nil, pitchPlusOther: nil, pitchPlusSplitter: nil, pitchPlusKnuckleCurve: nil, pitchPlusSinker: 98, pitchPlusSlider: 87, pitchingPlus: 87, sinkerPercentage: 0.084, siera: 4.03, sliderPercentage: 0.19, strikeouts: 17, saves: 0, stuffPlusChangeup: nil, stuffPlusCurveball: 92, stuffPlusFastball: 103, stuffPlusCutter: nil, stuffPlusOther: nil, stuffPlusSplitter: nil, stuffPlusKnuckleCurve: nil, stuffPlusSinker: 93, stuffPlusSlider: 89, stuffPlus: 97, team: "LAD", wins: 1, war: 0.1, whip: 1.23, velocityChangeup: nil, velocityCurveball: 82.1, velocityFastball: 95.6, velocityCutter: nil, velocitySplitter: nil, velocitySinker: 95.5, velocitySlider: 90.2, expectedEra: 3.53, expectedFip: 4.12)]))
}
