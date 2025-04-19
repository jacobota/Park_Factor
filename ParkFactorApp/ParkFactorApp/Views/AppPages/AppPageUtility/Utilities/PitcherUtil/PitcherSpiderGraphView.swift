//
//  PitcherSpiderGraphView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/19/25.
//

import SwiftUI

let pitcherSides = [
    Ray(maxValue: 100, rayCase: .Xera),
    Ray(maxValue: 100, rayCase: .FastballVelo),
    Ray(maxValue: 100, rayCase: .WhiffPercent),
    Ray(maxValue: 100, rayCase: .StrikoutPercent),
    Ray(maxValue: 100, rayCase: .WalkPercent),
    Ray(maxValue: 100, rayCase: .GroundballPercent)
]

struct PitcherSpiderGraphView: View {
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    
    var player: Player
    var color: Color
    
    @State private var pitcherPercentilesHelper: PitcherPercentileHelper?
    
    var body: some View {
        VStack {
            if let percentiles = pitcherPercentilesHelper?.pitcher_percentile {
                VStack {
                    HStack {
                        Text("Player Summary")
                            .font(.parkFactorFontSubtitleNorwester)
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    SpiderGraphView(sides: pitcherSides, data: DataPoint(rc1: .Xera, rc2: .FastballVelo, rc3: .WhiffPercent, rc4: .StrikoutPercent, rc5: .WalkPercent, rc6: .GroundballPercent, val1: percentiles[0].xera ?? 0, val2: percentiles[0].fbVelocity ?? 0, val3: percentiles[0].whiffPercent ?? 0, val4: percentiles[0].kPercent ?? 0, val5: percentiles[0].bbPercent ?? 0, val6: percentiles[0].whiffPercent ?? 0, color: color))
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
    PitcherSpiderGraphView(player: Player(keyBbref: "glasnty01", keyFangraphs: 14374, keyMlbam: 607192, keyRetro: "glast001", mlbPlayedFirst: 2016, mlbPlayedLast: 2025, nameFirst: "tyler", nameLast: "glasnow"), color: .blue)
}
