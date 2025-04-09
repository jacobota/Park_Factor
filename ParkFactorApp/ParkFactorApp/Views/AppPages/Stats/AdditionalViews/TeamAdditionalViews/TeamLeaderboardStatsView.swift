//
//  TeamLeaderboardStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/6/25.
//

import SwiftUI

struct TeamLeaderboardStatsView: View {
    @State private var options: [String] = ["Team Hitting", "Team Pitching"]
    
    @State private var selectedOption = "Team Hitting"
    @State private var showDropdown = false
    
    var savedUser: SavedUser
    
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            VStack {
                DropDownMenuView(options: options, selectedOption: $selectedOption, showDropdown: $showDropdown)
                if selectedOption == "Team Hitting" {
                    TeamHittingLeaderboardView(savedUser: savedUser)
                        .padding(.vertical, 10)
                } else if selectedOption == "Team Pitching" {
                    TeamPitchingLeaderboardView(savedUser: savedUser)
                        .padding(.vertical, 10)
                }
            }
        }
    }
}

#Preview {
    TeamLeaderboardStatsView(savedUser: SavedUser())
}
