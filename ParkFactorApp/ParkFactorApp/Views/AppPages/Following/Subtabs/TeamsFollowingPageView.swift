//
//  TeamsFollowingPageView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/8/25.
//

import SwiftUI

struct TeamsFollowingPageView: View {
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            ScrollView {
                Section {
                    VStack {
                        HStack {
                            Text("Teams")
                                .font(.parkFactorFontSubtitleNorwester)
                                .foregroundStyle(Color.white)
                        }
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.9))
                            .frame(height: 2)
                            .padding(.vertical, 10)
                    }
                    .padding(20)
                    .background(Color.parkFactorSecondary)
                    .cornerRadius(20)
                }
                .padding(.top)
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    TeamsFollowingPageView()
}
