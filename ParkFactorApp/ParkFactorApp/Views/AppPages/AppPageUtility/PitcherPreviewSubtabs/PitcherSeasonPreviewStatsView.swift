//
//  PitcherSeasonPreviewStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/17/25.
//

import SwiftUI

struct PitcherSeasonPreviewStatsView: View {
    var player: Player
    var pitchingPreviewStatsHelper: PitchingPreviewStatsHelper
    
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            ScrollView {
                VStack {
                    PlayerOverviewCardView(player: player)
                        .padding(.bottom, 10)
                    
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
                            Text("G")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                            Text("GS")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                            Text("IP")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                            Text("ERA")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                            Text("SV")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                            
                            // Second Row with above categories
                            Text("\(pitchingPreviewStatsHelper.pitchingPreviewStats?[0].games ?? 0)")
                            Text("\(pitchingPreviewStatsHelper.pitchingPreviewStats?[0].gamesStarted ?? 0)")
                            Text(String(format: "%.1f", NSDecimalNumber(decimal: pitchingPreviewStatsHelper.pitchingPreviewStats?[0].inningsPitched ?? 0.0).doubleValue))
                            Text(String(format: "%.2f", NSDecimalNumber(decimal: pitchingPreviewStatsHelper.pitchingPreviewStats?[0].era ?? 0.0).doubleValue))
                            Text("\(pitchingPreviewStatsHelper.pitchingPreviewStats?[0].saves ?? 0)")
                            
                            // Row for spacing
                            Text("")
                            Text("")
                            Text("")
                            Text("")
                            Text("")
                            
                            // Fourth Row with more stat categories
                            Text("W - L")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                            Text("H")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                            Text("SO")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                            Text("BB")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                            Text("K/BB")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                            
                            // Second Row with above categories
                            Text("\(pitchingPreviewStatsHelper.pitchingPreviewStats?[0].wins ?? 0) - \(pitchingPreviewStatsHelper.pitchingPreviewStats?[0].losses ?? 0)")
                            Text("\(pitchingPreviewStatsHelper.pitchingPreviewStats?[0].hits ?? 0)")
                            Text("\(pitchingPreviewStatsHelper.pitchingPreviewStats?[0].strikeouts ?? 0)")
                            Text("\(pitchingPreviewStatsHelper.pitchingPreviewStats?[0].walks ?? 0)")
                            Text(String(format: "%.2f", NSDecimalNumber(decimal: pitchingPreviewStatsHelper.pitchingPreviewStats?[0].strikeoutsToWalksRatio ?? 0.0).doubleValue))
                            
                            // Row for spacing
                            Text("")
                            Text("")
                            Text("")
                            Text("")
                            Text("")
                            
                            // fifth Row with more stat categories
                            Text("K/9")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                            Text("GB/FB")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                            Text("Strike%")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                            Text("WHIP")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                            Text("BAA")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                            
                            // Second Row with above categories
                            Text(String(format: "%.2f", NSDecimalNumber(decimal: pitchingPreviewStatsHelper.pitchingPreviewStats?[0].strikeoutsPerNine ?? 0.0).doubleValue))
                            Text(String(format: "%.2f", NSDecimalNumber(decimal: pitchingPreviewStatsHelper.pitchingPreviewStats?[0].groundBallToFlyBallRatio ?? 0.0).doubleValue))
                            Text(String(format: "%.2f", NSDecimalNumber(decimal: pitchingPreviewStatsHelper.pitchingPreviewStats?[0].strikePercentage ?? 0.0).doubleValue))
                            Text(String(format: "%.3f", NSDecimalNumber(decimal: pitchingPreviewStatsHelper.pitchingPreviewStats?[0].whip ?? 0.0).doubleValue))
                            Text(String(format: "%.3f", NSDecimalNumber(decimal: pitchingPreviewStatsHelper.pitchingPreviewStats?[0].babip ?? 0.0).doubleValue))
                        }
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                    .background(Color.black)
                    .cornerRadius(10)
                }
                .padding(20)
            }
        }
    }
}

#Preview {
    PitcherSeasonPreviewStatsView(player: Player(keyBbref: "schwesp01", keyFangraphs: -1, keyMlbam: 680885, keyRetro: "schws001", mlbPlayedFirst: 2024, mlbPlayedLast: 2025, nameFirst: "spencer", nameLast: "schwellenbach"), pitchingPreviewStatsHelper: PitchingPreviewStatsHelper(pitchingPreviewStats: [PitchingPreviewStats(days: 1, doubles: 3, triples: 0, atBats: 88, age: 25, babip: 0.206, walks: 5, battersFaced: 94, caughtStealing: 1, earnedRuns: 7, era: 2.55, games: 4, groundBallToFlyBallRatio: 0.55, gdp: 2, gamesStarted: 4, hits: 16, hitByPitch: 1, homeRuns: 3, intentionalWalks: 1, inningsPitched: 24.2, losses: 1, lineDrivePercentage: 0.24, level: "Maj-NL", name: "Spencer Schwellenbach", putouts: 0, popupPercentage: 0.02, pitches: 356, runs: 7, stolenBases: 0, sacrificeFlies: 0, strikeouts: 22, strikeoutsToWalksRatio: 4.4, strikeoutsPerNine: 8, saves: nil, strikeLookingPercentage: 0.14, strikeSwingingPercentage: 0.15, strikePercentage: 0.68, team: "Atlanta", wins: 1, whip: 0.851, mlbID: "680885")]))
}
