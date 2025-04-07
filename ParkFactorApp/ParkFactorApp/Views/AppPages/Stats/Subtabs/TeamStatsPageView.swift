//
//  TeamStatsPageView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/5/25.
//

import SwiftUI

struct TeamStatsPageView: View {
    @State private var options: [String] = ["Leaderboards", "Following Teams", "All Teams"]
    
    @State private var selectedOption = "Leaderboards"
    @State private var showDropdown = false
    
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            VStack {
                DropDownMenuView(options: options, selectedOption: $selectedOption, showDropdown: $showDropdown)
                
                ScrollView {
                    if selectedOption == "Leaderboards" {
                        TeamLeaderboardStatsView()
                    } else if selectedOption == "Following Teams" {
                        TeamFollowingStatsView()
                    } else if selectedOption == "All Teams" {
                        AllTeamsStatsView()
                    }
                }
                .padding(.top, 10)
            }
        }
    }
}

#Preview {
    TeamStatsPageView()
}
