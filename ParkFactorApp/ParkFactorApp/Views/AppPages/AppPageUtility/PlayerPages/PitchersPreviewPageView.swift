//
//  PitchersPreviewPageView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/15/25.
//

import SwiftUI

struct PitchersPreviewPageView: View {
    var player: Player
    var pitchingPreviewStatsHelper: PitchingPreviewStatsHelper
    var savedUser: SavedUser
    
    @State private var selectedTab: String = "Season"
    
    let subTabs = ["Season"]
    
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
                        VStack(alignment: .leading) {
                            Text(player.fullName)
                                .foregroundStyle(Color.white)
                                .font(.parkFactorFontSubtitleNorwester)
                                .frame(width: 175, alignment: .leading)
                                .lineLimit(1)
                                .minimumScaleFactor(0.3)
                            Text("")
                            Text(pitchingPreviewStatsHelper.pitchingPreviewStats?[0].teamName ?? "")
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
                
                if selectedTab == "Season" {
                    PitcherSeasonPreviewStatsView(player: player, pitchingPreviewStatsHelper: pitchingPreviewStatsHelper)
                }
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom)
            .padding(.top, 10)
            
        }
    }
    
    private func getTeamColor() -> Color {
        if pitchingPreviewStatsHelper.pitchingPreviewStats?[0].level == "Maj-AL" {
            switch pitchingPreviewStatsHelper.pitchingPreviewStats?[0].team {
            case "Los Angeles":
                return Color(red: 0.72, green: 0.0, blue: 0.13)
            case "Seattle":
                return Color(red: 0.0, green: 0.27, blue: 0.36)
            case "Texas":
                return Color(red: 0.0, green: 0.24, blue: 0.58)
            case "Houston":
                return Color(red: 0.0, green: 0.18, blue: 0.32)
            case "Oakland":
                return Color(red: 0.0, green: 0.47, blue: 0.29)
            case "Chicago":
                return Color(red: 0.1, green: 0.1, blue: 0.1)
            case "Minnesota":
                return Color(red: 0.0, green: 0.2, blue: 0.4)
            case "Kansas City":
                return Color(red: 0.0, green: 0.38, blue: 0.75)
            case "Detroit":
                return Color(red: 0.0, green: 0.16, blue: 0.31)
            case "Cleveland":
                return Color(red: 0.6, green: 0.0, blue: 0.0)
            case "New York":
                return Color(red: 0.12, green: 0.16, blue: 0.29)
            case "Boston":
                return Color(red: 0.51, green: 0.09, blue: 0.13)
            case "Tampa Bay":
                return Color(red: 0.0, green: 0.2, blue: 0.42)
            case "Toronto":
                return Color(red: 0.0, green: 0.4, blue: 0.8)
            case "Baltimore":
                return Color(red: 1.0, green: 0.38, blue: 0.0)
            default:
                return Color.white
            }
        } else if pitchingPreviewStatsHelper.pitchingPreviewStats?[0].level == "Maj-NL" {
            switch pitchingPreviewStatsHelper.pitchingPreviewStats?[0].team {
            case "San Francisco":
                return Color(red: 0.84, green: 0.38, blue: 0.13)
            case "Los Angeles":
                return Color(red: 0.0, green: 0.38, blue: 0.67)
            case "San Diego":
                return Color(red: 0.38, green: 0.29, blue: 0.0)
            case "Arizona":
                return Color(red: 0.45, green: 0.0, blue: 0.09)
            case "Colorado":
                return Color(red: 0.31, green: 0.09, blue: 0.44)
            case "Chicago":
                return Color(red: 0.0, green: 0.32, blue: 0.61)
            case "Cincinnati":
                return Color(red: 0.85, green: 0.01, blue: 0.16)
            case "Pittsburgh":
                return Color(red: 0.98, green: 0.78, blue: 0.18)
            case "Milwaukee":
                return Color(red: 0.0, green: 0.2, blue: 0.4)
            case "St. Louis":
                return Color(red: 0.76, green: 0.04, blue: 0.14)
            case "New York":
                return Color(red: 0.0, green: 0.34, blue: 0.71)
            case "Washington":
                return Color(red: 0.54, green: 0.0, blue: 0.15)
            case "Miami":
                return Color(red: 1.0, green: 0.4, blue: 0.0)
            case "Atlanta":
                return Color(red: 0.29, green: 0.09, blue: 0.18)
            case "Philadelphia":
                return Color(red: 0.61, green: 0.09, blue: 0.18)
            default:
                return Color.white
            }
        } else {
            return Color.white
        }
    }
}

#Preview {
    PitchersPreviewPageView(player: Player(keyBbref: "schwesp01", keyFangraphs: -1, keyMlbam: 680885, keyRetro: "schws001", mlbPlayedFirst: 2024, mlbPlayedLast: 2025, nameFirst: "spencer", nameLast: "schwellenbach"), pitchingPreviewStatsHelper: PitchingPreviewStatsHelper(pitchingPreviewStats: [PitchingPreviewStats(days: 1, doubles: 3, triples: 0, atBats: 88, age: 25, babip: 0.206, walks: 5, battersFaced: 94, caughtStealing: 1, earnedRuns: 7, era: 2.55, games: 4, groundBallToFlyBallRatio: 0.55, gdp: 2, gamesStarted: 4, hits: 16, hitByPitch: 1, homeRuns: 3, intentionalWalks: 1, inningsPitched: 24.2, losses: 1, lineDrivePercentage: 0.24, level: "Maj-NL", name: "Spencer Schwellenbach", putouts: 0, popupPercentage: 0.02, pitches: 356, runs: 7, stolenBases: 0, sacrificeFlies: 0, strikeouts: 22, strikeoutsToWalksRatio: 4.4, strikeoutsPerNine: 8, saves: nil, strikeLookingPercentage: 0.14, strikeSwingingPercentage: 0.15, strikePercentage: 0.68, team: "Atlanta", wins: 1, whip: 0.851, mlbID: "680885")]), savedUser: SavedUser())
}
