//
//  PitcherCareerStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/17/25.
//

import SwiftUI

struct PitcherCareerStatsView: View {
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    
    var player: Player
    
    @State private var pitchingCareerStatsHelper: PitchingCareerStatsHelper?
    
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            ScrollView {
                VStack {
                    PitcherCareerBasicStatsView(pitchingCareerStatsHelper: pitchingCareerStatsHelper)
                        .padding(.bottom, 10)
                    PitcherCareerAdvancedStatsView(pitchingCareerStatsHelper: pitchingCareerStatsHelper)
                        .padding(.bottom, 10)
                }
                .padding(20)
            }
        }
        .onAppear {
            retrievePlayerCareer()
        }
    }
    
    private func retrievePlayerCareer() {
        // call the network request to retrieve players bio
        let baseUrl = Env.expressBaseURL
        guard let url = URL(string: "\(baseUrl)/pitchers/stats/career/\(player.keyFangraphs ?? 0)/\(player.mlbPlayedFirst ?? 0)/\(player.mlbPlayedLast ?? 0)") else {
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
                let decodedCareerStats = try JSONDecoder().decode(PitchingCareerStatsHelper.self, from: data)
                DispatchQueue.main.async {
                    pitchingCareerStatsHelper = decodedCareerStats
                }
            } catch let error {
                DispatchQueue.main.async {
                    errorMessage = "Failed to decode data: \(error.localizedDescription)"
                    print(errorMessage)
                    errorShow = true
                }
            }
        }
        
        dataTask.resume()
    }
}

#Preview {
    PitcherCareerStatsView(player: Player(keyBbref: "glasnty01", keyFangraphs: 14374, keyMlbam: 607192, keyRetro: "glast001", mlbPlayedFirst: 2016, mlbPlayedLast: 2025, nameFirst: "tyler", nameLast: "glasnow"))
}
