//
//  PitcherBasicStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/17/25.
//

import SwiftUI

struct PitcherBasicStatsView: View {
    var pitchingStatsHelper: PitchingStatsHelper
    
    @State private var isSheetPresented: Bool = false
    @State private var selectedStat: String = ""
    
    var body: some View {
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
                Text("\(pitchingStatsHelper.pitchingStats?[0].games ?? 0)")
                Text("\(pitchingStatsHelper.pitchingStats?[0].gamesStarted ?? 0)")
                Text("\(pitchingStatsHelper.pitchingStats?[0].completeGames ?? 0)")
                Text("\(pitchingStatsHelper.pitchingStats?[0].saves ?? 0)")
                Text(String(format: "%.1f", NSDecimalNumber(decimal: pitchingStatsHelper.pitchingStats?[0].inningsPitched ?? 0.0).doubleValue))
                
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
                Text("\(pitchingStatsHelper.pitchingStats?[0].wins ?? 0)-\(pitchingStatsHelper.pitchingStats?[0].losses ?? 0)")
                Text(String(format: "%.2f", NSDecimalNumber(decimal: pitchingStatsHelper.pitchingStats?[0].era ?? 0.0).doubleValue))
                Text("\(pitchingStatsHelper.pitchingStats?[0].strikeouts ?? 0)")
                Text("\(pitchingStatsHelper.pitchingStats?[0].walks ?? 0)")
                Text(String(format: "%.3f", NSDecimalNumber(decimal: pitchingStatsHelper.pitchingStats?[0].whip ?? 0.0).doubleValue))
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
    }
}

#Preview {
    PitcherBasicStatsView(pitchingStatsHelper: PitchingStatsHelper(pitchingStats: [PitchingStats(babip: 0.185, walks: 9, walkPercentage: 0.161, barrelPercentage: 0.069, completeGames: 0, changeupPercentage: nil, curveballPercentage: 0.232, era: 4.85, exitVelocity: 86.5, fastballPercentage: 0.494, cutterPercentage: nil, fip: 4.69, splitterPercentage: nil, games: 3, groundBallPercentage: 0.379, gamesStarted: 3, hardHitPercentage: 0.276, inningsPitched: 13, strikeoutPercentage: 0.304, strikeoutMinusWalkPercentage: 0.143, losses: 0, locationPlusChangeup: nil, locationPlusCurveball: 78, locationPlusFastball: 83, locationPlusCutter: nil, locationPlusOther: nil, locationPlusSplitter: nil, locationPlusKnuckleCurve: nil, locationPlusSinker: 95, locationPlusSlider: 87, locationPlus: 84, oSwingPercentage: 0.174, pitchPlusChangeup: nil, pitchPlusCurveball: 75, pitchPlusFastball: 91, pitchPlusCutter: nil, pitchPlusOther: nil, pitchPlusSplitter: nil, pitchPlusKnuckleCurve: nil, pitchPlusSinker: 98, pitchPlusSlider: 87, pitchingPlus: 87, sinkerPercentage: 0.084, siera: 4.03, sliderPercentage: 0.19, strikeouts: 17, saves: 0, stuffPlusChangeup: nil, stuffPlusCurveball: 92, stuffPlusFastball: 103, stuffPlusCutter: nil, stuffPlusOther: nil, stuffPlusSplitter: nil, stuffPlusKnuckleCurve: nil, stuffPlusSinker: 93, stuffPlusSlider: 89, stuffPlus: 97, team: "LAD", wins: 1, war: 0.1, whip: 1.23, velocityChangeup: nil, velocityCurveball: 82.1, velocityFastball: 95.6, velocityCutter: nil, velocitySplitter: nil, velocitySinker: 95.5, velocitySlider: 90.2, expectedEra: 3.53, expectedFip: 4.12)]))
}
