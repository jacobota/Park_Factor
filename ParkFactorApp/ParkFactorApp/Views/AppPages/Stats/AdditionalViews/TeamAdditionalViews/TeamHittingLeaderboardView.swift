//
//  TeamHittingLeaderboardView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/6/25.
//

import SwiftUI

struct TeamHittingLeaderboardView: View {
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    @State private var leaderboard: TeamHittingLeaderboard = TeamHittingLeaderboard(teamHittingLeaderboard: nil)
    
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            VStack {
                if let battingAverageLeaders = leaderboard.teamHittingLeaderboard?.avg {
                    TeamTypeDoubleCardView(decimalCount: 3, title: "Batting Average", leaderboardStats: battingAverageLeaders)
                }
                if let onBasePercentageLeaders = leaderboard.teamHittingLeaderboard?.onBasePercent {
                    TeamTypeDoubleCardView(decimalCount: 3, title: "OBP", leaderboardStats: onBasePercentageLeaders)
                }
                if let onBasePlusSlugging = leaderboard.teamHittingLeaderboard?.onBasePlusSlugging {
                    TeamTypeDoubleCardView(decimalCount: 3, title: "OPS", leaderboardStats: onBasePlusSlugging)
                }
                if let sluggingLeaders = leaderboard.teamHittingLeaderboard?.slg {
                    TeamTypeDoubleCardView(decimalCount: 3, title: "Slugging", leaderboardStats: sluggingLeaders)
                }
                if let warLeaders = leaderboard.teamHittingLeaderboard?.war {
                    TeamTypeDoubleCardView(decimalCount: 1, title: "WAR", leaderboardStats: warLeaders)
                }
                // Hits, HR
                // R, RBI, SB
                if let walkPercentageLeaders = leaderboard.teamHittingLeaderboard?.bbPercent {
                    TeamTypeDoubleCardView(decimalCount: 3, title: "BB%", leaderboardStats: walkPercentageLeaders)
                }
                if let strikeoutPercentageLeaders = leaderboard.teamHittingLeaderboard?.kPercent {
                    TeamTypeDoubleCardView(decimalCount: 3, title: "K%", leaderboardStats: strikeoutPercentageLeaders)
                }
                if let barrelPercentageLeaders = leaderboard.teamHittingLeaderboard?.barrelPercent {
                    TeamTypeDoubleCardView(decimalCount: 3, title: "Barrel%", leaderboardStats: barrelPercentageLeaders)
                }
                if let exitVelocityLeaders = leaderboard.teamHittingLeaderboard?.exitVelocity {
                    TeamTypeDoubleCardView(decimalCount: 1, title: "Exit Velocity", leaderboardStats: exitVelocityLeaders)
                }
                if let wRCPlusLeaders = leaderboard.teamHittingLeaderboard?.wRCPlus {
                    TeamTypeDoubleCardView(decimalCount: 3, title: "wRC+", leaderboardStats: wRCPlusLeaders)
                }
                if let bsrLeaders = leaderboard.teamHittingLeaderboard?.bsr {
                    TeamTypeDoubleCardView(decimalCount: 1, title: "BsR", leaderboardStats: bsrLeaders)
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
        guard let url = URL(string: "\(baseUrl)/teamStats/leaderboard/hitting") else {
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
                let decodedLeaderboard = try JSONDecoder().decode(TeamHittingLeaderboard.self, from: data)
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
    TeamHittingLeaderboardView()
}
