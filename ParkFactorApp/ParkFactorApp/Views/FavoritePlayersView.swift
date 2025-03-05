//
//  FavoritePlayersView.swift
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
            .frame(width: 100, height: 100)
            .padding()
            
            Divider()
                .background(Color.gray.opacity(0.75))
            
            Text("\(player.fullName)")
                .font(.parkFactorFontSubtitle)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
                .cornerRadius(5)
        }
        .frame(width: 350, height: 150)
        .background(isSelected ? Color.parkFactorPrimary : Color.white)
        .cornerRadius(20)
        .onTapGesture {
            onSelect()
        }
    }
}

struct FavoritePlayersView: View {
    @Binding var isLoggedIn: Bool
    @State private var didSelectPlayers: Bool = false
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    @State private var players: [Player] = []
    @State private var selectedPlayers: [UUID] = []
    
    var savedUser: SavedUser
    
    //    let top30PlayerNames: [String] = [
    //        // Add the names of the top 30 players
    //    ]
    
    var body: some View {
        if didSelectPlayers {
            ContentView()
        } else {
            ZStack {
                Color.parkFactorSecondary.ignoresSafeArea()
                VStack {
                    Section {
                        Text("Select Favorite Players")
                            .font(.parkFactorFontTitle)
                            .foregroundStyle(Color.white)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    .padding(.bottom, 40)
                    
                    Text("\(errorMessage)")
                        .font(.parkFactorFontText)
                        .foregroundStyle(Color.red)
                        .multilineTextAlignment(.center)
                        .opacity(errorShow ? 1 : 0)
                    
                    playersListView
                    
                    Section {
                        Button(action: {
                            Task {
                                
                            }
                        }) {
                            Text("Next")
                                .font(.parkFactorFontTitle)
                                .foregroundColor(Color.parkFactorPrimary)
                        }
                    }
                }
                .padding()
            }
            .onAppear(perform: fetchPlayers)
        }
    }
    
    private var playersListView: some View {
        Section {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(players) { player in
                        PlayerCard(
                            player: player,
                            isSelected: selectedPlayers.contains(player.id),
                            onSelect: {
                                togglePlayerSelection(player: player)
                            }
                        )
                    }
                }
                .padding()
            }
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
                   self.players = decodedPlayers
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
        if let index = selectedPlayers.firstIndex(of: player.id) {
            selectedPlayers.remove(at: index)
        } else {
            selectedPlayers.append(player.id)
        }
    }
}

#Preview {
    FavoritePlayersViewPreviewWrapper()
}

struct FavoritePlayersViewPreviewWrapper: View {
    @State private var isLoggedIn = false
    
    var body: some View {
        FavoritePlayersView(isLoggedIn: $isLoggedIn, savedUser: SavedUser())
    }
}
