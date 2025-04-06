//
//  TeamStatsPageView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/5/25.
//

import SwiftUI

struct TeamStatsPageView: View {
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            Section {
                // Placeholder for a dropdown menu
                VStack {
                    Text("Teams")
                        .font(.parkFactorFontSubtitleNorwester)
                        .foregroundStyle(Color.white)
                        .padding(.top, 10)
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.9))
                        .frame(height: 2)
                        .padding(.top, 10)
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
    TeamStatsPageView()
}
