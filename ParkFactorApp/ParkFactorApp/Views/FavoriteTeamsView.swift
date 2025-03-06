//
//  FavoriteTeamsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/2/25.
//

import SwiftUI

struct TeamCard: View {
    let teamName: String
    let teamLogo: String
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        HStack {
            Image(teamLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding()
            
            Divider()
                .background(Color.gray.opacity(0.75))
            
            Text(teamName)
                .font(.parkFactorFontSubtitleArchivo)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
                .cornerRadius(5)
        }
        .frame(width: 350, height: 175)
        .background(isSelected ? Color.parkFactorPrimary : Color.white)
        .cornerRadius(20)
        .onTapGesture {
            onSelect()
        }
    }
}

struct FavoriteTeamsView: View {
    @Binding var isLoggedIn: Bool
    @AppStorage("accessToken") private var accessToken: String?
    @State private var selectedTeams: [String] = []
    @State private var didSelectTeams: Bool = false
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    
    var savedUser: SavedUser
    
    let teams: [String: String] = [
        "Los Angeles Angels": "AngelsLogo",
        "Seattle Mariners": "MarinersLogo",
        "Texas Rangers": "RangersLogo",
        "Houston Astros": "AstrosLogo",
        "Oakland A's": "AthleticsLogo",
        "Chicago White Sox": "WhiteSoxLogo",
        "Minnesota Twins": "TwinsLogo",
        "Kansas City Royals": "RoyalsLogo",
        "Detroit Tigers": "TigersLogo",
        "Cleveland Guardians": "GuardiansLogo",
        "New York Yankees": "YankeesLogo",
        "Boston Red Sox": "RedSoxLogo",
        "Tampa Bay Rays": "RaysLogo",
        "Toronto Blue Jays": "BlueJaysLogo",
        "Baltimore Orioles": "OriolesLogo",
        "San Francisco Giants": "GiantsLogo",
        "Los Angeles Dodgers": "DodgersLogo",
        "San Diego Padres": "PadresLogo",
        "Arizona Diamondbacks": "DiamondbacksLogo",
        "Colorado Rockies": "RockiesLogo",
        "Chicago Cubs": "CubsLogo",
        "Cincinnati Reds": "RedsLogo",
        "Pittsburgh Pirates": "PiratesLogo",
        "Milwaukee Brewers": "BrewersLogo",
        "St. Louis Cardinals": "CardinalsLogo",
        "New York Mets": "MetsLogo",
        "Washington Nationals": "NationalsLogo",
        "Miami Marlins": "MarlinsLogo",
        "Atlanta Braves": "BravesLogo",
        "Philadelphia Phillies": "PhilliesLogo",
    ]
    
    var body: some View {
        if didSelectTeams {
            FavoritePlayersView(isLoggedIn: $isLoggedIn, savedUser: savedUser)
        } else {
            ZStack {
                Color.parkFactorSecondary.ignoresSafeArea()
                VStack {
                    Section {
                        Text("Select Favorite Teams")
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
                                ForEach(teams.keys.sorted(), id: \.self) { teamName in
                                    let teamLogo = teams[teamName] ?? "DefaultTeamLogo"
                                    let isSelected = selectedTeams.contains(teamName)
                                    TeamCard(
                                        teamName: teamName,
                                        teamLogo: teamLogo,
                                        isSelected: isSelected,
                                        onSelect: {
                                            toggleTeamSelection(teamName: teamName)
                                        }
                                    )
                                    .animation(.linear(duration: 0.25), value: isSelected)
                                }
                            }
                        }
                    }
                    .padding()
                    
                    Section {
                        Button(action: {
                            Task {
                                await saveFavoriteTeams()
                            }
                        }) {
                            Text(selectedTeams.isEmpty ? "Skip" : "Next")
                                .font(.parkFactorFontTitle)
                                .foregroundColor(Color.parkFactorPrimary)
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    func toggleTeamSelection(teamName: String) {
        // Check if the team is selected if it is then remove it from the selectedTeams array
        // Else append it and sort it so the teams are in order
        if let index = selectedTeams.firstIndex(of: teamName) {
            selectedTeams.remove(at: index)
        } else {
            selectedTeams.append(teamName)
        }
        selectedTeams.sort()
    }
    
    func saveFavoriteTeams() async {
        // save the teams to UserDefaults
        savedUser.user.favoriteTeams = selectedTeams
        
        // save the teams to a Codable to be used by request
        var favoriteTeamsRequest: FavoriteTeamsStruct = FavoriteTeamsStruct()
        favoriteTeamsRequest.favoriteTeams = selectedTeams
        
        // call the network request to save teams to database
        let baseUrl = Env.expressBaseURL
        guard let encoded = try? JSONEncoder().encode(favoriteTeamsRequest) else {
            errorMessage = "Failed to encode favoriteTeams"
            errorShow = true
            return
        }
        
        //create the url
        let url = URL(string: "\(baseUrl)/users/update/favoriteTeams")!
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
            didSelectTeams = true
        } catch {
            errorMessage = error.localizedDescription
            errorShow = true
        }
    }
}

#Preview {
    FavoriteTeamsViewPreviewWrapper()
}

struct FavoriteTeamsViewPreviewWrapper: View {
    @State private var isLoggedIn = false
    @State private var isRegistered = true
    
    var body: some View {
        FavoriteTeamsView(isLoggedIn: $isLoggedIn, savedUser: SavedUser())
    }
}
