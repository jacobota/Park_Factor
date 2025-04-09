//
//  PlayerTypeIntLeaderboardHelperView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/8/25.
//

import SwiftUI

struct PlayerTypeIntLeaderboardHelperView<T: PlayerStatIntProtocol>: View {
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    let record: T
    let index: Int
    @State private var player: Player?
    
    var body: some View {
        HStack {
            Text("\(index + 1)")
                .font(.parkFactorFontTextNorwester)
                .foregroundStyle(Color.white)
            
            AsyncImage(url: URL(string: "https://img.mlbstatic.com/mlb-photos/image/upload/w_180,d_people:generic:headshot:silo:current.png,q_auto:best,f_auto/v1/people/\(player?.keyMlbam ?? 1)/headshot/silo/current"), scale: 3) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 35, height: 35)
                    .background(getTeamColor(record.team))
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(lineWidth: 0)
                    )
            } placeholder: {
                ProgressView()
            }
            .padding(10)
            
            Text(record.name)
                .font(.parkFactorFontTextNorwester)
                .foregroundStyle(Color.white)
                .frame(width: 150, alignment: .leading)
            
            Spacer()
            Text("\(record.value)")
                .font(.parkFactorFontTextNorwester)
                .foregroundStyle(Color.parkFactorPrimary)
            Spacer()
        }
        .background(Color.black)
        .onAppear{
            retrievePlayer()
        }
    }
    
    private func retrievePlayer() {
        // Get the First and last name of the player
        let playerNameArray = record.name.split(separator: " ")
        var firstName = playerNameArray[0]
        var lastName = playerNameArray[1]
        
        // Some Specialized accents; will need to look further in future
        if firstName == "Fernando" && lastName == "Tatis" {
            lastName = "Tatís"
        } else if firstName == "Jose" && lastName == "Ramirez" {
            firstName = "José"
            lastName = "Ramírez"
        } else if firstName == "J.P." {
            firstName = "j. p."
        } else if firstName == "Jung" && lastName == "Hoo" {
            firstName = "Jung Hoo"
            lastName = "Lee"
        } else if firstName == "Elly" && lastName == "De" {
            firstName = "Elly"
            lastName = "de la cruz"
        } else if firstName == "Luis" && lastName == "Arraez" {
            lastName = "Arráez"
        } else if firstName == "Adolis" && lastName == "Garcia" {
            lastName = "García"
        } else if firstName == "Teoscar" && lastName == "Hernandez" {
            lastName = "Hernández"
        }
        
        // call the network request to retrieve players
        let baseUrl = Env.expressBaseURL
        guard let url = URL(string: "\(baseUrl)/players/player-id/\(firstName)/\(lastName)") else {
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
                let decodedPlayer = try JSONDecoder().decode([Player].self, from: data)
                DispatchQueue.main.async {
                    // Players with historically same name; need to fix later
                    if (firstName == "Will" && lastName == "Smith") ||
                        (firstName == "Jacob" && lastName == "Wilson") ||
                        (firstName == "José" && lastName == "Ramírez") {
                        player = decodedPlayer[1]
                    } else {
                        player = decodedPlayer[0]
                    }
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
    
    private func getTeamColor(_ abbr: String) -> Color {
        switch abbr {
        case "LAA":
            return Color(red: 0.72, green: 0.0, blue: 0.13)
        case "SEA":
            return Color(red: 0.0, green: 0.27, blue: 0.36)
        case "TEX":
            return Color(red: 0.0, green: 0.24, blue: 0.58)
        case "HOU":
            return Color(red: 0.0, green: 0.18, blue: 0.32)
        case "ATH":
            return Color(red: 0.0, green: 0.47, blue: 0.29)
        case "CHW":
            return Color(red: 0.1, green: 0.1, blue: 0.1)
        case "MIN":
            return Color(red: 0.0, green: 0.2, blue: 0.4)
        case "KCR":
            return Color(red: 0.0, green: 0.38, blue: 0.75)
        case "DET":
            return Color(red: 0.0, green: 0.16, blue: 0.31)
        case "CLE":
            return Color(red: 0.6, green: 0.0, blue: 0.0)
        case "NYY":
            return Color(red: 0.12, green: 0.16, blue: 0.29)
        case "BOS":
            return Color(red: 0.51, green: 0.09, blue: 0.13)
        case "TBR":
            return Color(red: 0.0, green: 0.2, blue: 0.42)
        case "TOR":
            return Color(red: 0.0, green: 0.4, blue: 0.8)
        case "BAL":
            return Color(red: 1.0, green: 0.38, blue: 0.0)
        case "SFG":
            return Color(red: 0.84, green: 0.38, blue: 0.13)
        case "LAD":
            return Color(red: 0.0, green: 0.38, blue: 0.67)
        case "SDP":
            return Color(red: 0.38, green: 0.29, blue: 0.0)
        case "ARI":
            return Color(red: 0.45, green: 0.0, blue: 0.09)
        case "COL":
            return Color(red: 0.31, green: 0.09, blue: 0.44)
        case "CHC":
            return Color(red: 0.0, green: 0.32, blue: 0.61)
        case "CIN":
            return Color(red: 0.85, green: 0.01, blue: 0.16)
        case "PIT":
            return Color(red: 0.98, green: 0.78, blue: 0.18)
        case "MIL":
            return Color(red: 0.0, green: 0.2, blue: 0.4)
        case "STL":
            return Color(red: 0.76, green: 0.04, blue: 0.14)
        case "NYM":
            return Color(red: 0.0, green: 0.34, blue: 0.71)
        case "WSN":
            return Color(red: 0.54, green: 0.0, blue: 0.15)
        case "MIA":
            return Color(red: 1.0, green: 0.4, blue: 0.0)
        case "ATL":
            return Color(red: 0.29, green: 0.09, blue: 0.18)
        case "PHI":
            return Color(red: 0.61, green: 0.09, blue: 0.18)
        default:
            return Color.white
        }
    }
}

#Preview {
    PlayerTypeIntLeaderboardHelperView(record: HitsPlayer(team: "CHC", value: 104, name: "Kyle Tucker"), index: 0)
}
