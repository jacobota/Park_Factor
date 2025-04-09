//
//  PlayerStatsPageView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/5/25.
//

import SwiftUI

struct PlayerStatsPageView: View {
    @State private var options: [String] = ["Leaderboards", "Following Players", "Player Lookup"]
    
    @State private var selectedOption = "Leaderboards"
    @State private var showDropdown = false
    
    var savedUser: SavedUser
    
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            VStack {
                DropDownMenuView(options: options, selectedOption: $selectedOption, showDropdown: $showDropdown)
                
                ScrollView {
                    if selectedOption == "Leaderboards" {
                        PlayerLeaderboardStatsView(savedUser: savedUser)
                    } else if selectedOption == "Following Players" {
                        PlayerFollowingStatsView(savedUser: savedUser)
                    } else if selectedOption == "Player Lookup" {
                        PlayerLookupStatsView(savedUser: savedUser)
                    }
                }
                .padding(.top, 10)
            }
        }
    }
}

#Preview {
    PlayerStatsPageView(savedUser: SavedUser())
}
