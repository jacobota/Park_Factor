//
//  TeamHittingDisplayStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/18/25.
//

import SwiftUI

struct TeamHittingDisplayStatsView: View {
    var teamStats: TeamStats
    
    @State private var isSheetPresented: Bool = false
    @State private var selectedStat: String = ""
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Standard - Hitting")
                        .font(.parkFactorFontSubtitleNorwester)
                        .foregroundStyle(Color.white)
                    
                    Spacer()
                }
                .padding(20)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 5) {
                    // First Row with stat category
                    Button(action: {
                        selectedStat = "teams_hitting_ba"
                    }) {
                        Text("BA")
                            .font(.parkFactorFontSmallText)
                            .foregroundColor(Color.gray)
                    }
                    Button(action: {
                        selectedStat = "teams_hitting_hits"
                    }) {
                        Text("H")
                            .font(.parkFactorFontSmallText)
                            .foregroundColor(Color.gray)
                    }
                    Button(action: {
                        selectedStat = "teams_hitting_hr"
                    }) {
                        Text("HR")
                            .font(.parkFactorFontSmallText)
                            .foregroundColor(Color.gray)
                    }
                    Button(action: {
                        selectedStat = "teams_hitting_runs"
                    }) {
                        Text("R")
                            .font(.parkFactorFontSmallText)
                            .foregroundColor(Color.gray)
                    }
                    
                    
                    // Second Row with above categories
                    Text(String(format: "%.3f", NSDecimalNumber(decimal: teamStats.teamBatting?[0].average ?? 0).doubleValue))
                    Text("\(teamStats.teamBatting?[0].hits ?? 0)")
                    Text("\(teamStats.teamBatting?[0].hr ?? 0)")
                    Text("\(teamStats.teamBatting?[0].runs ?? 0)")
                    
                    Text("")
                    Text("")
                    Text("")
                    Text("")
                    
                    Button(action: {
                        selectedStat = "teams_hitting_strikeouts"
                    }) {
                        Text("K")
                            .font(.parkFactorFontSmallText)
                            .foregroundColor(Color.gray)
                    }
                    Button(action: {
                        selectedStat = "teams_hitting_walks"
                    }) {
                        Text("BB")
                            .font(.parkFactorFontSmallText)
                            .foregroundColor(Color.gray)
                    }
                    Button(action: {
                        selectedStat = "teams_hitting_obp"
                    }) {
                        Text("OBP")
                            .font(.parkFactorFontSmallText)
                            .foregroundColor(Color.gray)
                    }
                    Button(action: {
                        selectedStat = "teams_hitting_slg"
                    }) {
                        Text("SLG")
                            .font(.parkFactorFontSmallText)
                            .foregroundColor(Color.gray)
                    }
                    
                    Text("\(teamStats.teamBatting?[0].strikeout ?? 0)")
                    Text("\(teamStats.teamBatting?[0].walks ?? 0)")
                    Text(String(format: "%.3f", NSDecimalNumber(decimal: teamStats.teamBatting?[0].obp ?? 0).doubleValue))
                    Text(String(format: "%.3f", NSDecimalNumber(decimal: teamStats.teamBatting?[0].slg ?? 0).doubleValue))
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
                    Text("Advanced - Hitting")
                        .font(.parkFactorFontSubtitleNorwester)
                        .foregroundStyle(Color.white)
                    
                    Spacer()
                }
                .padding(20)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 5) {
                    // First Row with stat category
                    Button(action: {
                        selectedStat = "teams_hitting_war"
                    }) {
                        Text("WAR")
                            .font(.parkFactorFontSmallText)
                            .foregroundColor(Color.gray)
                    }
                    Button(action: {
                        selectedStat = "teams_hitting_ops"
                    }) {
                        Text("OPS")
                            .font(.parkFactorFontSmallText)
                            .foregroundColor(Color.gray)
                    }
                    Button(action: {
                        selectedStat = "teams_hitting_woba"
                    }) {
                        Text("wOBA")
                            .font(.parkFactorFontSmallText)
                            .foregroundColor(Color.gray)
                    }
                    Button(action: {
                        selectedStat = "teams_hitting_wrcplus"
                    }) {
                        Text("wRC+")
                            .font(.parkFactorFontSmallText)
                            .foregroundColor(Color.gray)
                    }
                    
                    // Second Row with above categories
                    Text(String(format: "%.1f", NSDecimalNumber(decimal: teamStats.teamBatting?[0].war ?? 0).doubleValue))
                    Text(String(format: "%.3f", NSDecimalNumber(decimal: teamStats.teamBatting?[0].ops ?? 0).doubleValue))
                    Text(String(format: "%.3f", NSDecimalNumber(decimal: teamStats.teamBatting?[0].woba ?? 0).doubleValue))
                    Text("\(teamStats.teamBatting?[0].wrcPlus ?? 0)")
                    
                    Text("")
                    Text("")
                    Text("")
                    Text("")
                    
                    Button(action: {
                        selectedStat = "teams_hitting_babip"
                    }) {
                        Text("BABIP")
                            .font(.parkFactorFontSmallText)
                            .foregroundColor(Color.gray)
                    }
                    Button(action: {
                        selectedStat = "teams_hitting_iso"
                    }) {
                        Text("ISO")
                            .font(.parkFactorFontSmallText)
                            .foregroundColor(Color.gray)
                    }
                    Button(action: {
                        selectedStat = "teams_hitting_bbpercent"
                    }) {
                        Text("BB%")
                            .font(.parkFactorFontSmallText)
                            .foregroundColor(Color.gray)
                    }
                    Button(action: {
                        selectedStat = "teams_hitting_kpercent"
                    }) {
                        Text("K%")
                            .font(.parkFactorFontSmallText)
                            .foregroundColor(Color.gray)
                    }
                    
                    Text(String(format: "%.3f", NSDecimalNumber(decimal: teamStats.teamBatting?[0].babip ?? 0).doubleValue))
                    Text(String(format: "%.3f", NSDecimalNumber(decimal: teamStats.teamBatting?[0].iso ?? 0).doubleValue))
                    Text(String(format: "%.3f", NSDecimalNumber(decimal: teamStats.teamBatting?[0].bbPercentage ?? 0).doubleValue))
                    Text(String(format: "%.3f", NSDecimalNumber(decimal: teamStats.teamBatting?[0].kPercentage ?? 0).doubleValue))
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
                    Text("Fielding")
                        .font(.parkFactorFontSubtitleNorwester)
                        .foregroundStyle(Color.white)
                    
                    Spacer()
                }
                .padding(20)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 5) {
                    // First Row with stat category
                    Button(action: {
                        selectedStat = "teams_fielding_drs"
                    }) {
                        Text("DRS")
                            .foregroundColor(Color.gray)
                    }
                    Button(action: {
                        selectedStat = "teams_fielding_errors"
                    }) {
                        Text("E")
                            .foregroundColor(Color.gray)
                    }
                    Button(action: {
                        selectedStat = "teams_fielding_fieldpercent"
                    }) {
                        Text("FP")
                            .foregroundColor(Color.gray)
                    }
                    Button(action: {
                        selectedStat = "teams_fielding_oaa"
                    }) {
                        Text("OAA")
                            .foregroundColor(Color.gray)
                    }
                    
                    // Second Row with above categories
                    Text("\(teamStats.teamFielding?[0].drs ?? 0)")
                    Text("\(teamStats.teamFielding?[0].errors ?? 0)")
                    Text(String(format: "%.3f", NSDecimalNumber(decimal: teamStats.teamFielding?[0].fieldingPercentage ?? 0).doubleValue))
                    Text("\(teamStats.teamFielding?[0].oaa ?? 0)")                    
                }
                .font(.parkFactorFontText)
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
}

