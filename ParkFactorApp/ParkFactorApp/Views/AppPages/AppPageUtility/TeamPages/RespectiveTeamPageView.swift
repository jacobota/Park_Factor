//
//  RespectiveTeamPageView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/18/25.
//

import SwiftUI

struct RespectiveTeamPageView: View {
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    var team: Team
    var savedUser: SavedUser
    
    @State private var teamStats: TeamStats?
    
    @State private var selectedTab: String = "Hitting"
    
    let subTabs = ["Hitting", "Pitching", "Schedule"]
    
    var body: some View {
        ZStack {
            Color.parkFactorSecondary.ignoresSafeArea()
            VStack(spacing: 0) {
                VStack {
                    HStack {
                        AsyncImage(url: URL(string: "https://cdn.ssref.net/req/202502211/tlogo/br/\(team.franchID).png"), scale: 3) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 90)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(lineWidth: 0)
                                )
                        } placeholder: {
                            ProgressView()
                        }
                        .padding(.horizontal, 20)
                        VStack(alignment: .leading) {
                            Text(team.teamCity)
                                .foregroundStyle(Color.white)
                                .font(.parkFactorFontSubtitleNorwester)
                                .frame(width: 175, alignment: .leading)
                                .lineLimit(1)
                                .minimumScaleFactor(0.3)
                            Text("")
                            Text(team.teamMascot)
                                .foregroundStyle(Color.white)
                                .font(.parkFactorFontBigTextNorwester)
                                .frame(width: 175, alignment: .leading)
                                .lineLimit(1)
                                .minimumScaleFactor(0.3)
                        }
                        Spacer()
                    }
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(subTabs, id: \.self) { subTab in
                                Button(action: {
                                    selectedTab = subTab
                                }) {
                                    Text(subTab)
                                        .font(Font.parkFactorFontTextNorwester)
                                        .foregroundColor(selectedTab == subTab ? Color.parkFactorPrimary : Color.gray)
                                        .padding()
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .background(Color.parkFactorSecondary)
                        .cornerRadius(8)
                    }
                    .frame(height: 25)
                    .padding()
                }
                .background(Color.parkFactorSecondary)
                
                if selectedTab == "Hitting" {
                    TeamHittingSeasonStatsView(teamStats: teamStats ?? TeamStats(teamBatting: [TeamBatting(average: nil, age: nil, babip: nil, walks: nil, bbPercentage: nil, bbToK: nil, bsr: nil, cs: nil, hits: nil, hr: nil, iso: nil, kPercentage: nil, obp: nil, ops: nil, runs: nil, sb: nil, slg: nil, strikeout: nil, war: nil, woba: nil, wrcPlus: nil, wsb: nil)], teamFielding: [TeamFielding(drs: nil, errors: nil, fieldingPercentage: nil, oaa: nil)], teamPitching: [TeamPitching(average: nil, babip: nil, walks: nil, bbPercentage: nil, era: nil, fip: nil, gbPercentage: nil, hitsAllowed: nil, hrPerFb: nil, kPercentage: nil, kMinusBbPercentage: nil, losses: nil, lobPercentage: nil, locationPlus: nil, pitchingPlus: nil, runs: nil, siera: nil, strikeouts: nil, saves: nil, stuffPlus: nil, wins: nil, war: nil, whip: nil, vfaPi: nil, xfip: nil)]))
                } else if selectedTab == "Pitching" {
                    TeamPitchingSeasonStatsView(teamStats: teamStats ?? TeamStats(teamBatting: [TeamBatting(average: nil, age: nil, babip: nil, walks: nil, bbPercentage: nil, bbToK: nil, bsr: nil, cs: nil, hits: nil, hr: nil, iso: nil, kPercentage: nil, obp: nil, ops: nil, runs: nil, sb: nil, slg: nil, strikeout: nil, war: nil, woba: nil, wrcPlus: nil, wsb: nil)], teamFielding: [TeamFielding(drs: nil, errors: nil, fieldingPercentage: nil, oaa: nil)], teamPitching:  [TeamPitching(average: nil, babip: nil, walks: nil, bbPercentage: nil, era: nil, fip: nil, gbPercentage: nil, hitsAllowed: nil, hrPerFb: nil, kPercentage: nil, kMinusBbPercentage: nil, losses: nil, lobPercentage: nil, locationPlus: nil, pitchingPlus: nil, runs: nil, siera: nil, strikeouts: nil, saves: nil, stuffPlus: nil, wins: nil, war: nil, whip: nil, vfaPi: nil, xfip: nil)]))
                } else if selectedTab == "Schedule" {
                    TeamScheduleStatsView()
                }
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom)
            .padding(.top, 10)
            .onAppear{
                getTeamStats()
            }
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
    RespectiveTeamPageView(team: Team(franchID: "ANA", lgID: "AL", teamID: "LAA", teamIDBR: "LAA", teamIDfg: 1, teamIDretro: "ANA", yearID: 2020), savedUser: SavedUser())
}
