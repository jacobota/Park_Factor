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
    
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            ScrollView {
                Section {
                    VStack {
                        DropDownMenuView(options: options, selectedOption: $selectedOption, showDropdown: $showDropdown)
                    }
                }
            }
        }
    }
}

#Preview {
    PlayerStatsPageView()
}
