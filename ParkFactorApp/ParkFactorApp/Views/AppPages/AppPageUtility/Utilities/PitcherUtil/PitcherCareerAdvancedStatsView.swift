//
//  PitcherCareerAdvancedStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/17/25.
//

import SwiftUI

struct PitcherCareerAdvancedStatsView: View {
    var pitchingCareerStatsHelper: PitchingCareerStatsHelper?
    
    var body: some View {
        VStack {
            if let careerStats = pitchingCareerStatsHelper?.pitchingCareerStats {
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
                        Text("BABIP")
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
                        Text(String(format: "%.2f", NSDecimalNumber(decimal: careerStats[0].siera ?? 0.0).doubleValue))
                        Text(String(format: "%.3f", NSDecimalNumber(decimal: careerStats[0].babip ?? 0.0).doubleValue))
                        Text(String(format: "%.2f", NSDecimalNumber(decimal: careerStats[0].fip ?? 0.0).doubleValue))
                        Text(String(format: "%.2f", NSDecimalNumber(decimal: careerStats[0].expectedFip ?? 0.0).doubleValue))
                        Text(String(format: "%.1f", NSDecimalNumber(decimal: careerStats[0].velocityFastball ?? 0.0).doubleValue))
                        
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
                        Text(String(format: "%.1f", NSDecimalNumber(decimal: careerStats[0].war ?? 0.0).doubleValue))
                        Text(String(format: "%.3f", NSDecimalNumber(decimal: careerStats[0].strikeoutPercentage ?? 0.0).doubleValue))
                        Text(String(format: "%.3f", NSDecimalNumber(decimal: careerStats[0].walkPercentage ?? 0.0).doubleValue))
                        Text(String(format: "%.3f", NSDecimalNumber(decimal: careerStats[0].strikeoutMinusWalkPercentage ?? 0.0).doubleValue))
                        Text(String(format: "%.3f", NSDecimalNumber(decimal: careerStats[0].groundBallPercentage ?? 0.0).doubleValue))
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
                        Text("\(careerStats[0].stuffPlus ?? 0)")
                        Text("\(careerStats[0].pitchingPlus ?? 0)")
                        Text("\(careerStats[0].locationPlus ?? 0)")
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
    }
}

#Preview {
    PitcherCareerAdvancedStatsView(pitchingCareerStatsHelper: PitchingCareerStatsHelper(pitchingCareerStats: [PitchingCareerStats(babip: 0.282, walks: 256, walkPercentage: 0.092, barrelPercentage: 0.082, completeGames: 0, changeupPercentage: 0.028, curveballPercentage: 0.229, era: 3.83, exitVelocity: 89.5, fastballPercentage: 0.531, cutterPercentage: 0, fip: 3.47, splitterPercentage: nil, games: 152, groundBallPercentage: 0.473, gamesStarted: 113, hardHitPercentage: 0.396, inningsPitched: 676.2, strikeoutPercentage: 0.311, strikeoutMinusWalkPercentage: 0.22, losses: 33, locationPlusChangeup: 106, locationPlusCurveball: 88, locationPlusFastball: 102, locationPlusCutter: nil, locationPlusOther: nil, locationPlusSplitter: nil, locationPlusKnuckleCurve: nil, locationPlusSinker: 91, locationPlusSlider: 102, locationPlus: 99, oSwingPercentage: 0.27, pitchPlusChangeup: 100, pitchPlusCurveball: 116, pitchPlusFastball: 115, pitchPlusCutter: nil, pitchPlusOther: nil, pitchPlusSplitter: nil, pitchPlusKnuckleCurve: nil, pitchPlusSinker: 103, pitchPlusSlider: 112, pitchingPlus: 114, sinkerPercentage: 0.046, siera: 3.42, sliderPercentage: 0.158, strikeouts: 863, saves: 0, stuffPlusChangeup: 86, stuffPlusCurveball: 124, stuffPlusFastball: 111, stuffPlusCutter: nil, stuffPlusOther: nil, stuffPlusSplitter: nil, stuffPlusKnuckleCurve: nil, stuffPlusSinker: 112, stuffPlusSlider: 101, stuffPlus: 111, wins: 40, war: 13.7, whip: 1.16, velocityChangeup: 90.5, velocityCurveball: 83, velocityFastball: 96.6, velocityCutter: 95.9, velocitySplitter: nil, velocitySinker: 95.4, velocitySlider: 89.5, expectedEra: nil, expectedFip: 3.22)]))
}
