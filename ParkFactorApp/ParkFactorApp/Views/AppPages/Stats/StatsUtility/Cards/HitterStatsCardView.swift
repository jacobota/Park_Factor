//
//  HitterStatsCardView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/14/25.
//

import SwiftUI

struct HitterStatsCardView: View {
    var savedUser: SavedUser
    var player: Player
    var isFollowing: Bool
    var hitterStatsHelper: HitterStatsHelper
    
    var body: some View {
        VStack {
            HStack {
                NavigationLink(destination: PlayerPageView(player: player, savedUser: savedUser)) {
                    AsyncImage(url: URL(string: "https://img.mlbstatic.com/mlb-photos/image/upload/w_180,d_people:generic:headshot:silo:current.png,q_auto:best,f_auto/v1/people/\(player.keyMlbam ?? 1)/headshot/silo/current"), scale: 3) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .background(getTeamColor())
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(lineWidth: 0)
                            )
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Spacer()
                    
                    Text(player.fullName)
                        .font(.parkFactorFontSubtitleNorwester)
                        .foregroundStyle(Color.white)
                        .frame(width: 175, alignment: .leading)
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    if isFollowing {
                        Image(systemName: "star.circle")
                            .foregroundStyle(Color.parkFactorPrimary)
                            .font(.system(size: 24))
                    }
                }
            }
            .padding(20)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 10) {
                // Top Row with stats
                Text("G")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("BA")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("HR")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("RBI")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("OPS")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("WAR")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                
                // Bottom Row with stats 
                Text("\(hitterStatsHelper.hitterStats?.games ?? 0)")
                Text(String(format: "%.3f", NSDecimalNumber(decimal: hitterStatsHelper.hitterStats?.average ?? 0.0).doubleValue))
                Text("\(hitterStatsHelper.hitterStats?.homeRuns ?? 0 )")
                Text("\(hitterStatsHelper.hitterStats?.rbi ?? 0)")
                Text(String(format: "%.3f", NSDecimalNumber(decimal: hitterStatsHelper.hitterStats?.onBasePlusSlugging ?? 0.0).doubleValue))
                Text(String(format: "%.1f", NSDecimalNumber(decimal: hitterStatsHelper.hitterStats?.war ?? 0.0).doubleValue))
            }
            .font(.parkFactorFontSubSectionText)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color.black)
        .cornerRadius(10)
    }
    
    private func getTeamColor() -> Color {
        switch hitterStatsHelper.hitterStats?.team {
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
    HitterStatsCardView(savedUser: SavedUser(), player: Player(keyBbref: "troutmi01", keyFangraphs: 10155, keyMlbam: 545361, keyRetro: "troum001", mlbPlayedFirst: 2011, mlbPlayedLast: 2025, nameFirst: "mike", nameLast: "trout"), isFollowing: true, hitterStatsHelper: HitterStatsHelper(hitterStats: HitterStats(average: 0.196, babip: 0.132, walkPercentage: 0.119, walkToStrikeoutRatio: 0.57, barrelPercentage: 0.182, bsr: 0.5, caughtStealing: 0, contactPercentage: 0.726, defensiveRunsSaved: -1, errors: 1, exitVelocity: 89.3, fieldingPercentage: 0.96, games: 15, hits: 11, homeRuns: 6, hardHitPercentage: 0.455, iso: 0.339, strikeoutPercentage: 0.209, outsAboveAverage: -2, onBasePercentage: 0.299, onBasePlusSlugging: 0.834, runs: 9, rbi: 14, sb: 1, sluggingPercentage: 0.536, swingPercentage: 0.461, team: "LAA", uzr: nil, war: 0.2, winProbabilityAdded: 0.32, zSwingPercentage: 0.625, maxExitVelocity: 107.9, sprintSpeed: 28.2, wOBA: 0.345, wRCPlus: 125, wSB: 0.1, xBA: 0.269, xSlg: 0.665, xWOBA: 0.414)))
}
