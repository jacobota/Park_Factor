//
//  PlayerLookupStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/6/25.
//

import SwiftUI

struct PlayerLookupStatsView: View {
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    @State private var players: [Player] = []
    @State private var filteredPlayers: [Player] = []
    @State private var searchText: String = ""
    @State private var searchIsFocused: Bool = false
    @State private var isTyping = false
    
    var savedUser: SavedUser
    
    var body: some View {
        VStack {
            PlayerSearchBarView(searchText: $searchText, searchIsFocused: $searchIsFocused)
            
            Section {
                ScrollView {
                    Section {
                        Section {
                            Text("Search Results")
                                .font(.parkFactorFontSubtitleNorwester)
                                .foregroundStyle(Color.white)
                        }
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(filteredPlayers) { player in
                                    PlayerStatsCardView(savedUser: savedUser, player: player, isFollowing: savedUser.user.followingPlayers.contains { $0.keyMlbam == player.keyMlbam })
                                        .padding(.bottom, 10)
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                    .padding()
                    .onChange(of: searchText) { oldValue, newValue in
                        if !newValue.isEmpty {
                            // Add a delay before filtering the players, improve efficiency
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                filteredPlayers = players.filter {
                                    $0.fullName.hasPrefix(searchText.capitalized)
                                }
                            }
                        } else {
                            filteredPlayers = []
                        }
                    }
                }
                .padding(.top, 20)
            }
        }
        .padding()
        .onAppear {
            fetchPlayers()
        }
    }
    
    func fetchPlayers() {
        // call the network request to retrieve players
        let baseUrl = Env.expressBaseURL
        guard let url = URL(string: "\(baseUrl)/players/mlb-players") else {
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
                let decodedPlayers = try JSONDecoder().decode([Player].self, from: data)
                DispatchQueue.main.async {
                   players = decodedPlayers
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
    PlayerLookupStatsView(savedUser: SavedUser())
}
