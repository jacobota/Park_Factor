//
//  PlayerNoDataPageView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/15/25.
//

import SwiftUI

struct PlayerNoDataPageView: View {
    var player: Player
    var body: some View {
        ZStack {
            Color.parkFactorSecondary.ignoresSafeArea()
            VStack(spacing: 0) {
                VStack {
                    ScrollView(.horizontal) {
                        HStack {
                            Text(player.fullName)
                                .foregroundStyle(Color.parkFactorPrimary)
                                .font(.parkFactorFontTitle)
                        }
                        .background(Color.parkFactorSecondary)
                        .cornerRadius(8)
                    }
                    .scrollDisabled(true)
                    .frame(height: 25)
                    .padding()
                }
                .background(Color.parkFactorSecondary)
                
                ZStack {
                    Color.parkFactorAppPageBackground.ignoresSafeArea()
                    VStack {
                        Text("Apologies!")
                            .foregroundStyle(Color.parkFactorPrimary)
                            .font(.parkFactorFontTitle)
                        Text("Could not find stats for")
                            .foregroundStyle(Color.parkFactorPrimary)
                            .font(.parkFactorFontTitle)
                            .multilineTextAlignment(.center)
                        Text(player.fullName)
                            .foregroundStyle(Color.parkFactorPrimary)
                            .font(.parkFactorFontTitle)
                    }
                }
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom)
            .padding(.top, 10)
            
        }
    }
}


#Preview {
    PlayerNoDataPageView(player: Player(keyBbref: "skenepa01", keyFangraphs: -1, keyMlbam: 694973, keyRetro: "skenp001", mlbPlayedFirst: 2024, mlbPlayedLast: 2025, nameFirst: "paul", nameLast: "skenes"))
}
