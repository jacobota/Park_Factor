//
//  TeamStatsCardView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/9/25.
//

import SwiftUI

struct TeamStatsCardView: View {
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    var savedUser: SavedUser
    var team: Team
    var isFollowing: Bool
    @State private var teamStats: TeamStats?
    
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
                    Text("N/A")
                    Text("N/A")
                    Text("N/A")
                    Text("N/A")
                    Text("N/A")
                    Text("N/A")
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
    
    private func getTeamStats() {
        // call the network request to retrieve team stats
        let baseUrl = Env.expressBaseURL
        guard let url = URL(string: "\(baseUrl)/teamStats/current-season/\(team.teamIDfg)") else {
            errorMessage = "Missing URL"
            errorShow = true
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                    errorShow = true
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    errorMessage = "Invalid response"
                    errorShow = true
                }
                return
            }
            
            if response.statusCode != 200 {
                DispatchQueue.main.async {
                    errorMessage = "Failed to fetch data: \(response.statusCode)"
                    errorShow = true
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "No data received"
                    errorShow = true
                }
                return
            }
            
            do {
                let decodedStats = try JSONDecoder().decode(TeamStats.self, from: data)
                DispatchQueue.main.async {
                    teamStats = decodedStats
                }
            } catch let error {
                DispatchQueue.main.async {
                    errorMessage = "Failed to decode data: \(error.localizedDescription)"
                    errorShow = true
                }
            }
        }
        
        dataTask.resume()
    }
}

#Preview {
    TeamStatsCardView(savedUser: SavedUser(), team: Team(franchID: "ARI", lgID: "NL", teamID: "ARI", teamIDBR: "ARI", teamIDfg: 15, teamIDretro: "ARI", yearID: 2020), isFollowing: true)
}
