//
//  FollowingPlayersView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/3/25.
//

import SwiftUI

struct PlayerCard: View {
    let player: Player
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: "https://img.mlbstatic.com/mlb-photos/image/upload/w_180,d_people:generic:headshot:silo:current.png,q_auto:best,f_auto/v1/people/\(player.keyMlbam)/headshot/silo/current"), scale: 3) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: .infinity, height: .infinity)
            .padding()
            .background(Color.white)
            
            Text("\(player.fullName)")
                .font(.parkFactorFontBigTextNorwester)
                .foregroundColor(isSelected ? Color.parkFactorSecondary : Color.parkFactorPrimary)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
                .cornerRadius(5)
        }
        .frame(width: 335, height: 135)
        .background(isSelected ? Color.parkFactorPrimary : Color.black)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.parkFactorPrimary, lineWidth: 5)
        )
        .padding(15)
        .onTapGesture {
            onSelect()
        }
    }
}

struct FollowingPlayersView: View {
    @Binding var isLoggedIn: Bool
    @AppStorage("accessToken") private var accessToken: String?
    @State private var didSelectPlayers: Bool = false
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
        if didSelectPlayers {
            ContentView()
        } else {
            ZStack {
                Color.parkFactorSecondary.ignoresSafeArea()
                VStack {
                    Section {
                        Text("Select Following Players")
                            .font(.parkFactorFontTitle)
                            .foregroundStyle(Color.white)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    .padding(.bottom, 30)
                    
                    Text("\(errorMessage)")
                        .font(.parkFactorFontText)
                        .foregroundStyle(Color.red)
                        .multilineTextAlignment(.center)
                        .opacity(errorShow ? 1 : 0)
                    
                    PlayerSearchBarView(searchText: $searchText, searchIsFocused: $searchIsFocused)
                    
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
                    
                    Section {
                        Button(action: {
                            Task {
                                await saveFollowingPlayers()
                            }
                        }) {
                            Text(selectedPlayers.isEmpty ? "Skip" : "Next")
                                .font(.parkFactorFontTitle)
                                .foregroundColor(Color.parkFactorPrimary)
                        }
                        .padding(.top, 20)
                    }
                }
                .padding()
            }
            .onAppear(perform: fetchPlayers)
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
                LazyVStack(spacing: 10) {
                    if !searchText.isEmpty {
                        ForEach((players.filter { $0.fullName.hasPrefix(searchText.capitalized) })) { player in
                            let isSelected = selectedPlayers.contains(where: { $0.id == player.id })
                            PlayerCard(
                                player: player,
                                isSelected: isSelected,
                                onSelect: {
                                    togglePlayerSelection(player: player)
                                }
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
                    .font(.parkFactorFontSubtitleNorwester)
                    .foregroundStyle(Color.white)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(players.filter { trendingPlayers.contains($0.fullName) }) { player in
                        let isSelected = selectedPlayers.contains(where: { $0.id == player.id })
                        PlayerCard(
                            player: player,
                            isSelected: isSelected,
                            onSelect: {
                                togglePlayerSelection(player: player)
                            }
                        )
                        .animation(.linear(duration: 0.25), value: isSelected)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding()
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
    
    func togglePlayerSelection(player: Player) {
        if let index = selectedPlayers.firstIndex(where: { $0.id == player.id }) {
            selectedPlayers.remove(at: index)
        } else {
            selectedPlayers.append(player)
        }
    }
    
    func saveFollowingPlayers() async {
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
            didSelectPlayers = true
        } catch {
            errorMessage = error.localizedDescription
            errorShow = true
        }
    }
}

#Preview {
    FollowingPlayersViewPreviewWrapper()
}

struct FollowingPlayersViewPreviewWrapper: View {
    @State private var isLoggedIn = false
    
    var body: some View {
        FollowingPlayersView(isLoggedIn: $isLoggedIn, savedUser: SavedUser())
    }
}
