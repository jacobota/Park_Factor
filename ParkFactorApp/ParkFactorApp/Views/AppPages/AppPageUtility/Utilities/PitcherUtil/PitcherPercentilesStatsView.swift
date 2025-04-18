//
//  PitcherPercentilesStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/17/25.
//

import SwiftUI

struct PitcherPercentilesStatsView: View {
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    
    var player: Player
    
    @State private var pitcherPercentilesHelper: PitcherPercentileHelper?
    
    var body: some View {
        VStack {
            if let percentiles = pitcherPercentilesHelper?.pitcher_percentile {
                VStack {
                    HStack {
                        Text("Pitching Percentiles")
                            .font(.parkFactorFontSubtitleNorwester)
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                    }
                    .padding(20)
                    LazyVGrid(columns: [
                        GridItem(.flexible(minimum: 70 ,maximum: 70)),
                        GridItem(.flexible())
                    ], spacing: 20) {
                        if percentiles[0].fbVelocity != nil {
                            Text("FB Velo")
                            PercentileView(percentile: percentiles[0].fbVelocity ?? 0)
                        }
                        if percentiles[0].fbSpin != nil {
                            Text("FB Spin")
                            PercentileView(percentile: percentiles[0].fbSpin ?? 0)
                        }
                        if percentiles[0].bbPercent != nil {
                            Text("BB%")
                            PercentileView(percentile: percentiles[0].bbPercent ?? 0)
                        }
                        if percentiles[0].barrel != nil {
                            Text("Barrels")
                            PercentileView(percentile: percentiles[0].barrel ?? 0)
                        }
                        if percentiles[0].chasePercent != nil {
                            Text("Chase%")
                            PercentileView(percentile: percentiles[0].chasePercent ?? 0)
                        }
                        if percentiles[0].exitVelocity != nil {
                            Text("EV")
                            PercentileView(percentile: percentiles[0].exitVelocity ?? 0)
                        }
                        if percentiles[0].hardHitPercent != nil {
                            Text("Hard Hit%")
                            PercentileView(percentile: percentiles[0].hardHitPercent ?? 0)
                        }
                        if percentiles[0].kPercent != nil {
                            Text("K%")
                            PercentileView(percentile: percentiles[0].kPercent ?? 0)
                        }
                        if percentiles[0].maxEv != nil {
                            Text("Max EV")
                            PercentileView(percentile: percentiles[0].maxEv ?? 0)
                        }
                        if percentiles[0].whiffPercent != nil {
                            Text("Whiff%")
                            PercentileView(percentile: percentiles[0].whiffPercent ?? 0)
                        }
                    }
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .background(Color.black)
                .cornerRadius(10)
                .padding(.bottom, 10)
            }
        }
        .onAppear {
            retrievePitcherPercentiles()
        }
    }
    
    private func retrievePitcherPercentiles() {
        // call the network request to retrieve players bio
        let baseUrl = Env.expressBaseURL
        guard let url = URL(string: "\(baseUrl)/pitchers/stats/percentiles/\(player.keyMlbam ?? 0)") else {
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
                let decodedPercentiles = try JSONDecoder().decode(PitcherPercentileHelper.self, from: data)
                DispatchQueue.main.async {
                    pitcherPercentilesHelper = decodedPercentiles
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
    PitcherPercentilesStatsView(player: Player(keyBbref: "glasnty01", keyFangraphs: 14374, keyMlbam: 607192, keyRetro: "glast001", mlbPlayedFirst: 2016, mlbPlayedLast: 2025, nameFirst: "tyler", nameLast: "glasnow"))
}
