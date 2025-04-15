//
//  GenericPlayerCardView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/14/25.
//

import SwiftUI

struct GenericPlayerCardView: View {
    var savedUser: SavedUser
    var player: Player
    var isFollowing: Bool
    
    var body: some View {
        VStack {
            HStack {
                NavigationLink(destination: PlayerPageView(player: player, savedUser: savedUser)) {
                    AsyncImage(url: URL(string: "https://img.mlbstatic.com/mlb-photos/image/upload/w_180,d_people:generic:headshot:silo:current.png,q_auto:best,f_auto/v1/people/\(player.keyMlbam ?? 1)/headshot/silo/current"), scale: 3) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .background(Color.white)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(lineWidth: 0)
                            )
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Spacer()
                    
                    Text(player.fullName)
                        .font(.parkFactorFontSubtitleNorwester)
                        .foregroundStyle(Color.white)
                        .frame(width: 175, alignment: .leading)
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    if isFollowing {
                        Image(systemName: "star.circle")
                            .foregroundStyle(Color.parkFactorPrimary)
                            .font(.system(size: 24))
                    }
                }
            }
            .padding(20)
        }
        .background(Color.black)
        .cornerRadius(10)
    }
}

#Preview {
    GenericPlayerCardView(savedUser: SavedUser(), player: Player(keyBbref: "troutmi01", keyFangraphs: 10155, keyMlbam: 545361, keyRetro: "troum001", mlbPlayedFirst: 2011, mlbPlayedLast: 2025, nameFirst: "mike", nameLast: "trout"), isFollowing: true)
}
