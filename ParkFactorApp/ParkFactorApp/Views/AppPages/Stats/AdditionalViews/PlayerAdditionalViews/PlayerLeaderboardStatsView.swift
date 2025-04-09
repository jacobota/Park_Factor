//
//  PlayerLeaderboardStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/6/25.
//

import SwiftUI

struct PlayerLeaderboardStatsView: View {
    @State private var options: [String] = ["Hitting", "Pitching"]
    
    @State private var selectedOption = "Hitting"
    @State private var showDropdown = false
    
    var savedUser: SavedUser
    
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            VStack {
                DropDownMenuView(options: options, selectedOption: $selectedOption, showDropdown: $showDropdown)
                if selectedOption == "Hitting" {
                    PlayerHittingLeaderboardView(savedUser: savedUser)
                        .padding(.vertical, 10)
                } else if selectedOption == "Pitching" {
                    PlayerPitchingLeaderboardView(savedUser: savedUser)
                        .padding(.vertical, 10)
                }
            }
        }
    }
}

#Preview {
    PlayerLeaderboardStatsView(savedUser: SavedUser())
}
