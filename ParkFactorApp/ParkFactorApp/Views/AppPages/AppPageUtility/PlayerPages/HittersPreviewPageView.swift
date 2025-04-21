//
//  HittersPreviewPageView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/15/25.
//

import SwiftUI

struct HittersPreviewPageView: View {
    @AppStorage("accessToken") private var accessToken: String?
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    var player: Player
    var hitterPreviewStatsHelper: HitterPreviewStatsHelper
    var savedUser: SavedUser
    
    @State var followingPlayers: [Player] = []
    
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
                            Text(hitterPreviewStatsHelper.hitterPreviewStats?[0].teamName ?? "")
                                .foregroundStyle(Color.white)
                                .font(.parkFactorFontTextNorwester)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Spacer()
                        Button(action: {
                            Task {
                                await togglePlayerSelection(player: player)
                            }
                        }) {
                            if followingPlayers.contains(where: { $0.keyMlbam == player.keyMlbam }) {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(Color.parkFactorPrimary)
                                    .opacity(1)
                                    .font(.system(size: 35))
                            } else {
                                Image(systemName: "star")
                                    .foregroundStyle(Color.white)
                                    .opacity(1)
                                    .font(.system(size: 35))
                            }
                        }
                        .padding(.trailing, 30)
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
                    HitterSeasonPreviewStatsView(player: player, hitterPreviewStatsHelper: hitterPreviewStatsHelper)
                }
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom)
            .padding(.top, 10)
            .onAppear {
                setFollowingPlayersArray()
            }
            
        }
    }
    
    private func setFollowingPlayersArray() {
        followingPlayers = savedUser.user.followingPlayers
    }
    
    private func togglePlayerSelection(player: Player) async {
        if let index = followingPlayers.firstIndex(where: { $0.keyMlbam == player.keyMlbam }) {
            followingPlayers.remove(at: index)
        } else {
            followingPlayers.append(player)
        }
        
        // save the players to a Codable to be used by request
        var followingPlayersRequest: FollowingPlayersStruct = FollowingPlayersStruct()
        followingPlayersRequest.followingPlayers = followingPlayers
        
        // call the network request to save players to database
        let baseUrl = Env.expressBaseURL
        guard let encoded = try? JSONEncoder().encode(followingPlayersRequest) else {
            errorMessage = "Failed to encode Following Players"
            errorShow = true
            return
        }
        
        //create the url
        let url = URL(string: "\(baseUrl)/users/update/followingPlayers")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        
        do {
            let (data, res) = try await URLSession.shared.upload(for: request, from: encoded)
            
            // handle the result if bad
            if let httpResponse = res as? HTTPURLResponse {
                // If the result of the http response is a 400 then the message of what went wrong will be returned and placed in errorMessage
                if httpResponse.statusCode != 201 {
                    let decodedNodeError = try JSONDecoder().decode(NodeError.self, from: data)
                    errorMessage = decodedNodeError.message
                    errorShow = true
                    return
                }
            }
            // save the players to UserDefaults
            savedUser.user.followingPlayers = followingPlayers
        } catch {
            errorMessage = error.localizedDescription
            errorShow = true
        }
    }
    
    private func getTeamColor() -> Color {
        if hitterPreviewStatsHelper.hitterPreviewStats?[0].level == "Maj-AL" {
            switch hitterPreviewStatsHelper.hitterPreviewStats?[0].team {
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
        } else if hitterPreviewStatsHelper.hitterPreviewStats?[0].level == "Maj-NL" {
            switch hitterPreviewStatsHelper.hitterPreviewStats?[0].team {
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
    HittersPreviewPageView(player: Player(keyBbref: "smithca07", keyFangraphs: -1, keyMlbam: 701358, keyRetro: nil, mlbPlayedFirst: 2025, mlbPlayedLast: 2025, nameFirst: "cam", nameLast: "smith"), hitterPreviewStatsHelper: HitterPreviewStatsHelper(hitterPreviewStats: [HitterPreviewStats(days: 0, doubles: 0, triples: 1, atBats: 45, age: 22, battingAverage: 0.2, walks: 4, caughtStealing: 0, games: 14, gdp: 0, hits: 9, hitByPitch: 1, homeRuns: 1, intentionalWalks: 0, level: "Maj-AL", name: "Cam Smith", onBasePercentage: 0.28, onBasePlusSlugging: 0.591, pa: 50, runs: 4, rbi: 6, sb: 1, sacrificeFlies: 0, sacrificeHits: 0, sluggingPercentage: 0.311, strikeouts: 14, team: "Houston", mlbID: 701358)]), savedUser: SavedUser())
}
