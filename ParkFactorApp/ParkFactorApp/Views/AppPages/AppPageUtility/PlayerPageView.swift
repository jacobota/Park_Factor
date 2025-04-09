//
//  PlayerPageView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/27/25.
//

import SwiftUI

struct PlayerPageView: View {
    var player: Player
    var savedUser: SavedUser
    var body: some View {
        Text(player.fullName)
    }
}

#Preview {
    PlayerPageView(player: Player(keyBbref: "troutmi01", keyFangraphs: 10155, keyMlbam: 545361, keyRetro: "troutm001", mlbPlayedFirst: 2011, mlbPlayedLast: 2024, nameFirst: "mike", nameLast: "trout"), savedUser: SavedUser())
}
