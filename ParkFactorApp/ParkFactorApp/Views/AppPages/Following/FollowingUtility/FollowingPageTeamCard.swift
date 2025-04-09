//
//  FollowingPageTeamCard.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/27/25.
//

import SwiftUI

struct FollowingPageTeamCard: View {
    let team: Team
    let isSelected: Bool
    let onSelect: () -> Void
    var savedUser: SavedUser
    
    var body: some View {
        HStack {
            NavigationLink(destination: TeamPageView(teamAbbr: team.teamIDBR, savedUser: savedUser)) {
                Spacer()
                AsyncImage(url: URL(string: "https://cdn.ssref.net/req/202502211/tlogo/br/\(team.franchID).png"), scale: 3) { image in
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
                
                Text(team.teamName)
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
    FollowingPageTeamCard(team: Team(franchID: "ANA", lgID: "AL", teamID: "LAA", teamIDBR: "LAA", teamIDfg: 1, teamIDretro: "ANA", yearID: 2020), isSelected: false, onSelect: {}, savedUser: SavedUser())
}
