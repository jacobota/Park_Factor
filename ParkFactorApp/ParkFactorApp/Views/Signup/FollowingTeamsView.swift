//
//  FollowingTeamsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/2/25.
//

import SwiftUI

struct TeamCard: View {
    let team: Team
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: "https://cdn.ssref.net/req/202502211/tlogo/br/\(team.franchID).png"), scale: 3) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: .infinity, height: .infinity)
            .padding()
            .background(Color.white)
            
            Text(team.teamName)
                .font(.parkFactorFontBigTextNorwester)
                .foregroundColor(isSelected ? Color.parkFactorSecondary : Color.parkFactorPrimary)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
                .cornerRadius(5)
        }
        .frame(width: 335, height: 135)
        .background(isSelected ? Color.parkFactorPrimary : Color.black)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.parkFactorPrimary, lineWidth: 5)
        )
        .padding(15)
        .onTapGesture {
            onSelect()
        }
    }
}

struct FollowingTeamsView: View {
    @Binding var isLoggedIn: Bool
    @AppStorage("accessToken") private var accessToken: String?
    @State private var didSelectTeams: Bool = false
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    @State private var teams: [Team] = []
    @State private var selectedTeams: [Team] = []
    
    var savedUser: SavedUser
    
    var body: some View {
        if didSelectTeams {
            FollowingPlayersView(isLoggedIn: $isLoggedIn, savedUser: savedUser)
        } else {
            ZStack {
                Color.parkFactorSecondary.ignoresSafeArea()
                VStack {
                    Section {
                        Text("Select Following Teams")
                            .font(.parkFactorFontTitle)
                            .foregroundStyle(Color.white)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    .padding(.bottom, 30)
                    
                    Text("\(errorMessage)")
                        .font(.parkFactorFontText)
                        .foregroundStyle(Color.red)
                        .multilineTextAlignment(.center)
                        .opacity(errorShow ? 1 : 0)
                    
                    Section {
                        ScrollView {
                            LazyVStack(spacing: 30) {
                                // ForEach loop looks at the dictionary of teams and creates a team
                                // card that displays the teams with their logos and allows for selection
                                ForEach(teams) { team in
                                    let isSelected = selectedTeams.contains { $0.id == team.id }
                                    TeamCard(
                                        team: team,
                                        isSelected: isSelected,
                                        onSelect: {
                                            toggleTeamSelection(team: team)
                                        }
                                    )
                                    .animation(.linear(duration: 0.25), value: isSelected)
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                    .padding()
                    
                    Section {
                        Button(action: {
                            Task {
                                await saveFollowingTeams()
                            }
                        }) {
                            Text(selectedTeams.isEmpty ? "Skip" : "Next")
                                .font(.parkFactorFontTitle)
                                .foregroundColor(Color.parkFactorPrimary)
                        }
                    }
                }
                .padding()
                .onAppear {
                    fetchTeams()
                }
            }
        }
    }
    
    func fetchTeams() {
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
    
    func toggleTeamSelection(team: Team) {
        // Check if the team is selected if it is then remove it from the selectedTeams array
        // Else append it and sort it so the teams are in order
        if let index = selectedTeams.firstIndex(where: { $0.teamName == team.teamName }) {
            selectedTeams.remove(at: index)
        } else {
            selectedTeams.append(team)
        }
    }
    
    func saveFollowingTeams() async {
        // save the teams to a Codable to be used by request
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
            didSelectTeams = true
        } catch {
            errorMessage = error.localizedDescription
            errorShow = true
        }
    }
}

#Preview {
    FollowingTeamsViewPreviewWrapper()
}

struct FollowingTeamsViewPreviewWrapper: View {
    @State private var isLoggedIn = false
    @State private var isRegistered = true
    
    var body: some View {
        FollowingTeamsView(isLoggedIn: $isLoggedIn, savedUser: SavedUser())
    }
}
