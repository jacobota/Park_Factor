//
//  PlayerTypeIntCardView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/8/25.
//

import SwiftUI

struct PlayerTypeIntCardView<T: PlayerStatIntProtocol>: View {
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
                    PlayerTypeIntLeaderboardHelperView(record: record, isPitching: isPitching, index: index)
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
    PlayerTypeIntCardView(title: "Hits", leaderboardStats: [HitsPlayer(team: "CHC", value: 104, name: "Kyle Tucker"), HitsPlayer(team: "BOS", value: 101, name: "Alex Bregman"), HitsPlayer(team: "STL", value: 100, name: "Lars Nootbaar"), HitsPlayer(team: "NYY", value: 92, name: "Aaron Judge"), HitsPlayer(team: "SDP", value: 92, name: "Manny Machado")], isPitching: false)
}
