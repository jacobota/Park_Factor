//
//  PlayerStatsCardView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/10/25.
//

import SwiftUI

struct PlayerStatsCardView: View {
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    var savedUser: SavedUser
    var player: Player
    var isFollowing: Bool
    
    var body: some View {
        VStack {
            HStack {
                NavigationLink(destination: TeamPageView(teamAbbr: team.teamIDBR, savedUser: savedUser)) {
                    AsyncImage(url: URL(string: "https://cdn.ssref.net/req/202502211/tlogo/br/\(team.franchID).png"), scale: 3) { image in
                        image
                            .resizable()
                            .scaledToFill()
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
                    
                    Text(team.teamMascot)
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
            Text("\(errorMessage)")
                .font(.parkFactorFontText)
                .foregroundStyle(errorShow ? Color.red : Color.parkFactorPrimary)
                .multilineTextAlignment(.center)
                .opacity(errorShow ? 1 : 0)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 10) {
                // Top Row with stats
                Text("W-L")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("RS")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("RA")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("ERA")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("wOBA")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("WAR")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                
                // Bottom Row with stats (Checks if the value of optionals)
                if let teamStats = teamStats,
                   let batting = teamStats.teamBatting?.first,
                   let pitching = teamStats.teamPitching?.first {
                    Text("\(pitching.wins ?? 0)-\(pitching.losses ?? 0)")
                    Text("\(batting.runs ?? 0)")
                    Text("\(pitching.runs ?? 0)")
                    Text(String(format: "%.2f", pitching.era ?? 0.0))
                    Text(String(format: "%.3f", batting.woba ?? 0.0))
                    Text(String(format: "%.1f", (batting.war ?? 0.0) + (pitching.war ?? 0.0)))
                } else {
                    ProgressView()
                    ProgressView()
                    ProgressView()
                    ProgressView()
                    ProgressView()
                    ProgressView()
                }
            }
            .font(.parkFactorFontSubSectionText)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color.black)
        .cornerRadius(10)
        .onAppear{
            getTeamStats()
        }
    }
}

#Preview {
    PlayerStatsCardView()
}
