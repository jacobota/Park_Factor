//
//  RespectiveTeamPageView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/18/25.
//

import SwiftUI

struct RespectiveTeamPageView: View {
    @AppStorage("accessToken") private var accessToken: String?
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    var team: Team
    var savedUser: SavedUser
    
    @State private var teamStats: TeamStats?
    
    @State var followingTeams: [Team] = []
    
    @State private var selectedTab: String = "Schedule"
    
    let subTabs = ["Schedule", "Hitting", "Pitching"]
    
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
                        Button(action: {
                            Task {
                                await toggleTeamSelection(team: team)
                            }
                        }) {
                            if followingTeams.contains(where: { $0.teamIDBR == team.teamIDBR }) {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(Color.parkFactorPrimary)
                                    .opacity(1)
                                    .font(.system(size: 35))
                            } else {
                                Image(systemName: "star")
                                    .foregroundStyle(Color.white)
                                    .opacity(1)
                                    .font(.system(size: 35))
                            }
                        }
                        .padding(.trailing, 30)
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
                    TeamScheduleStatsView(teamAbbr: team.teamIDBR)
                }
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom)
            .padding(.top, 10)
            .onAppear{
                getTeamStats()
                setFollowingTeamsArray()
            }
        }
    }
    
    private func setFollowingTeamsArray() {
        followingTeams = savedUser.user.followingTeams
    }
    
    private func toggleTeamSelection(team: Team) async {
        // Check if the team is selected if it is then remove it from the selectedTeams array
        // Else append it and sort it so the teams are in order
        if let index = followingTeams.firstIndex(where: { $0.teamName == team.teamName }) {
            followingTeams.remove(at: index)
        } else {
            followingTeams.append(team)
        }
        
        // Send the new selectedTeam to the DB
        var followingTeamsRequest: FollowingTeamsStruct = FollowingTeamsStruct()
        followingTeamsRequest.followingTeams = followingTeams
        
        // call the network request to save teams to database
        let baseUrl = Env.expressBaseURL
        guard let encoded = try? JSONEncoder().encode(followingTeamsRequest) else {
            errorMessage = "Failed to encode followingTeams"
            errorShow = true
            return
        }
        
        //create the url
        let url = URL(string: "\(baseUrl)/users/update/followingTeams")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        
        do {
            let (data, res) = try await URLSession.shared.upload(for: request, from: encoded)
            
            // handle the result if bad
            if let httpResponse = res as? HTTPURLResponse {
                // If the result of the http response is a 400 then the message of what went wrong will be returned and placed in errorMessage
                if httpResponse.statusCode != 201 {
                    let decodedNodeError = try JSONDecoder().decode(NodeError.self, from: data)
                    errorMessage = decodedNodeError.message
                    errorShow = true
                    return
                }
            }
            // save the teams to UserDefaults
            savedUser.user.followingTeams = followingTeams
        } catch {
            errorMessage = error.localizedDescription
            errorShow = true
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
