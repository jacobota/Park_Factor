//
//  TeamFollowingStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/6/25.
//

import SwiftUI

struct TeamFollowingStatsView: View {
    var savedUser: SavedUser
    @State private var tempTeams: [Team] = []
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            Section {
                ScrollView {
                    VStack {
                        if tempTeams.isEmpty {
                            Text("N/A")
                                .font(.parkFactorFontBigTextNorwester)
                                .foregroundStyle(Color.white)
                                .padding(.top, 10)
                        } else {
                            ForEach(tempTeams) { team in
                                TeamStatsCardView(savedUser: savedUser, team: team, isFollowing: true)
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
            tempTeams = savedUser.user.followingTeams
        }
    }
}

#Preview {
    TeamFollowingStatsView(savedUser: SavedUser())
}
