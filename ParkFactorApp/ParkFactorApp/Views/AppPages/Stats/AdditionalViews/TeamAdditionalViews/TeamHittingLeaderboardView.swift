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
    
    var savedUser: SavedUser
    
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            LazyVStack {
                if let battingAverageLeaders = leaderboard.teamHittingLeaderboard?.avg {
                    TeamTypeDoubleCardView(decimalCount: 3, title: "Batting Average", leaderboardStats: battingAverageLeaders, savedUser: savedUser)
                }
                if let onBasePercentageLeaders = leaderboard.teamHittingLeaderboard?.onBasePercent {
                    TeamTypeDoubleCardView(decimalCount: 3, title: "OBP", leaderboardStats: onBasePercentageLeaders, savedUser: savedUser)
                }
                if let onBasePlusSlugging = leaderboard.teamHittingLeaderboard?.onBasePlusSlugging {
                    TeamTypeDoubleCardView(decimalCount: 3, title: "OPS", leaderboardStats: onBasePlusSlugging, savedUser: savedUser)
                }
                if let sluggingLeaders = leaderboard.teamHittingLeaderboard?.slg {
                    TeamTypeDoubleCardView(decimalCount: 3, title: "Slugging", leaderboardStats: sluggingLeaders, savedUser: savedUser)
                }
                if let warLeaders = leaderboard.teamHittingLeaderboard?.war {
                    TeamTypeDoubleCardView(decimalCount: 1, title: "WAR", leaderboardStats: warLeaders, savedUser: savedUser)
                }
                if let hitsLeaders = leaderboard.teamHittingLeaderboard?.hits {
                    TeamTypeIntCardView(title: "Hits", leaderboardStats: hitsLeaders, savedUser: savedUser)
                }
                if let homerunsLeaders = leaderboard.teamHittingLeaderboard?.homeruns {
                    TeamTypeIntCardView(title: "Home Runs", leaderboardStats: homerunsLeaders, savedUser: savedUser)
                }
                if let runsLeaders = leaderboard.teamHittingLeaderboard?.runs {
                    TeamTypeIntCardView(title: "Runs", leaderboardStats: runsLeaders, savedUser: savedUser)
                }
                if let rbisLeaders = leaderboard.teamHittingLeaderboard?.rbi {
                    TeamTypeIntCardView(title: "RBIs", leaderboardStats: rbisLeaders, savedUser: savedUser)
                }
                if let stolenBasesLeaders = leaderboard.teamHittingLeaderboard?.sb {
                    TeamTypeIntCardView(title: "Stolen Bases", leaderboardStats: stolenBasesLeaders, savedUser: savedUser)
                }
                if let walkPercentageLeaders = leaderboard.teamHittingLeaderboard?.bbPercent {
                    TeamTypeDoubleCardView(decimalCount: 3, title: "BB%", leaderboardStats: walkPercentageLeaders, savedUser: savedUser)
                }
                if let strikeoutPercentageLeaders = leaderboard.teamHittingLeaderboard?.kPercent {
                    TeamTypeDoubleCardView(decimalCount: 3, title: "K%", leaderboardStats: strikeoutPercentageLeaders, savedUser: savedUser)
                }
                if let barrelPercentageLeaders = leaderboard.teamHittingLeaderboard?.barrelPercent {
                    TeamTypeDoubleCardView(decimalCount: 3, title: "Barrel%", leaderboardStats: barrelPercentageLeaders, savedUser: savedUser)
                }
                if let exitVelocityLeaders = leaderboard.teamHittingLeaderboard?.exitVelocity {
                    TeamTypeDoubleCardView(decimalCount: 1, title: "Exit Velocity", leaderboardStats: exitVelocityLeaders, savedUser: savedUser)
                }
                if let wRCPlusLeaders = leaderboard.teamHittingLeaderboard?.wRCPlus {
                    TeamTypeIntCardView(title: "wRC+", leaderboardStats: wRCPlusLeaders, savedUser: savedUser)
                }
                if let bsrLeaders = leaderboard.teamHittingLeaderboard?.bsr {
                    TeamTypeDoubleCardView(decimalCount: 1, title: "BsR", leaderboardStats: bsrLeaders, savedUser: savedUser)
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
    TeamHittingLeaderboardView(savedUser: SavedUser())
}
