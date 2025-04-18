//
//  PitcherAdvancedStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/17/25.
//

import SwiftUI

struct PitcherAdvancedStatsView: View {
    var pitchingStatsHelper: PitchingStatsHelper
    
    var body: some View {
        VStack {
            HStack {
                Text("Advanced")
                    .font(.parkFactorFontSubtitleNorwester)
                    .foregroundStyle(Color.white)
                
                Spacer()
            }
            .padding(20)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 5) {
                // First Row with stat category
                Text("SIERA")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("xERA")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("FIP")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("xFIP")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("FB Velo")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                
                // Second Row with above categories
                Text(String(format: "%.2f", NSDecimalNumber(decimal: pitchingStatsHelper.pitchingStats?[0].siera ?? 0.0).doubleValue))
                Text(String(format: "%.2f", NSDecimalNumber(decimal: pitchingStatsHelper.pitchingStats?[0].expectedEra ?? 0.0).doubleValue))
                Text(String(format: "%.2f", NSDecimalNumber(decimal: pitchingStatsHelper.pitchingStats?[0].fip ?? 0.0).doubleValue))
                Text(String(format: "%.2f", NSDecimalNumber(decimal: pitchingStatsHelper.pitchingStats?[0].expectedFip ?? 0.0).doubleValue))
                Text(String(format: "%.1f", NSDecimalNumber(decimal: pitchingStatsHelper.pitchingStats?[0].velocityFastball ?? 0.0).doubleValue))
                
                // Row for spacing
                Text("")
                Text("")
                Text("")
                Text("")
                Text("")
                
                // Fourth Row with more stat categories
                Text("WAR")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("K%")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("BB%")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("K-BB%")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("GB%")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                
                // Second Row with above categories
                Text(String(format: "%.1f", NSDecimalNumber(decimal: pitchingStatsHelper.pitchingStats?[0].war ?? 0.0).doubleValue))
                Text(String(format: "%.3f", NSDecimalNumber(decimal: pitchingStatsHelper.pitchingStats?[0].strikeoutPercentage ?? 0.0).doubleValue))
                Text(String(format: "%.3f", NSDecimalNumber(decimal: pitchingStatsHelper.pitchingStats?[0].walkPercentage ?? 0.0).doubleValue))
                Text(String(format: "%.3f", NSDecimalNumber(decimal: pitchingStatsHelper.pitchingStats?[0].strikeoutMinusWalkPercentage ?? 0.0).doubleValue))
                Text(String(format: "%.3f", NSDecimalNumber(decimal: pitchingStatsHelper.pitchingStats?[0].groundBallPercentage ?? 0.0).doubleValue))
            }
            .font(.parkFactorFontSmallText)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color.black)
        .cornerRadius(10)
        .padding(.bottom, 10)
        
        VStack {
            HStack {
                Text("Pitching Plus")
                    .font(.parkFactorFontSubtitleNorwester)
                    .foregroundStyle(Color.white)
                
                Spacer()
            }
            .padding(20)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 5) {
                // First Row with stat category
                Text("Stuff+")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("Pitching+")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("Location+")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                
                // Second Row with above categories
                Text("\(pitchingStatsHelper.pitchingStats?[0].stuffPlus ?? 0)")
                Text("\(pitchingStatsHelper.pitchingStats?[0].pitchingPlus ?? 0)")
                Text("\(pitchingStatsHelper.pitchingStats?[0].locationPlus ?? 0)")
            }
            .font(.parkFactorFontSmallText)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color.black)
        .cornerRadius(10)
    }
}

#Preview {
    PitcherAdvancedStatsView(pitchingStatsHelper: PitchingStatsHelper(pitchingStats: [PitchingStats(babip: 0.185, walks: 9, walkPercentage: 0.161, barrelPercentage: 0.069, completeGames: 0, changeupPercentage: nil, curveballPercentage: 0.232, era: 4.85, exitVelocity: 86.5, fastballPercentage: 0.494, cutterPercentage: nil, fip: 4.69, splitterPercentage: nil, games: 3, groundBallPercentage: 0.379, gamesStarted: 3, hardHitPercentage: 0.276, inningsPitched: 13, strikeoutPercentage: 0.304, strikeoutMinusWalkPercentage: 0.143, losses: 0, locationPlusChangeup: nil, locationPlusCurveball: 78, locationPlusFastball: 83, locationPlusCutter: nil, locationPlusOther: nil, locationPlusSplitter: nil, locationPlusKnuckleCurve: nil, locationPlusSinker: 95, locationPlusSlider: 87, locationPlus: 84, oSwingPercentage: 0.174, pitchPlusChangeup: nil, pitchPlusCurveball: 75, pitchPlusFastball: 91, pitchPlusCutter: nil, pitchPlusOther: nil, pitchPlusSplitter: nil, pitchPlusKnuckleCurve: nil, pitchPlusSinker: 98, pitchPlusSlider: 87, pitchingPlus: 87, sinkerPercentage: 0.084, siera: 4.03, sliderPercentage: 0.19, strikeouts: 17, saves: 0, stuffPlusChangeup: nil, stuffPlusCurveball: 92, stuffPlusFastball: 103, stuffPlusCutter: nil, stuffPlusOther: nil, stuffPlusSplitter: nil, stuffPlusKnuckleCurve: nil, stuffPlusSinker: 93, stuffPlusSlider: 89, stuffPlus: 97, team: "LAD", wins: 1, war: 0.1, whip: 1.23, velocityChangeup: nil, velocityCurveball: 82.1, velocityFastball: 95.6, velocityCutter: nil, velocitySplitter: nil, velocitySinker: 95.5, velocitySlider: 90.2, expectedEra: 3.53, expectedFip: 4.12)]))
}
