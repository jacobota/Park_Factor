//
//  PitcherVisualsStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/19/25.
//

import SwiftUI

struct PitcherVisualsStatsView: View {
    var player: Player
    
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            ScrollView {
                VStack {
                    PitcherPitchArsenalGraphView(player: player)
                }
                .padding(20)
            }
        }
    }
}

#Preview {
    PitcherVisualsStatsView(player: Player(keyBbref: "glasnty01", keyFangraphs: 14374, keyMlbam: 607192, keyRetro: "glast001", mlbPlayedFirst: 2016, mlbPlayedLast: 2025, nameFirst: "tyler", nameLast: "glasnow"))
}
