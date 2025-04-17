//
//  PlayerOverviewCardView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/16/25.
//

import SwiftUI

struct PlayerOverviewCardView: View {
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    
    var player: Player
    
    @State private var playerOverview: PlayerBioHelper?
    
    var body: some View {
        VStack {
            if let playerBio = playerOverview?.playerBio {
                VStack {
                    HStack {
                        Text("Player Bio")
                            .font(.parkFactorFontSubtitleNorwester)
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                    }
                    .padding(20)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                        // First Row with bio category
                        Text("B / T")
                            .font(.parkFactorFontText)
                            .foregroundColor(Color.gray)
                        Text("Origin")
                            .font(.parkFactorFontText)
                            .foregroundColor(Color.gray)
                        Text("Position")
                            .font(.parkFactorFontText)
                            .foregroundColor(Color.gray)
                        
                        // Second Row with above three categories
                        Text("\(playerBio.battingSide ?? "N/A") / \(playerBio.throwingSide ?? "N/A")")
                        Text("\(playerBio.origin ?? "N/A")")
                        Text("\(playerBio.position ?? "N/A")")
                        
                        // Blank Row for spacing
                        Text("")
                        Text("")
                        Text("")
                        
                        // Third Row with more bio categories
                        Text("Height")
                            .font(.parkFactorFontText)
                            .foregroundColor(Color.gray)
                        Text("Weight")
                            .font(.parkFactorFontText)
                            .foregroundColor(Color.gray)
                        Text("Born")
                            .font(.parkFactorFontText)
                            .foregroundColor(Color.gray)
                        
                        // Fourth Row with above three categories
                        Text("\(playerBio.height ?? "N/A")")
                        Text("\(playerBio.weight ?? "N/A")")
                        Text("\(playerBio.born ?? "N/A")")
                    }
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .background(Color.black)
                .cornerRadius(10)
            }
        }
        .onAppear {
            retrievePlayerBio()
        }
    }
    
    private func retrievePlayerBio() {
        // call the network request to retrieve players bio
        let baseUrl = Env.expressBaseURL
        guard let url = URL(string: "\(baseUrl)/players/player-bio/\(player.keyBbref ?? "")") else {
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
                let decodedBio = try JSONDecoder().decode(PlayerBioHelper.self, from: data)
                DispatchQueue.main.async {
                    playerOverview = decodedBio
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
    PlayerOverviewCardView(player: Player(keyBbref: "troutmi01", keyFangraphs: 10155, keyMlbam: 545361, keyRetro: "troutm001", mlbPlayedFirst: 2011, mlbPlayedLast: 2024, nameFirst: "mike", nameLast: "trout"))
}
