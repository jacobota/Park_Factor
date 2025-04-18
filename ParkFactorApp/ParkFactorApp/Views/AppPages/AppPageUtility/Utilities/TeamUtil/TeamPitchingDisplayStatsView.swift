//
//  TeamPitchingDisplayStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/18/25.
//

import SwiftUI

struct TeamPitchingDisplayStatsView: View {
    var teamStats: TeamStats
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Standard - Pitching")
                        .font(.parkFactorFontSubtitleNorwester)
                        .foregroundStyle(Color.white)
                    
                    Spacer()
                }
                .padding(20)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 5) {
                    // First Row with stat category
                    Text("ERA")
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(Color.gray)
                    Text("RA")
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(Color.gray)
                    Text("BAA")
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(Color.gray)
                    Text("H")
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(Color.gray)
                    
                    // Second Row with above categories
                    Text(String(format: "%.2f", NSDecimalNumber(decimal: teamStats.teamPitching?[0].era ?? 0).doubleValue))
                    Text("\(teamStats.teamPitching?[0].runs ?? 0)")
                    Text(String(format: "%.3f", NSDecimalNumber(decimal: teamStats.teamPitching?[0].average ?? 0).doubleValue))
                    Text("\(teamStats.teamPitching?[0].hitsAllowed ?? 0)")
                    
                    Text("")
                    Text("")
                    Text("")
                    Text("")
                    
                    Text("SO")
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(Color.gray)
                    Text("BB")
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(Color.gray)
                    Text("WHIP")
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(Color.gray)
                    Text("FB Velo")
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(Color.gray)
                    
                    Text("\(teamStats.teamPitching?[0].strikeouts ?? 0)")
                    Text("\(teamStats.teamPitching?[0].walks ?? 0)")
                    Text(String(format: "%.3f", NSDecimalNumber(decimal: teamStats.teamPitching?[0].whip ?? 0).doubleValue))
                    Text(String(format: "%.1f", NSDecimalNumber(decimal: teamStats.teamPitching?[0].vfaPi ?? 0).doubleValue))
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
                    Text("Advanced - Pitching")
                        .font(.parkFactorFontSubtitleNorwester)
                        .foregroundStyle(Color.white)
                    
                    Spacer()
                }
                .padding(20)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 5) {
                    // First Row with stat category
                    Text("WAR")
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(Color.gray)
                    Text("FIP")
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(Color.gray)
                    Text("xFIP")
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(Color.gray)
                    Text("SIERA")
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(Color.gray)
                    
                    // Second Row with above categories
                    Text(String(format: "%.1f", NSDecimalNumber(decimal: teamStats.teamPitching?[0].war ?? 0).doubleValue))
                    Text(String(format: "%.2f", NSDecimalNumber(decimal: teamStats.teamPitching?[0].fip ?? 0).doubleValue))
                    Text(String(format: "%.2f", NSDecimalNumber(decimal: teamStats.teamPitching?[0].xfip ?? 0).doubleValue))
                    Text(String(format: "%.3f", NSDecimalNumber(decimal: teamStats.teamPitching?[0].siera ?? 0).doubleValue))
                    
                    Text("")
                    Text("")
                    Text("")
                    Text("")
                    
                    Text("BB%")
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(Color.gray)
                    Text("K%")
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(Color.gray)
                    Text("K-BB%")
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(Color.gray)
                    Text("BABIP")
                        .font(.parkFactorFontSmallText)
                        .foregroundColor(Color.gray)
                    
                    Text(String(format: "%.3f", NSDecimalNumber(decimal: teamStats.teamPitching?[0].bbPercentage ?? 0).doubleValue))
                    Text(String(format: "%.3f", NSDecimalNumber(decimal: teamStats.teamPitching?[0].kPercentage ?? 0).doubleValue))
                    Text(String(format: "%.3f", NSDecimalNumber(decimal: teamStats.teamPitching?[0].kMinusBbPercentage ?? 0).doubleValue))
                    Text(String(format: "%.3f", NSDecimalNumber(decimal: teamStats.teamPitching?[0].babip ?? 0).doubleValue))
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
                    Text("\(teamStats.teamPitching?[0].stuffPlus ?? 0)")
                    Text("\(teamStats.teamPitching?[0].pitchingPlus ?? 0)")
                    Text("\(teamStats.teamPitching?[0].locationPlus ?? 0)")
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

#Preview {
    TeamPitchingDisplayStatsView(teamStats: TeamStats(teamBatting: [TeamBatting(average: 0.23, age: 29, babip: 0.262, walks: 45, bbPercentage: 0.067, bbToK: 0.27, bsr: 0.8, cs: 2, hits: 140, hr: 30, iso: 0.189, kPercentage: 0.245, obp: 0.292, ops: 0.711, runs: 79, sb: 9, slg: 0.419, strikeout: 165, war: 2, woba: 0.311, wrcPlus: 102, wsb: -0.2)], teamFielding: [TeamFielding(drs: -11, errors: 11, fieldingPercentage: 0.983, oaa: 1)], teamPitching: [TeamPitching(average: 0.251, babip: 0.282, walks: 70, bbPercentage: 0.104, era: 4.76, fip: 4.9, gbPercentage: 0.437, hitsAllowed: 150, hrPerFb: 0.143, kPercentage: 0.195, kMinusBbPercentage: 0.091, losses: 9, lobPercentage: 0.714, locationPlus: 101, pitchingPlus: 97, runs: 90, siera: 4.33, strikeouts: 131, saves: 6, stuffPlus: 97, wins: 9, war: 0.2, whip: 1.4, vfaPi: 93.6, xfip: 4.41)]))
}
