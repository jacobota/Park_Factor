//
//  PlayerTypeDoubleCardView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/8/25.
//

import SwiftUI

struct PlayerTypeDoubleCardView<T: PlayerStatDoubleProtocol>: View {
    var decimalCount: Int
    var title: String
    var leaderboardStats: [T]
    var isPitching: Bool
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(title)
                        .font(.parkFactorFontSubtitleNorwester)
                        .foregroundStyle(Color.parkFactorPrimary)
                    Spacer()
                }
                ForEach(Array(leaderboardStats.enumerated()), id: \.offset) { index, record in
                    PlayerTypeDoubleLeaderboardHelperView(record: record, decimalCount: decimalCount, isPitching: isPitching, index: index)
                }
            }
            .padding(20)
            .background(Color.parkFactorSecondary)
            .cornerRadius(20)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

#Preview {
    PlayerTypeDoubleCardView(decimalCount: 3, title: "Batting Average", leaderboardStats: [BattingAveragePlayer(team: "LAA", value: 0.302, name: "Mike Trout"), BattingAveragePlayer(team: "ARI", value: 0.299, name: "Corbin Carroll"), BattingAveragePlayer(team: "SDP", value: 0.279, name: "Fernando Tatis Jr."), BattingAveragePlayer(team: "DET", value: 0.274, name: "Spencer Torkelson"), BattingAveragePlayer(team: "PHI", value: 0.274, name: "Bryce Harper")], isPitching: false)
}
