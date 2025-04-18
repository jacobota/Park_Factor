//
//  PitcherPitchArsenalStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/18/25.
//

import SwiftUI

struct PitcherPitchArsenalStatsView: View {
    var pitchingStatsHelper: PitchingStatsHelper
    
    var body: some View {
        VStack {
            HStack {
                Text("Pitch Arsenal")
                    .font(.parkFactorFontSubtitleNorwester)
                    .foregroundStyle(Color.white)
                
                Spacer()
            }
            .padding(20)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 2) {
                // First Row with stat category
                Text("Type")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("Stuff+")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("Pitch+")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("Loc+")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("Velo")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                
                // Row for spacing
                Text("")
                Text("")
                Text("")
                Text("")
                Text("")
                
                // Fastball Information (check if null first)
                if pitchingStatsHelper.pitchingStats?[0].velocityFastball != nil {
                    Text("Fastball")
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(Color.gray)
                    Text("\(pitchingStatsHelper.pitchingStats?[0].stuffPlusFastball ?? 0)")
                    Text("\(pitchingStatsHelper.pitchingStats?[0].pitchPlusFastball ?? 0)")
                    Text("\(pitchingStatsHelper.pitchingStats?[0].locationPlusFastball ?? 0)")
                    Text(String(format: "%.1f", NSDecimalNumber(decimal: pitchingStatsHelper.pitchingStats?[0].velocityFastball ?? 0.0).doubleValue))
                    
                    // Row for spacing
                    Text("")
                    Text("")
                    Text("")
                    Text("")
                    Text("")
                }
                
                // Sinker Information (check if null first)
                if pitchingStatsHelper.pitchingStats?[0].velocitySinker != nil {
                    Text("Sinker")
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(Color.gray)
                    Text("\(pitchingStatsHelper.pitchingStats?[0].stuffPlusSinker ?? 0)")
                    Text("\(pitchingStatsHelper.pitchingStats?[0].pitchPlusSinker ?? 0)")
                    Text("\(pitchingStatsHelper.pitchingStats?[0].locationPlusSinker ?? 0)")
                    Text(String(format: "%.1f", NSDecimalNumber(decimal: pitchingStatsHelper.pitchingStats?[0].velocitySinker ?? 0.0).doubleValue))
                    
                    // Row for spacing
                    Text("")
                    Text("")
                    Text("")
                    Text("")
                    Text("")
                }
                
                // Cutter Information (check if null first)
                if pitchingStatsHelper.pitchingStats?[0].velocityCutter != nil {
                    Text("Cutter")
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(Color.gray)
                    Text("\(pitchingStatsHelper.pitchingStats?[0].stuffPlusCutter ?? 0)")
                    Text("\(pitchingStatsHelper.pitchingStats?[0].pitchPlusCutter ?? 0)")
                    Text("\(pitchingStatsHelper.pitchingStats?[0].locationPlusCutter ?? 0)")
                    Text(String(format: "%.1f", NSDecimalNumber(decimal: pitchingStatsHelper.pitchingStats?[0].velocityCutter ?? 0.0).doubleValue))
                    
                    // Row for spacing
                    Text("")
                    Text("")
                    Text("")
                    Text("")
                    Text("")
                }
                
                // Splitter Information (check if null first)
                if pitchingStatsHelper.pitchingStats?[0].velocitySplitter != nil {
                    Text("Split")
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(Color.gray)
                    Text("\(pitchingStatsHelper.pitchingStats?[0].stuffPlusSplitter ?? 0)")
                    Text("\(pitchingStatsHelper.pitchingStats?[0].pitchPlusSplitter ?? 0)")
                    Text("\(pitchingStatsHelper.pitchingStats?[0].locationPlusSplitter ?? 0)")
                    Text(String(format: "%.1f", NSDecimalNumber(decimal: pitchingStatsHelper.pitchingStats?[0].velocitySplitter ?? 0.0).doubleValue))
                    
                    // Row for spacing
                    Text("")
                    Text("")
                    Text("")
                    Text("")
                    Text("")
                }
                
                // Curveball Information (check if null first)
                if pitchingStatsHelper.pitchingStats?[0].velocityCurveball != nil {
                    Text("Curve")
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(Color.gray)
                    Text("\(pitchingStatsHelper.pitchingStats?[0].stuffPlusCurveball ?? 0)")
                    Text("\(pitchingStatsHelper.pitchingStats?[0].pitchPlusCurveball ?? 0)")
                    Text("\(pitchingStatsHelper.pitchingStats?[0].locationPlusCurveball ?? 0)")
                    Text(String(format: "%.1f", NSDecimalNumber(decimal: pitchingStatsHelper.pitchingStats?[0].velocityCurveball ?? 0.0).doubleValue))
                    
                    // Row for spacing
                    Text("")
                    Text("")
                    Text("")
                    Text("")
                    Text("")
                }
                
                // Slider Information (check if null first)
                if pitchingStatsHelper.pitchingStats?[0].velocitySlider != nil {
                    Text("Slider")
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(Color.gray)
                    Text("\(pitchingStatsHelper.pitchingStats?[0].stuffPlusSlider ?? 0)")
                    Text("\(pitchingStatsHelper.pitchingStats?[0].pitchPlusSlider ?? 0)")
                    Text("\(pitchingStatsHelper.pitchingStats?[0].locationPlusSlider ?? 0)")
                    Text(String(format: "%.1f", NSDecimalNumber(decimal: pitchingStatsHelper.pitchingStats?[0].velocitySlider ?? 0.0).doubleValue))
                    
                    // Row for spacing
                    Text("")
                    Text("")
                    Text("")
                    Text("")
                    Text("")
                }
                
                // Changeup Information (check if null first)
                if pitchingStatsHelper.pitchingStats?[0].velocityChangeup != nil {
                    Text("Change")
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(Color.gray)
                    Text("\(pitchingStatsHelper.pitchingStats?[0].stuffPlusChangeup ?? 0)")
                    Text("\(pitchingStatsHelper.pitchingStats?[0].pitchPlusChangeup ?? 0)")
                    Text("\(pitchingStatsHelper.pitchingStats?[0].locationPlusChangeup ?? 0)")
                    Text(String(format: "%.1f", NSDecimalNumber(decimal: pitchingStatsHelper.pitchingStats?[0].velocityChangeup ?? 0.0).doubleValue))
                    
                    // Row for spacing
                    Text("")
                    Text("")
                    Text("")
                    Text("")
                    Text("")
                }
                
                // Other Information (check if null first)
                if pitchingStatsHelper.pitchingStats?[0].stuffPlusOther != nil {
                    Text("Other")
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(Color.gray)
                    Text("\(pitchingStatsHelper.pitchingStats?[0].stuffPlusOther ?? 0)")
                    Text("\(pitchingStatsHelper.pitchingStats?[0].pitchPlusOther ?? 0)")
                    Text("\(pitchingStatsHelper.pitchingStats?[0].locationPlusOther ?? 0)")
                }
                
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
    PitcherPitchArsenalStatsView(pitchingStatsHelper: PitchingStatsHelper(pitchingStats: [PitchingStats(babip: 0.185, walks: 9, walkPercentage: 0.161, barrelPercentage: 0.069, completeGames: 0, changeupPercentage: nil, curveballPercentage: 0.232, era: 4.85, exitVelocity: 86.5, fastballPercentage: 0.494, cutterPercentage: nil, fip: 4.69, splitterPercentage: nil, games: 3, groundBallPercentage: 0.379, gamesStarted: 3, hardHitPercentage: 0.276, inningsPitched: 13, strikeoutPercentage: 0.304, strikeoutMinusWalkPercentage: 0.143, losses: 0, locationPlusChangeup: nil, locationPlusCurveball: 78, locationPlusFastball: 83, locationPlusCutter: nil, locationPlusOther: nil, locationPlusSplitter: nil, locationPlusKnuckleCurve: nil, locationPlusSinker: 95, locationPlusSlider: 87, locationPlus: 84, oSwingPercentage: 0.174, pitchPlusChangeup: nil, pitchPlusCurveball: 75, pitchPlusFastball: 91, pitchPlusCutter: nil, pitchPlusOther: nil, pitchPlusSplitter: nil, pitchPlusKnuckleCurve: nil, pitchPlusSinker: 98, pitchPlusSlider: 87, pitchingPlus: 87, sinkerPercentage: 0.084, siera: 4.03, sliderPercentage: 0.19, strikeouts: 17, saves: 0, stuffPlusChangeup: nil, stuffPlusCurveball: 92, stuffPlusFastball: 103, stuffPlusCutter: nil, stuffPlusOther: nil, stuffPlusSplitter: nil, stuffPlusKnuckleCurve: nil, stuffPlusSinker: 93, stuffPlusSlider: 89, stuffPlus: 97, team: "LAD", wins: 1, war: 0.1, whip: 1.23, velocityChangeup: nil, velocityCurveball: 82.1, velocityFastball: 95.6, velocityCutter: nil, velocitySplitter: nil, velocitySinker: 95.5, velocitySlider: 90.2, expectedEra: 3.53, expectedFip: 4.12)]))
}
