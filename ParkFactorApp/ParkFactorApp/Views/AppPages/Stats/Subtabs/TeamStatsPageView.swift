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
    TeamStatsPageView()
}
