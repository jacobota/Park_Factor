//
//  TeamPageView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/27/25.
//

import SwiftUI

struct TeamPageView: View {
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    var teamAbbr: String
    var savedUser: SavedUser
    
    @State private var team: [Team]?
    @State private var isLoading: Bool = true
    
    var body: some View {
        ZStack {
            Color.parkFactorSecondary.ignoresSafeArea()
            VStack {
                if isLoading {
                    ProgressView()
                } else {
                    if (team) != nil {
                        RespectiveTeamPageView(team: team?.first ?? Team(franchID: "", lgID: "", teamID: "", teamIDBR: "", teamIDfg: 0, teamIDretro: "", yearID: 0), savedUser: savedUser)
                    } else {
                        TeamNoDataPageView(teamAbbr: teamAbbr)
                    }
                }
            }
        }
        .onAppear {
            retrieveTeamId()
        }
    }
    
    private func retrieveTeamId() {
        // call the network request to retrieve team ids
        let baseUrl = Env.expressBaseURL
        guard let url = URL(string: "\(baseUrl)/teams/team-id/\(teamAbbr)") else {
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
                let decodedTeam = try JSONDecoder().decode([Team].self, from: data)
                DispatchQueue.main.async {
                    team = decodedTeam
                    isLoading = false
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
    TeamPageView(teamAbbr: "LAA", savedUser: SavedUser())
}
