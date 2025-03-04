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
                .scaledToFill()
                .frame(width: 75, height: 75)
                .padding()
            
            Text(teamName)
                .font(.parkFactorFontSubtitle)
                .foregroundColor(.black)
                .padding()
        }
        .padding()
        .background(isSelected ? Color.parkFactorPrimary : Color.white)
        .cornerRadius(10)
        .containerRelativeFrame(.horizontal) { size, axis in
            size * 0.99
        }
        .onTapGesture {
            onSelect()
        }
    }
}

struct FavoriteTeamsView: View {
    @Binding var isLoggedIn: Bool
    @State private var selectedTeams: [String] = []
    
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
                .padding(.bottom, 20)
                
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
                            
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func toggleTeamSelection(teamName: String) {
        // Check if the team is selected if it is then remove it from the selectedTeams array
        // Else append it and sort it so the teams are in order
        if let index = selectedTeams.firstIndex(of: teamName) {
            selectedTeams.remove(at: index)
        } else {
            selectedTeams.append(teamName)
        }
        selectedTeams.sort()
    }
}

#Preview {
    FavoriteTeamsViewPreviewWrapper()
}

struct FavoriteTeamsViewPreviewWrapper: View {
    @State private var isLoggedIn = false
    
    var body: some View {
        FavoriteTeamsView(isLoggedIn: $isLoggedIn, savedUser: SavedUser())
    }
}
