//
//  PlayerFollowingStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/6/25.
//

import SwiftUI

struct PlayerFollowingStatsView: View {
    var savedUser: SavedUser
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
                            ForEach(savedUser.user.followingPlayers) { player in
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
    }
}

#Preview {
    PlayerFollowingStatsView(savedUser: SavedUser())
}
