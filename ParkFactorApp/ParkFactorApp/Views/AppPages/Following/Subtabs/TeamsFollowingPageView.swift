//
//  TeamsFollowingPageView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/8/25.
//

import SwiftUI

struct TeamsFollowingPageView: View {
    @AppStorage("accessToken") private var accessToken: String?
    @State private var didSelectTeams: Bool = false
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    @State private var teams: [Team] = []
    @State private var selectedTeams: [Team] = []
    
    var savedUser: SavedUser
    
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            Section {
                VStack {
                    Text("Teams")
                        .font(.parkFactorFontSubtitleNorwester)
                        .foregroundStyle(Color.white)
                        .padding(.top, 10)
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.9))
                        .frame(height: 2)
                        .padding(.top, 10)
                    
                    Section {
                        ScrollView {
                            LazyVStack(spacing: 30) {
                                let unselectedTeams = teams.filter { team in
                                    !selectedTeams.contains { $0.teamIDBR == team.teamIDBR }
                                }
                                ForEach(selectedTeams) { team in
                                    let isSelected = selectedTeams.contains { $0.teamIDBR == team.teamIDBR }
                                    FollowingPageTeamCard(
                                        team: team,
                                        isSelected: isSelected,
                                        onSelect: {
                                            Task {
                                                await toggleTeamSelection(team: team)
                                            }
                                        }
                                    )
                                    .animation(.linear(duration: 0.25), value: isSelected)
                                }
                                ForEach(unselectedTeams) { team in
                                    let isSelected = selectedTeams.contains { $0.teamIDBR == team.teamIDBR }
                                    FollowingPageTeamCard(
                                        team: team,
                                        isSelected: isSelected,
                                        onSelect: {
                                            Task {
                                                await toggleTeamSelection(team: team)
                                            }
                                        }
                                    )
                                    .animation(.linear(duration: 0.25), value: isSelected)
                                }
                            }
                        }
                        .padding(.top, 5)
                        .scrollIndicators(.hidden)
                    }
                }
                .padding(20)
                .background(Color.parkFactorSecondary)
                .cornerRadius(20)
            }
            .padding()
        }
        .onAppear {
            Task {
                await fetchTeams()
            }
        }
    }
    
    private func fetchTeams() async {
        // call the network request to retrieve teams
        let baseUrl = Env.expressBaseURL
        guard let url = URL(string: "\(baseUrl)/teams/mlb-teams") else {
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
                let decodedTeams = try JSONDecoder().decode([Team].self, from: data)
                DispatchQueue.main.async {
                    selectedTeams = savedUser.user.followingTeams
                    teams = decodedTeams
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
    
    private func toggleTeamSelection(team: Team) async {
        // Check if the team is selected if it is then remove it from the selectedTeams array
        // Else append it and sort it so the teams are in order
        if let index = selectedTeams.firstIndex(where: { $0.teamName == team.teamName }) {
            selectedTeams.remove(at: index)
        } else {
            selectedTeams.append(team)
        }
        
        // Send the new selectedTeam to the DB
        var followingTeamsRequest: FollowingTeamsStruct = FollowingTeamsStruct()
        followingTeamsRequest.followingTeams = selectedTeams
        
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
            savedUser.user.followingTeams = selectedTeams
        } catch {
            errorMessage = error.localizedDescription
            errorShow = true
        }
    }
}

#Preview {
    TeamsFollowingPageView(savedUser: SavedUser())
}
