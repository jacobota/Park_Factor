//
//  HittersPageView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/15/25.
//

import SwiftUI

struct HittersPageView: View {
    var player: Player
    var hitterStatsHelper: HitterStatsHelper
    var savedUser: SavedUser
    
    @State private var selectedTab: String = "Overview"
    
    let subTabs = ["Overview", "Season", "Career", "Visuals"]
    
    var body: some View {
        ZStack {
            Color.parkFactorSecondary.ignoresSafeArea()
            VStack(spacing: 0) {
                VStack {
                    HStack {
                        AsyncImage(url: URL(string: "https://img.mlbstatic.com/mlb-photos/image/upload/w_180,d_people:generic:headshot:silo:current.png,q_auto:best,f_auto/v1/people/\(player.keyMlbam ?? 1)/headshot/silo/current"), scale: 3) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 90)
                                .background(getTeamColor())
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(lineWidth: 0)
                                )
                        } placeholder: {
                            ProgressView()
                        }
                        .padding(.horizontal, 20)
                        VStack {
                            Text(player.fullName)
                                .foregroundStyle(Color.white)
                                .font(.parkFactorFontSubtitleNorwester)
                                .frame(width: 175, alignment: .leading)
                                .lineLimit(1)
                                .minimumScaleFactor(0.3)
                            Text("")
                            Text(hitterStatsHelper.hitterStats?.teamName ?? "")
                                .foregroundStyle(Color.white)
                                .font(.parkFactorFontTextNorwester)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Spacer()
                    }
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(subTabs, id: \.self) { subTab in
                                Button(action: {
                                    selectedTab = subTab
                                }) {
                                    Text(subTab)
                                        .font(Font.parkFactorFontTextNorwester)
                                        .foregroundColor(selectedTab == subTab ? Color.parkFactorPrimary : Color.gray)
                                        .padding()
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .background(Color.parkFactorSecondary)
                        .cornerRadius(8)
                    }
                    .frame(height: 25)
                    .padding()
                }
                .background(Color.parkFactorSecondary)
                
                if selectedTab == "Overview" {
                    HitterStatsOverviewView(player: player, hitterStatsHelper: hitterStatsHelper)
                } else if selectedTab == "Season" {
                    HitterSeasonStatsView(player: player, hitterStatsHelper: hitterStatsHelper)
                } else if selectedTab == "Career" {
                    HitterCareerStatsView(player: player)
                }
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom)
            .padding(.top, 10)
            
        }
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
    HittersPageView(player: Player(keyBbref: "troutmi01", keyFangraphs: 10155, keyMlbam: 545361, keyRetro: "troutm001", mlbPlayedFirst: 2011, mlbPlayedLast: 2024, nameFirst: "mike", nameLast: "trout"), hitterStatsHelper: HitterStatsHelper(hitterStats: HitterStats(average: 0.196, babip: 0.132, walkPercentage: 0.119, walkToStrikeoutRatio: 0.57, barrelPercentage: 0.182, bsr: 0.5, caughtStealing: 0, contactPercentage: 0.726, defensiveRunsSaved: -1, errors: 1, exitVelocity: 89.3, fieldingPercentage: 0.96, games: 15, hits: 11, homeRuns: 6, hardHitPercentage: 0.455, iso: 0.339, strikeoutPercentage: 0.209, outsAboveAverage: -2, onBasePercentage: 0.299, onBasePlusSlugging: 0.834, runs: 9, rbi: 14, sb: 1, sluggingPercentage: 0.536, swingPercentage: 0.461, team: "LAA", uzr: nil, war: 0.2, winProbabilityAdded: 0.32, zSwingPercentage: 0.625, maxExitVelocity: 107.9, sprintSpeed: 28.2, wOBA: 0.345, wRCPlus: 125, wSB: 0.1, xBA: 0.269, xSlg: 0.665, xWOBA: 0.414)), savedUser: SavedUser())
}
