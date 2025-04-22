//
//  HitterSeasonPreviewStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/17/25.
//

import SwiftUI

struct HitterSeasonPreviewStatsView: View {
    var player: Player
    var hitterPreviewStatsHelper: HitterPreviewStatsHelper
    
    @State private var isSheetPresented: Bool = false
    @State private var selectedStat: String = ""
    
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
                            Button(action: {
                                selectedStat = "hitter_g"
                            }) {
                                Text("G")
                                    .font(.parkFactorFontSmallText)
                                    .foregroundColor(Color.gray)
                            }
                            Button(action: {
                                selectedStat = "hitter_ba"
                            }) {
                                Text("BA")
                                    .font(.parkFactorFontSmallText)
                                    .foregroundColor(Color.gray)
                            }
                            Button(action: {
                                selectedStat = "hitter_obp"
                            }) {
                                Text("OBP")
                                    .font(.parkFactorFontSmallText)
                                    .foregroundColor(Color.gray)
                            }
                            Button(action: {
                                selectedStat = "hitter_slg"
                            }) {
                                Text("SLG")
                                    .font(.parkFactorFontSmallText)
                                    .foregroundColor(Color.gray)
                            }
                            Button(action: {
                                selectedStat = "hitter_ops"
                            }) {
                                Text("OPS")
                                    .font(.parkFactorFontSmallText)
                                    .foregroundColor(Color.gray)
                            }
                            
                            // Second Row with above categories
                            Text("\(hitterPreviewStatsHelper.hitterPreviewStats?[0].games ?? -1)")
                            Text(String(format: "%.3f", NSDecimalNumber(decimal: hitterPreviewStatsHelper.hitterPreviewStats?[0].battingAverage ?? 0.0).doubleValue))
                            Text(String(format: "%.3f", NSDecimalNumber(decimal: hitterPreviewStatsHelper.hitterPreviewStats?[0].onBasePercentage ?? 0.0).doubleValue))
                            Text(String(format: "%.3f", NSDecimalNumber(decimal: hitterPreviewStatsHelper.hitterPreviewStats?[0].sluggingPercentage ?? 0.0).doubleValue))
                            Text(String(format: "%.3f", NSDecimalNumber(decimal: hitterPreviewStatsHelper.hitterPreviewStats?[0].onBasePlusSlugging ?? 0.0).doubleValue))
                            
                            // Row for spacing
                            Text("")
                            Text("")
                            Text("")
                            Text("")
                            Text("")
                            
                            // Fourth Row with more stat categories
                            Button(action: {
                                selectedStat = "hitter_ab"
                            }) {
                                Text("AB")
                                    .font(.parkFactorFontSmallText)
                                    .foregroundColor(Color.gray)
                            }
                            Button(action: {
                                selectedStat = "hitter_h"
                            }) {
                                Text("H")
                                    .font(.parkFactorFontSmallText)
                                    .foregroundColor(Color.gray)
                            }
                            Button(action: {
                                selectedStat = "hitter_double"
                            }) {
                                Text("2B")
                                    .font(.parkFactorFontSmallText)
                                    .foregroundColor(Color.gray)
                            }
                            Button(action: {
                                selectedStat = "hitter_triple"
                            }) {
                                Text("3B")
                                    .font(.parkFactorFontSmallText)
                                    .foregroundColor(Color.gray)
                            }
                            Button(action: {
                                selectedStat = "hitter_hr"
                            }) {
                                Text("HR")
                                    .font(.parkFactorFontSmallText)
                                    .foregroundColor(Color.gray)
                            }
                            
                            // Second Row with above categories
                            Text("\(hitterPreviewStatsHelper.hitterPreviewStats?[0].atBats ?? -1)")
                            Text("\(hitterPreviewStatsHelper.hitterPreviewStats?[0].hits ?? -1)")
                            Text("\(hitterPreviewStatsHelper.hitterPreviewStats?[0].doubles ?? -1)")
                            Text("\(hitterPreviewStatsHelper.hitterPreviewStats?[0].triples ?? -1)")
                            Text("\(hitterPreviewStatsHelper.hitterPreviewStats?[0].homeRuns ?? -1)")
                            
                            // Row for spacing
                            Text("")
                            Text("")
                            Text("")
                            Text("")
                            Text("")
                            
                            // Fifth Row for more categories
                            Button(action: {
                                selectedStat = "hitter_runs"
                            }) {
                                Text("R")
                                    .font(.parkFactorFontSmallText)
                                    .foregroundColor(Color.gray)
                            }
                            Button(action: {
                                selectedStat = "hitter_rbi"
                            }) {
                                Text("RBI")
                                    .font(.parkFactorFontSmallText)
                                    .foregroundColor(Color.gray)
                            }
                            Button(action: {
                                selectedStat = "hitter_sb"
                            }) {
                                Text("SB")
                                    .font(.parkFactorFontSmallText)
                                    .foregroundColor(Color.gray)
                            }
                            Button(action: {
                                selectedStat = "hitter_sacfly"
                            }) {
                                Text("SF")
                                    .font(.parkFactorFontSmallText)
                                    .foregroundColor(Color.gray)
                            }
                            Button(action: {
                                selectedStat = "hitter_bb"
                            }) {
                                Text("BB")
                                    .font(.parkFactorFontSmallText)
                                    .foregroundColor(Color.gray)
                            }
                            
                            Text("\(hitterPreviewStatsHelper.hitterPreviewStats?[0].runs ?? -1)")
                            Text("\(hitterPreviewStatsHelper.hitterPreviewStats?[0].rbi ?? -1)")
                            Text("\(hitterPreviewStatsHelper.hitterPreviewStats?[0].sb ?? -1)")
                            Text("\(hitterPreviewStatsHelper.hitterPreviewStats?[0].sacrificeFlies ?? -1)")
                            Text("\(hitterPreviewStatsHelper.hitterPreviewStats?[0].walks ?? -1)")
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
                .onChange(of: selectedStat) {
                    isSheetPresented = true
                }
                .sheet(isPresented: $isSheetPresented) {
                    StatExplanationView(stat: selectedStat)
                }
            }
        }
    }
}

#Preview {
    HitterSeasonPreviewStatsView(player: Player(keyBbref: "smithca07", keyFangraphs: -1, keyMlbam: 701358, keyRetro: nil, mlbPlayedFirst: 2025, mlbPlayedLast: 2025, nameFirst: "cam", nameLast: "smith"), hitterPreviewStatsHelper: HitterPreviewStatsHelper(hitterPreviewStats: [HitterPreviewStats(days: 0, doubles: 0, triples: 1, atBats: 45, age: 22, battingAverage: 0.2, walks: 4, caughtStealing: 0, games: 14, gdp: 0, hits: 9, hitByPitch: 1, homeRuns: 1, intentionalWalks: 0, level: "Maj-AL", name: "Cam Smith", onBasePercentage: 0.28, onBasePlusSlugging: 0.591, pa: 50, runs: 4, rbi: 6, sb: 1, sacrificeFlies: 0, sacrificeHits: 0, sluggingPercentage: 0.311, strikeouts: 14, team: "Houston", mlbID: 701358)]))
}
