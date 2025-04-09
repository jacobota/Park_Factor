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
                VStack {
                    Text("Following Players")
                        .font(.parkFactorFontSubtitleNorwester)
                        .foregroundStyle(Color.parkFactorPrimary)
                        .padding(.top, 10)
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.9))
                        .frame(height: 2)
                        .padding(.top, 10)
                    
                    Section {
                        ScrollView {
                            
                        }
                        .padding(.top, 20)
                    }
                }
                .padding(20)
                .background(Color.parkFactorSecondary)
                .cornerRadius(20)
            }
            .padding()
        }
    }
}

#Preview {
    PlayerFollowingStatsView(savedUser: SavedUser())
}
