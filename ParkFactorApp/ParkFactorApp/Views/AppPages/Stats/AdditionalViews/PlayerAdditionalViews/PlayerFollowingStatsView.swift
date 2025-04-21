//
//  PlayerFollowingStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/6/25.
//

import SwiftUI

struct PlayerFollowingStatsView: View {
    var savedUser: SavedUser
    @State private var tempPlayers: [Player] = []
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            Section {
                ScrollView {
                    VStack {
                        if tempPlayers.isEmpty {
                            Text("N/A")
                                .font(.parkFactorFontBigTextNorwester)
                                .foregroundStyle(Color.white)
                                .padding(.top, 10)
                        } else {
                            ForEach(tempPlayers) { player in
                                PlayerStatsCardView(savedUser: savedUser, player: player, isFollowing: true)
                                    .padding(.bottom, 10)
                            }
                        }
                    }
                }
                .padding(.top, 20)
            }
            .padding()
        }
        .onAppear {
            savePlayersToTemp()
        }
    }
    
    private func savePlayersToTemp() {
        tempPlayers = savedUser.user.followingPlayers
    }
}

#Preview {
    PlayerFollowingStatsView(savedUser: SavedUser())
}
