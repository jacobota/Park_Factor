//
//  ChangeFavoritePlayerView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/16/25.
//

import SwiftUI

struct ChangeFavoritePlayerView: View {
    @AppStorage("accessToken") private var accessToken: String?
    @State private var resultMessage: String = ""
    @State private var resultShow: Bool = false
    @State private var successShow: Bool = false
    @State private var selectedPlayer: Player?
    @State private var followingPlayers: [Player] = []
    
    var savedUser: SavedUser
    
    var body: some View {
        ZStack {
            Color.parkFactorSecondary.ignoresSafeArea()
            VStack {
                Text("Select Your Favorite Player")
                    .font(.parkFactorFontSubtitleNorwester)
                    .foregroundStyle(Color.white)
                    .padding(.bottom, 10)
                
                List {
                    ForEach(followingPlayers) { player in
                        PlayerCard(player: player, isSelected: selectedPlayer?.keyMlbam == player.keyMlbam) {
                            Task {
                                await updateFavoritePlayerFunc(player)
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        Capsule()
                            .fill(Color.parkFactorSecondary)
                            .padding(5))
                }
                .environment(\.defaultMinListRowHeight, 60)
                .listStyle(GroupedListStyle())
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .containerRelativeFrame(.horizontal) { size, axis in
                    size * 0.9
                }
            }
            .padding()
            .background(Color.parkFactorSecondary)
            .cornerRadius(20)
            .padding()
        }
        .onAppear {
            setPlayerProperties()
        }
    }
    
    private func setPlayerProperties() {
        followingPlayers = savedUser.user.followingPlayers
        selectedPlayer = savedUser.user.favoritePlayer
    }
    
    private func updateFavoritePlayerFunc(_ player: Player) async {
        if selectedPlayer?.keyMlbam == player.keyMlbam {
            selectedPlayer = nil
        } else {
            selectedPlayer = player
        }
        // call the network request to update user tag
        let baseUrl = Env.expressBaseURL
        var updateFavoritePlayerRequest = UpdateFavoritePlayer()
        updateFavoritePlayerRequest.favoritePlayer = selectedPlayer
        guard let encoded = try? JSONEncoder().encode(updateFavoritePlayerRequest) else {
            resultMessage = "Failed to encode Favorite Player"
            resultShow = true
            return
        }
        
        //create the url
        let url = URL(string: "\(baseUrl)/users/update/favoritePlayer")!
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
                    resultMessage = decodedNodeError.message
                    resultShow = true
                    return
                }
                
                // Update the favorite player in the savedUser for UserDefaults 
                savedUser.user.favoritePlayer = selectedPlayer
            }
        } catch {
            resultMessage = error.localizedDescription
            resultShow = true
        }
    }
}

#Preview {
    ChangeFavoritePlayerView(savedUser: SavedUser())
}