#Preview {
    TeamHittingDisplayStatsView(teamStats: TeamStats(teamBatting: [TeamBatting(average: 0.23, age: 29, babip: 0.262, walks: 45, bbPercentage: 0.067, bbToK: 0.27, bsr: 0.8, cs: 2, hits: 140, hr: 30, iso: 0.189, kPercentage: 0.245, obp: 0.292, ops: 0.711, runs: 79, sb: 9, slg: 0.419, strikeout: 165, war: 2, woba: 0.311, wrcPlus: 102, wsb: -0.2)], teamFielding: [TeamFielding(drs: -11, errors: 11, fieldingPercentage: 0.983, oaa: 1)], teamPitching: [TeamPitching(average: 0.251, babip: 0.282, walks: 70, bbPercentage: 0.104, era: 4.76, fip: 4.9, gbPercentage: 0.437, hitsAllowed: 150, hrPerFb: 0.143, kPercentage: 0.195, kMinusBbPercentage: 0.091, losses: 9, lobPercentage: 0.714, locationPlus: 101, pitchingPlus: 97, runs: 90, siera: 4.33, strikeouts: 131, saves: 6, stuffPlus: 97, wins: 9, war: 0.2, whip: 1.4, vfaPi: 93.6, xfip: 4.41)]))
}
