//
//  PlayerPitchingLeaderboardView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/7/25.
//

import SwiftUI

struct PlayerPitchingLeaderboardView: View {
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    @State private var leaderboard: PlayerPitchingLeaderboard = PlayerPitchingLeaderboard(playerPitchingLeaderboard: nil)
    
    var savedUser: SavedUser
    
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            LazyVStack {
                Text("\(errorMessage)")
                    .font(.parkFactorFontText)
                    .foregroundStyle(errorShow ? Color.red : Color.parkFactorPrimary)
                    .multilineTextAlignment(.center)
                    .opacity(errorShow ? 1 : 0)
                if let battingAverageLeaders = leaderboard.playerPitchingLeaderboard?.avg {
                    PlayerTypeDoubleCardView(decimalCount: 3, title: "Batting Average Against", leaderboardStats: battingAverageLeaders, isPitching: true, savedUser: savedUser)
                }
                if let eraLeaders = leaderboard.playerPitchingLeaderboard?.era {
                    PlayerTypeDoubleCardView(decimalCount: 2, title: "ERA", leaderboardStats: eraLeaders, isPitching: true, savedUser: savedUser)
                }
                if let inningsPitchedLeaders = leaderboard.playerPitchingLeaderboard?.inningsPitched {
                    PlayerTypeDoubleCardView(decimalCount: 1, title: "IP", leaderboardStats: inningsPitchedLeaders, isPitching: true, savedUser: savedUser)
                }
                if let winsLeaders = leaderboard.playerPitchingLeaderboard?.wins {
                    PlayerTypeIntCardView(title: "Wins", leaderboardStats: winsLeaders, isPitching: true, savedUser: savedUser)
                }
                if let lossLeaders = leaderboard.playerPitchingLeaderboard?.loss {
                    PlayerTypeIntCardView(title: "Loss", leaderboardStats: lossLeaders, isPitching: true, savedUser: savedUser)
                }
                if let strikeoutLeaders = leaderboard.playerPitchingLeaderboard?.strikeouts {
                    PlayerTypeIntCardView(title: "Strikeouts", leaderboardStats: strikeoutLeaders, isPitching: true, savedUser: savedUser)
                }
                if let strikeoutPercentLeaders = leaderboard.playerPitchingLeaderboard?.kPercent {
                    PlayerTypeDoubleCardView(decimalCount: 3, title: "K%", leaderboardStats: strikeoutPercentLeaders, isPitching: true, savedUser: savedUser)
                }
                if let walkLeaders = leaderboard.playerPitchingLeaderboard?.walks {
                    PlayerTypeIntCardView(title: "Walks Allowed", leaderboardStats: walkLeaders, isPitching: true, savedUser: savedUser)
                }
                if let walkPercentLeaders = leaderboard.playerPitchingLeaderboard?.bbPercent {
                    PlayerTypeDoubleCardView(decimalCount: 3, title: "BB%", leaderboardStats: walkPercentLeaders, isPitching: true, savedUser: savedUser)
                }
                if let hitsAllowedLeaders = leaderboard.playerPitchingLeaderboard?.hits {
                    PlayerTypeIntCardView(title: "Hits Allowed", leaderboardStats: hitsAllowedLeaders, isPitching: true, savedUser: savedUser)
                }
                if let runsAllowedLeaders = leaderboard.playerPitchingLeaderboard?.runs {
                    PlayerTypeIntCardView(title: "Runs Allowed", leaderboardStats: runsAllowedLeaders, isPitching: true, savedUser: savedUser)
                }
                if let homerunsAllowedLeaders = leaderboard.playerPitchingLeaderboard?.homeruns {
                    PlayerTypeIntCardView(title: "Home Runs Allowed", leaderboardStats: homerunsAllowedLeaders, isPitching: true, savedUser: savedUser)
                }
                if let savesLeaders = leaderboard.playerPitchingLeaderboard?.sv {
                    PlayerTypeIntCardView(title: "Saves", leaderboardStats: savesLeaders, isPitching: true, savedUser: savedUser)
                }
                if let warLeaders = leaderboard.playerPitchingLeaderboard?.war {
                    PlayerTypeDoubleCardView(decimalCount: 1, title: "WAR", leaderboardStats: warLeaders, isPitching: true, savedUser: savedUser)
                }
                if let sieraLeaders = leaderboard.playerPitchingLeaderboard?.siera {
                    PlayerTypeDoubleCardView(decimalCount: 2, title: "SIERA", leaderboardStats: sieraLeaders, isPitching: true, savedUser: savedUser)
                }
                if let whipLeaders = leaderboard.playerPitchingLeaderboard?.whip {
                    PlayerTypeDoubleCardView(decimalCount: 2, title: "WHIP", leaderboardStats: whipLeaders, isPitching: true, savedUser: savedUser)
                }
                if let gbPercentLeaders = leaderboard.playerPitchingLeaderboard?.gbPercent {
                    PlayerTypeDoubleCardView(decimalCount: 3, title: "GB%", leaderboardStats: gbPercentLeaders, isPitching: true, savedUser: savedUser)
                }
                if let fastballVelocityLeaders = leaderboard.playerPitchingLeaderboard?.fastballVelocity {
                    PlayerTypeDoubleCardView(decimalCount: 1, title: "Average Fastball Velocity", leaderboardStats: fastballVelocityLeaders, isPitching: true, savedUser: savedUser)
                }
                if let exitVelocityLeaders = leaderboard.playerPitchingLeaderboard?.exitVelocity {
                    PlayerTypeDoubleCardView(decimalCount: 1, title: "Exit Velocity Against", leaderboardStats: exitVelocityLeaders, isPitching: true, savedUser: savedUser)
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
        guard let url = URL(string: "\(baseUrl)/pitchers/stats/leaderboard") else {
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
                let decodedLeaderboard = try JSONDecoder().decode(PlayerPitchingLeaderboard.self, from: data)
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
    PlayerPitchingLeaderboardView(savedUser: SavedUser())
}
