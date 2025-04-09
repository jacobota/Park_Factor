//
//  FollowingPagePlayerCard.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/27/25.
//

import SwiftUI

struct FollowingPagePlayerCard: View {
    let player: Player
    let isSelected: Bool
    let onSelect: () -> Void
    var savedUser: SavedUser
    
    var body: some View {
        HStack {
            NavigationLink(destination: PlayerPageView(player: player, savedUser: savedUser)) {
                Spacer()
                AsyncImage(url: URL(string: "https://img.mlbstatic.com/mlb-photos/image/upload/w_180,d_people:generic:headshot:silo:current.png,q_auto:best,f_auto/v1/people/\(player.keyMlbam ?? 1)/headshot/silo/current"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 70)
                        .background(Color.white)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.parkFactorPrimary, lineWidth: 2)
                        )
                } placeholder: {
                    ProgressView()
                }
                .padding(10)
                
                Spacer()
                
                Text("\(player.fullName)")
                    .font(.parkFactorFontTextNorwester)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .cornerRadius(5)
                    .containerRelativeFrame(.horizontal) { size, axis in
                        size * 0.4
                    }
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle")
                    .foregroundStyle(Color.parkFactorPrimary)
                    .opacity(1)
                    .font(.system(size: 30))
                    .padding(10)
                    .onTapGesture {
                        onSelect()
                    }
            } else {
                Image(systemName: "plus.circle")
                    .foregroundStyle(Color.white)
                    .opacity(1)
                    .font(.system(size: 30))
                    .padding(10)
                    .onTapGesture {
                        onSelect()
                    }
            }
            Spacer()
        }
        .background(Color.black)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.parkFactorPrimary, lineWidth: 2)
        )
    }
}

#Preview {
    FollowingPagePlayerCard(player: Player(keyBbref: "troutmi01", keyFangraphs: 10155, keyMlbam: 545361, keyRetro: "troutm001", mlbPlayedFirst: 2011, mlbPlayedLast: 2024, nameFirst: "mike", nameLast: "trout"), isSelected: false, onSelect: {}, savedUser: SavedUser())
}
