//
//  PlayersFollowingPageView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/8/25.
//

import SwiftUI

struct PlayersFollowingPageView: View {
    @AppStorage("accessToken") private var accessToken: String?
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    @State private var players: [Player] = []
    @State private var selectedPlayers: [Player] = []
    @State private var searchText: String = ""
    @State private var searchIsFocused: Bool = false
    
    var savedUser: SavedUser
    
    let trendingPlayers: [String] = [
        "Shohei Ohtani",
        "Aaron Judge",
        "Bobby Witt",
        "Juan Soto",
        "Mookie Betts",
        "Francisco Lindor",
        "Yordan Álvarez",
        "Freddie Freeman",
        "José Ramírez",
        "Gunnar Henderson",
        "Tarik Skubal",
        "Bryce Harper",
        "Vladimir Guerrero",
        "Kyle Tucker",
        "Paul Skenes",
        "Ronald Acuña",
        "Corey Seager",
        "Ketel Marte",
        "Zack Wheeler",
        "Chris Sale",
        "Rafael Devers",
        "Fernando Tatís",
        "Julio Rodríguez",
        "Jackson Merrill",
        "Corbin Burnes",
        "Gerrit Cole",
        "Jarren Duran",
        "William Contreras",
        "Manny Machado",
        "José Altuve"
    ]
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            Section {
                VStack {
                    Text("Players")
                        .font(.parkFactorFontSubtitleNorwester)
                        .foregroundStyle(Color.white)
                        .padding(.top, 10)
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.9))
                        .frame(height: 2)
                        .padding(.top, 10)
                    
                    PlayerSearchBarView(searchText: $searchText, searchIsFocused: $searchIsFocused)
                    
                    Text("\(errorMessage)")
                        .font(.parkFactorFontText)
                        .foregroundStyle(errorShow ? Color.red : Color.parkFactorPrimary)
                        .multilineTextAlignment(.center)
                        .opacity(errorShow ? 1 : 0)
                    
                    Section {
                        ScrollView {
                            if searchIsFocused {
                                searchFilteredPlayersListView
                            } else {
                                trendingPlayersListView
                            }
                        }
                        .padding(.top, 20)
                    }
                }
                .padding(20)
                .background(Color.parkFactorSecondary)
                .cornerRadius(20)
            }
            .padding()
        }
        .onAppear{
            Task {
                await fetchPlayers()
            }
        }
    }
    
    private var searchFilteredPlayersListView: some View {
        Section {
            Section {
                Text("Search Results")
                    .font(.parkFactorFontSubtitleNorwester)
                    .foregroundStyle(Color.white)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            ScrollView {
                LazyVStack(spacing: 30) {
                    if !searchText.isEmpty {
                        ForEach((players.filter { $0.fullName.contains(searchText.capitalized) })) { player in
                            let isSelected = selectedPlayers.contains(where: { $0.keyMlbam == player.keyMlbam })
                            FollowingPagePlayerCard(
                                player: player,
                                isSelected: isSelected,
                                onSelect: {
                                    Task {
                                        await togglePlayerSelection(player: player)
                                    }
                                },
                                savedUser: savedUser
                            )
                            .animation(.linear(duration: 0.25), value: isSelected)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding()
    }
    
    private var trendingPlayersListView: some View {
        Section {
            Section {
                Text("Top 30 Right Now")
                    .font(.parkFactorFontBigTextNorwester)
                    .foregroundStyle(Color.white)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            ScrollView {
                LazyVStack(spacing: 30) {
                    ForEach(players.filter { trendingPlayers.contains($0.fullName) }) { player in
                        let isSelected = selectedPlayers.contains(where: { $0.keyMlbam == player.keyMlbam })
                        FollowingPagePlayerCard(
                            player: player,
                            isSelected: isSelected,
                            onSelect: {
                                Task {
                                    await togglePlayerSelection(player: player)
                                }
                            },
                            savedUser: savedUser
                        )
                        .animation(.linear(duration: 0.25), value: isSelected)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding()
    }
    
    private func fetchPlayers() async {
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
                    selectedPlayers = savedUser.user.followingPlayers
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
    
    private func togglePlayerSelection(player: Player) async {
        if let index = selectedPlayers.firstIndex(where: { $0.id == player.id }) {
            selectedPlayers.remove(at: index)
        } else {
            selectedPlayers.append(player)
        }
        
        // save the players to a Codable to be used by request
        var followingPlayersRequest: FollowingPlayersStruct = FollowingPlayersStruct()
        followingPlayersRequest.followingPlayers = selectedPlayers
        
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
            savedUser.user.followingPlayers = selectedPlayers
        } catch {
            errorMessage = error.localizedDescription
            errorShow = true
        }
    }
}

#Preview {
    PlayersFollowingPageView(savedUser: SavedUser())
}
