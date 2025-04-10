//
//  AllTeamsStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/6/25.
//

import SwiftUI

struct AllTeamsStatsView: View {
    var savedUser: SavedUser
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    @State private var teams: [Team] = []
    
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            Section {
                ScrollView {
                    VStack {
                        if savedUser.user.followingTeams.isEmpty {
                            Text("N/A")
                                .font(.parkFactorFontBigTextNorwester)
                                .foregroundStyle(Color.white)
                                .padding(.top, 10)
                        } else {
                            ForEach(teams) { team in
                                TeamStatsCardView(savedUser: savedUser, team: team, isFollowing: savedUser.user.followingTeams.contains { $0.teamIDBR == team.teamIDBR })
                                    .padding(.bottom, 10)
                            }
                        }
                    }
                }
                .padding(.top, 20)
            }
            .padding()
            .onAppear {
                fetchTeams()
            }
        }
    }
    
    private func fetchTeams() {
        // call the network request to retrieve teams
        let baseUrl = Env.expressBaseURL
        guard let url = URL(string: "\(baseUrl)/teams/mlb-teams") else {
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
                let decodedTeams = try JSONDecoder().decode([Team].self, from: data)
                DispatchQueue.main.async {
                   teams = decodedTeams
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
    AllTeamsStatsView(savedUser: SavedUser())
}
