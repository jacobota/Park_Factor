//
//  HitterSpiderGraphView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/18/25.
//

import SwiftUI

enum RayCase: String, CaseIterable {
    // Hitter Ray Cases
    case Xwoba = "xwOBA"
    case ExitVelocity = "EV"
    case BarrelPercent = "Barrel%"
    case OutsAboveAverage = "OAA"
    // Pitcher Ray Cases
    case Xera = "xERA"
    case FastballVelo = "FB Velo"
    case WhiffPercent = "Whiff%"
    case GroundballPercent = "GB%"
    // Used for both Hitters and Pitchers
    case StrikoutPercent = "K%"
    case WalkPercent = "BB%"
}

struct DataPoint: Identifiable {
    var id = UUID()
    var entries: [RayEntry]
    var color: Color
    
    init(rc1: RayCase, rc2: RayCase, rc3: RayCase, rc4: RayCase, rc5: RayCase, rc6: RayCase, val1: Int, val2: Int, val3: Int, val4: Int, val5: Int, val6: Int, color: Color) {
        self.entries = [
            RayEntry(rayCase: rc1, value: val1),
            RayEntry(rayCase: rc2, value: val2),
            RayEntry(rayCase: rc3, value: val3),
            RayEntry(rayCase: rc4, value: val4),
            RayEntry(rayCase: rc5, value: val5),
            RayEntry(rayCase: rc6, value: val6)
        ]
        self.color = color
    }
}

// Different Sides with their max values
let hitterSides = [
    Ray(maxValue: 100, rayCase: .Xwoba),
    Ray(maxValue: 100, rayCase: .ExitVelocity),
    Ray(maxValue: 100, rayCase: .BarrelPercent),
    Ray(maxValue: 100, rayCase: .StrikoutPercent),
    Ray(maxValue: 100, rayCase: .WalkPercent),
    Ray(maxValue: 100, rayCase: .OutsAboveAverage)
]

struct HitterSpiderGraphView: View {
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    
    var player: Player
    var color: Color
    
    @State private var hitterPercentiles: HitterPercentileHelper?
    
    var body: some View {
        VStack {
            if let percentiles = hitterPercentiles?.hitter_percentile {
                VStack {
                    HStack {
                        Text("Player Summary")
                            .font(.parkFactorFontSubtitleNorwester)
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    SpiderGraphView(sides: hitterSides, data: DataPoint(rc1: .Xwoba, rc2: .ExitVelocity, rc3: .BarrelPercent, rc4: .StrikoutPercent, rc5: .WalkPercent, rc6: .OutsAboveAverage, val1: percentiles[0].xwoba ?? 0, val2: percentiles[0].exitVelocity ?? 0, val3: percentiles[0].barrelPercent ?? 0, val4: percentiles[0].kPercent ?? 0, val5: percentiles[0].bbPercent ?? 0, val6: percentiles[0].oaa ?? 0, color: color))
                }
                .background(Color.black)
                .cornerRadius(10)
                .padding(.bottom, 10)
            }
        }
        .onAppear {
            retrievePlayerPercentiles()
        }
    }
    
    private func retrievePlayerPercentiles() {
        // call the network request to retrieve players bio
        let baseUrl = Env.expressBaseURL
        guard let url = URL(string: "\(baseUrl)/hitters/stats/percentiles/\(player.keyMlbam ?? 0)") else {
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
                let decodedPercentiles = try JSONDecoder().decode(HitterPercentileHelper.self, from: data)
                DispatchQueue.main.async {
                    hitterPercentiles = decodedPercentiles
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
    HitterSpiderGraphView(player: Player(keyBbref: "troutmi01", keyFangraphs: 10155, keyMlbam: 545361, keyRetro: "troutm001", mlbPlayedFirst: 2011, mlbPlayedLast: 2024, nameFirst: "mike", nameLast: "trout"), color: Color(red: 0.72, green: 0.0, blue: 0.13))
}
