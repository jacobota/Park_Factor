//
//  TeamPitchingLeaderboardView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/6/25.
//

import SwiftUI

struct TeamPitchingLeaderboardView: View {
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    @State private var leaderboard: TeamPitchingLeaderboard = TeamPitchingLeaderboard(teamPitchingLeaderboard: nil)
    
    var savedUser: SavedUser
    
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            LazyVStack {
                if let battingAverageLeaders = leaderboard.teamPitchingLeaderboard?.avg {
                    TeamTypeDoubleCardView(decimalCount: 3, title: "Batting Average Against", leaderboardStats: battingAverageLeaders, savedUser: savedUser)
                }
                if let eraLeaders = leaderboard.teamPitchingLeaderboard?.era {
                    TeamTypeDoubleCardView(decimalCount: 2, title: "ERA", leaderboardStats: eraLeaders, savedUser: savedUser)
                }
                if let strikeoutLeaders = leaderboard.teamPitchingLeaderboard?.strikeouts {
                    TeamTypeIntCardView(title: "Strikeouts", leaderboardStats: strikeoutLeaders, savedUser: savedUser)
                }
                if let strikeoutPercentLeaders = leaderboard.teamPitchingLeaderboard?.kPercent {
                    TeamTypeDoubleCardView(decimalCount: 3, title: "K%", leaderboardStats: strikeoutPercentLeaders, savedUser: savedUser)
                }
                if let walkLeaders = leaderboard.teamPitchingLeaderboard?.walks {
                    TeamTypeIntCardView(title: "Walks Allowed", leaderboardStats: walkLeaders, savedUser: savedUser)
                }
                if let walkPercentLeaders = leaderboard.teamPitchingLeaderboard?.bbPercent {
                    TeamTypeDoubleCardView(decimalCount: 3, title: "BB%", leaderboardStats: walkPercentLeaders, savedUser: savedUser)
                }
                if let hitsAllowedLeaders = leaderboard.teamPitchingLeaderboard?.hits {
                    TeamTypeIntCardView(title: "Hits Allowed", leaderboardStats: hitsAllowedLeaders, savedUser: savedUser)
                }
                if let runsAllowedLeaders = leaderboard.teamPitchingLeaderboard?.runs {
                    TeamTypeIntCardView(title: "Runs Allowed", leaderboardStats: runsAllowedLeaders, savedUser: savedUser)
                }
                if let homerunsAllowedLeaders = leaderboard.teamPitchingLeaderboard?.homeruns {
                    TeamTypeIntCardView(title: "Home Runs Allowed", leaderboardStats: homerunsAllowedLeaders, savedUser: savedUser)
                }
                if let savesLeaders = leaderboard.teamPitchingLeaderboard?.sv {
                    TeamTypeIntCardView(title: "Saves", leaderboardStats: savesLeaders, savedUser: savedUser)
                }
                if let warLeaders = leaderboard.teamPitchingLeaderboard?.war {
                    TeamTypeDoubleCardView(decimalCount: 1, title: "WAR", leaderboardStats: warLeaders, savedUser: savedUser)
                }
                if let sieraLeaders = leaderboard.teamPitchingLeaderboard?.siera {
                    TeamTypeDoubleCardView(decimalCount: 2, title: "SIERA", leaderboardStats: sieraLeaders, savedUser: savedUser)
                }
                if let whipLeaders = leaderboard.teamPitchingLeaderboard?.whip {
                    TeamTypeDoubleCardView(decimalCount: 2, title: "WHIP", leaderboardStats: whipLeaders, savedUser: savedUser)
                }
                if let gbPercentLeaders = leaderboard.teamPitchingLeaderboard?.gbPercent {
                    TeamTypeDoubleCardView(decimalCount: 3, title: "GB%", leaderboardStats: gbPercentLeaders, savedUser: savedUser)
                }
                if let fastballVelocityLeaders = leaderboard.teamPitchingLeaderboard?.fastballVelocity {
                    TeamTypeDoubleCardView(decimalCount: 1, title: "Average Fastball Velocity", leaderboardStats: fastballVelocityLeaders, savedUser: savedUser)
                }
                if let exitVelocityLeaders = leaderboard.teamPitchingLeaderboard?.exitVelocity {
                    TeamTypeDoubleCardView(decimalCount: 1, title: "Exit Velocity Against", leaderboardStats: exitVelocityLeaders, savedUser: savedUser)
                }
            }
        }
        .onAppear {
            Task {
                await retrieveLeaderboards()
            }
        }
    }
    
    private func retrieveLeaderboards() async {
        // call the network request to retrieve players
        let baseUrl = Env.expressBaseURL
        guard let url = URL(string: "\(baseUrl)/teamStats/leaderboard/pitching") else {
            errorMessage = "Missing URL"
            errorShow = true
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                    errorShow = true
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    errorMessage = "Invalid response"
                    errorShow = true
                }
                return
            }
            
            if response.statusCode != 200 {
                DispatchQueue.main.async {
                    errorMessage = "Failed to fetch data: \(response.statusCode)"
                    errorShow = true
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "No data received"
                    errorShow = true
                }
                return
            }
            
            do {
                let decodedLeaderboard = try JSONDecoder().decode(TeamPitchingLeaderboard.self, from: data)
                DispatchQueue.main.async {
                   leaderboard = decodedLeaderboard
                }
            } catch let error {
                DispatchQueue.main.async {
                    errorMessage = "Failed to decode data: \(error.localizedDescription)"
                    errorShow = true
                }
            }
        }
        
        dataTask.resume()
    }
}

#Preview {
    TeamPitchingLeaderboardView(savedUser: SavedUser())
}
