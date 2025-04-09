//
//  PlayerHittingLeaderboardView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/7/25.
//

import SwiftUI

struct PlayerHittingLeaderboardView: View {
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    @State private var leaderboard: PlayerHittingLeaderboard = PlayerHittingLeaderboard(playerHittingLeaderboard: nil)
    
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            VStack {
                if let battingAverageLeaders = leaderboard.playerHittingLeaderboard?.avg {
                    PlayerTypeDoubleCardView(decimalCount: 3, title: "Batting Average", leaderboardStats: battingAverageLeaders, isPitching: false)
                }
                if let onBasePercentageLeaders = leaderboard.playerHittingLeaderboard?.onBasePercent {
                    PlayerTypeDoubleCardView(decimalCount: 3, title: "OBP", leaderboardStats: onBasePercentageLeaders, isPitching: false)
                }
                if let onBasePlusSlugging = leaderboard.playerHittingLeaderboard?.onBasePlusSlugging {
                    PlayerTypeDoubleCardView(decimalCount: 3, title: "OPS", leaderboardStats: onBasePlusSlugging, isPitching: false)
                }
                if let sluggingLeaders = leaderboard.playerHittingLeaderboard?.slg {
                    PlayerTypeDoubleCardView(decimalCount: 3, title: "Slugging", leaderboardStats: sluggingLeaders, isPitching: false)
                }
                if let warLeaders = leaderboard.playerHittingLeaderboard?.war {
                    PlayerTypeDoubleCardView(decimalCount: 1, title: "WAR", leaderboardStats: warLeaders, isPitching: false)
                }
                if let hitsLeaders = leaderboard.playerHittingLeaderboard?.hits {
                    PlayerTypeIntCardView(title: "Hits", leaderboardStats: hitsLeaders, isPitching: false)
                }
                if let homerunsLeaders = leaderboard.playerHittingLeaderboard?.homeruns {
                    PlayerTypeIntCardView(title: "Home Runs", leaderboardStats: homerunsLeaders, isPitching: false)
                }
                if let runsLeaders = leaderboard.playerHittingLeaderboard?.runs {
                    PlayerTypeIntCardView(title: "Runs", leaderboardStats: runsLeaders, isPitching: false)
                }
                if let rbisLeaders = leaderboard.playerHittingLeaderboard?.rbi {
                    PlayerTypeIntCardView(title: "RBIs", leaderboardStats: rbisLeaders, isPitching: false)
                }
                if let stolenBasesLeaders = leaderboard.playerHittingLeaderboard?.sb {
                    PlayerTypeIntCardView(title: "Stolen Bases", leaderboardStats: stolenBasesLeaders, isPitching: false)
                }
                if let walkPercentageLeaders = leaderboard.playerHittingLeaderboard?.bbPercent {
                    PlayerTypeDoubleCardView(decimalCount: 3, title: "BB%", leaderboardStats: walkPercentageLeaders, isPitching: false)
                }
                if let strikeoutPercentageLeaders = leaderboard.playerHittingLeaderboard?.kPercent {
                    PlayerTypeDoubleCardView(decimalCount: 3, title: "K%", leaderboardStats: strikeoutPercentageLeaders, isPitching: false)
                }
                if let barrelPercentageLeaders = leaderboard.playerHittingLeaderboard?.barrelPercent {
                    PlayerTypeDoubleCardView(decimalCount: 3, title: "Barrel%", leaderboardStats: barrelPercentageLeaders, isPitching: false)
                }
                if let exitVelocityLeaders = leaderboard.playerHittingLeaderboard?.exitVelocity {
                    PlayerTypeDoubleCardView(decimalCount: 1, title: "Exit Velocity", leaderboardStats: exitVelocityLeaders, isPitching: false)
                }
                if let wRCPlusLeaders = leaderboard.playerHittingLeaderboard?.wRCPlus {
                    PlayerTypeIntCardView(title: "wRC+", leaderboardStats: wRCPlusLeaders, isPitching: false)
                }
                if let bsrLeaders = leaderboard.playerHittingLeaderboard?.bsr {
                    PlayerTypeDoubleCardView(decimalCount: 1, title: "BsR", leaderboardStats: bsrLeaders, isPitching: false)
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
        guard let url = URL(string: "\(baseUrl)/hitters/stats/leaderboard") else {
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
                let decodedLeaderboard = try JSONDecoder().decode(PlayerHittingLeaderboard.self, from: data)
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
    PlayerHittingLeaderboardView()
}
