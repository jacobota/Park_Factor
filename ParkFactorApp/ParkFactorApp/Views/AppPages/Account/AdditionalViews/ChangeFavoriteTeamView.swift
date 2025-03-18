//
//  ChangeFavoriteTeamView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/16/25.
//

import SwiftUI

struct ChangeFavoriteTeamView: View {
    @AppStorage("accessToken") private var accessToken: String?
    @State private var resultMessage: String = ""
    @State private var resultShow: Bool = false
    @State private var successShow: Bool = false
    @State private var selectedTeam: Team?
    @State private var followingTeams: [Team] = []
    
    var savedUser: SavedUser
    
    var body: some View {
        ZStack {
            Color.parkFactorSecondary.ignoresSafeArea()
            VStack {
                Text("Select Your Favorite Team")
                    .font(.parkFactorFontSubtitleNorwester)
                    .foregroundStyle(Color.parkFactorPrimary)
                    .padding(.bottom, 10)
                
                List {
                    ForEach(followingTeams) { team in
                        TeamCard(team: team, isSelected: selectedTeam?.franchID == team.franchID) {
                            Task {
                                await updateFavoriteTeamFunc(team)
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        Capsule()
                            .fill(Color.parkFactorSecondary)
                            .padding(5))
                }
                .environment(\.defaultMinListRowHeight, 60)
                .listStyle(GroupedListStyle())
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .containerRelativeFrame(.horizontal) { size, axis in
                    size * 0.9
                }
            }
            .padding()
            .background(Color.parkFactorSecondary)
            .cornerRadius(20)
            .padding()
        }
        .onAppear {
            setTeamProperties()
        }
    }
    
    private func setTeamProperties() {
        followingTeams = savedUser.user.followingTeams
        selectedTeam = savedUser.user.favoriteTeam
    }
    
    private func updateFavoriteTeamFunc(_ team: Team) async {
        if selectedTeam?.franchID == team.franchID {
            selectedTeam = nil
        } else {
            selectedTeam = team
        }
        // call the network request to update user tag
        let baseUrl = Env.expressBaseURL
        var updateFavoriteTeamRequest = UpdateFavoriteTeam()
        updateFavoriteTeamRequest.favoriteTeam = selectedTeam
        guard let encoded = try? JSONEncoder().encode(updateFavoriteTeamRequest) else {
            resultMessage = "Failed to encode Favorite Team"
            resultShow = true
            return
        }
        
        //create the url
        let url = URL(string: "\(baseUrl)/users/update/favoriteTeam")!
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
                    resultMessage = decodedNodeError.message
                    resultShow = true
                    return
                }
                
                // Update the favorite team in the savedUser for UserDefaults
                savedUser.user.favoriteTeam = selectedTeam
            }
        } catch {
            resultMessage = error.localizedDescription
            resultShow = true
        }
    }
}

#Preview {
    ChangeFavoriteTeamView(savedUser: SavedUser())
}
