//
//  PitcherCareerBasicStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/17/25.
//

import SwiftUI

struct PitcherCareerBasicStatsView: View {
    var pitchingCareerStatsHelper: PitchingCareerStatsHelper?
    
    @State private var isSheetPresented: Bool = false
    @State private var selectedStat: String = ""
    
    var body: some View {
        VStack {
            if let careerStats = pitchingCareerStatsHelper?.pitchingCareerStats {
                VStack {
                    HStack {
                        Text("Standard")
                            .font(.parkFactorFontSubtitleNorwester)
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                    }
                    .padding(20)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 5) {
                        // First Row with stat category
                        Button(action: {
                            selectedStat = "pitcher_g"
                        }) {
                            Text("G")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                        }
                        Button(action: {
                            selectedStat = "pitcher_gs"
                        }) {
                            Text("GS")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                        }
                        Button(action: {
                            selectedStat = "pitcher_cg"
                        }) {
                            Text("CG")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                        }
                        Button(action: {
                            selectedStat = "pitcher_sv"
                        }) {
                            Text("SV")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                        }
                        Button(action: {
                            selectedStat = "pitcher_ip"
                        }) {
                            Text("IP")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                        }
                        
                        // Second Row with above categories
                        Text("\(careerStats[0].games ?? 0)")
                        Text("\(careerStats[0].gamesStarted ?? 0)")
                        Text("\(careerStats[0].completeGames ?? 0)")
                        Text("\(careerStats[0].saves ?? 0)")
                        Text(String(format: "%.1f", NSDecimalNumber(decimal: careerStats[0].inningsPitched ?? 0.0).doubleValue))
                        
                        // Row for spacing
                        Text("")
                        Text("")
                        Text("")
                        Text("")
                        Text("")
                        
                        // Fourth Row with more stat categories
                        Button(action: {
                            selectedStat = "pitcher_record"
                        }) {
                            Text("W-L")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                        }
                        Button(action: {
                            selectedStat = "pitcher_era"
                        }) {
                            Text("ERA")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                        }
                        Button(action: {
                            selectedStat = "pitcher_so"
                        }) {
                            Text("SO")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                        }
                        Button(action: {
                            selectedStat = "pitcher_walks"
                        }) {
                            Text("BB")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                        }
                        Button(action: {
                            selectedStat = "pitcher_whip"
                        }) {
                            Text("WHIP")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                        }
                        
                        // Second Row with above categories
                        Text("\(careerStats[0].wins ?? 0)-\(careerStats[0].losses ?? 0)")
                        Text(String(format: "%.2f", NSDecimalNumber(decimal: careerStats[0].era ?? 0.0).doubleValue))
                        Text("\(careerStats[0].strikeouts ?? 0)")
                        Text("\(careerStats[0].walks ?? 0)")
                        Text(String(format: "%.3f", NSDecimalNumber(decimal: careerStats[0].whip ?? 0.0).doubleValue))
                    }
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .background(Color.black)
                .cornerRadius(10)
                .onChange(of: selectedStat) {
                    isSheetPresented = true
                }
                .sheet(isPresented: $isSheetPresented) {
                    StatExplanationView(stat: selectedStat)
                }
            } else {
                VStack {
                    Text("Loading Career ...")
                        .foregroundStyle(Color.parkFactorPrimary)
                        .font(.parkFactorFontSubtitleNorwester)
                }
            }
        }
    }
}

#Preview {
    PitcherCareerBasicStatsView(pitchingCareerStatsHelper: PitchingCareerStatsHelper(pitchingCareerStats: [PitchingCareerStats(babip: 0.282, walks: 256, walkPercentage: 0.092, barrelPercentage: 0.082, completeGames: 0, changeupPercentage: 0.028, curveballPercentage: 0.229, era: 3.83, exitVelocity: 89.5, fastballPercentage: 0.531, cutterPercentage: 0, fip: 3.47, splitterPercentage: nil, games: 152, groundBallPercentage: 0.473, gamesStarted: 113, hardHitPercentage: 0.396, inningsPitched: 676.2, strikeoutPercentage: 0.311, strikeoutMinusWalkPercentage: 0.22, losses: 33, locationPlusChangeup: 106, locationPlusCurveball: 88, locationPlusFastball: 102, locationPlusCutter: nil, locationPlusOther: nil, locationPlusSplitter: nil, locationPlusKnuckleCurve: nil, locationPlusSinker: 91, locationPlusSlider: 102, locationPlus: 99, oSwingPercentage: 0.27, pitchPlusChangeup: 100, pitchPlusCurveball: 116, pitchPlusFastball: 115, pitchPlusCutter: nil, pitchPlusOther: nil, pitchPlusSplitter: nil, pitchPlusKnuckleCurve: nil, pitchPlusSinker: 103, pitchPlusSlider: 112, pitchingPlus: 114, sinkerPercentage: 0.046, siera: 3.42, sliderPercentage: 0.158, strikeouts: 863, saves: 0, stuffPlusChangeup: 86, stuffPlusCurveball: 124, stuffPlusFastball: 111, stuffPlusCutter: nil, stuffPlusOther: nil, stuffPlusSplitter: nil, stuffPlusKnuckleCurve: nil, stuffPlusSinker: 112, stuffPlusSlider: 101, stuffPlus: 111, wins: 40, war: 13.7, whip: 1.16, velocityChangeup: 90.5, velocityCurveball: 83, velocityFastball: 96.6, velocityCutter: 95.9, velocitySplitter: nil, velocitySinker: 95.4, velocitySlider: 89.5, expectedEra: nil, expectedFip: 3.22)]))
}
