//
//  HitterPercentilesStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/16/25.
//

import SwiftUI

struct HitterPercentilesStatsView: View {
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    @State private var isSheetPresented: Bool = false
    @State private var selectedStat: String = ""
    
    var player: Player
    
    @State private var hitterPercentiles: HitterPercentileHelper?
    
    var body: some View {
        VStack {
            if let percentiles = hitterPercentiles?.hitter_percentile {
                VStack {
                    HStack {
                        Text("Hitting Percentiles")
                            .font(.parkFactorFontSubtitleNorwester)
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                    }
                    .padding(20)
                    LazyVGrid(columns: [
                        GridItem(.flexible(minimum: 70 ,maximum: 70)),
                        GridItem(.flexible())
                    ], spacing: 20) {
                        if percentiles[0].batSpeed != nil {
                            Button(action: {
                                selectedStat = "hitter_bat_speed"
                            }) {
                                Text("Bat Speed")
                            }
                            PercentileView(percentile: percentiles[0].batSpeed ?? 0)
                        }
                        if percentiles[0].bbPercent != nil {
                            Button(action: {
                                selectedStat = "hitter_bbpercent"
                            }) {
                                Text("BB%")
                            }
                            PercentileView(percentile: percentiles[0].bbPercent ?? 0)
                        }
                        if percentiles[0].barrel != nil {
                            Button(action: {
                                selectedStat = "hitter_barrels"
                            }) {
                                Text("Barrels")
                            }
                            PercentileView(percentile: percentiles[0].barrel ?? 0)
                        }
                        if percentiles[0].barrelPercent != nil {
                            Button(action: {
                                selectedStat = "hitter_barrelpercent"
                            }) {
                                Text("Barrel%")
                            }
                            PercentileView(percentile: percentiles[0].barrelPercent ?? 0)
                        }
                        if percentiles[0].chasePercent != nil {
                            Button(action: {
                                selectedStat = "hitter_chasepercent"
                            }) {
                                Text("Chase%")
                            }
                            PercentileView(percentile: percentiles[0].chasePercent ?? 0)
                        }
                        if percentiles[0].exitVelocity != nil {
                            Button(action: {
                                selectedStat = "hitter_ev"
                            }) {
                                Text("EV")
                            }
                            PercentileView(percentile: percentiles[0].exitVelocity ?? 0)
                        }
                        if percentiles[0].hardHitPercent != nil {
                            Button(action: {
                                selectedStat = "hitter_hardhitpercent"
                            }) {
                                Text("Hard Hit%")
                            }
                            PercentileView(percentile: percentiles[0].hardHitPercent ?? 0)
                        }
                        if percentiles[0].kPercent != nil {
                            Button(action: {
                                selectedStat = "hitter_kpercent"
                            }) {
                                Text("K%")
                            }
                            PercentileView(percentile: percentiles[0].kPercent ?? 0)
                        }
                        if percentiles[0].maxEv != nil {
                            Button(action: {
                                selectedStat = "hitter_maxev"
                            }) {
                                Text("Max EV")
                            }
                            PercentileView(percentile: percentiles[0].maxEv ?? 0)
                        }
                        if percentiles[0].oaa != nil {
                            Button(action: {
                                selectedStat = "hitter_oaa"
                            }) {
                                Text("OAA")
                            }
                            PercentileView(percentile: percentiles[0].oaa ?? 0)
                        }
                        if percentiles[0].squaredUpRate != nil {
                            Button(action: {
                                selectedStat = "hitter_squarepercent"
                            }) {
                                Text("Square%")
                            }
                            PercentileView(percentile: percentiles[0].squaredUpRate ?? 0)
                        }
                        if percentiles[0].whiffPercent != nil {
                            Button(action: {
                                selectedStat = "hitter_whiffpercent"
                            }) {
                                Text("Whiff%")
                            }
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
                
                VStack {
                    HStack {
                        Text("Expected Percentiles")
                            .font(.parkFactorFontSubtitleNorwester)
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                    }
                    .padding(20)
                    LazyVGrid(columns: [
                        GridItem(.flexible(minimum: 70 ,maximum: 70)),
                        GridItem(.flexible())
                    ], spacing: 20) {
                        if percentiles[0].xba != nil {
                            Button(action: {
                                selectedStat = "hitter_xba"
                            }) {
                                Text("xBA")
                            }
                            PercentileView(percentile: percentiles[0].xba ?? 0)
                        }
                        if percentiles[0].xiso != nil {
                            Button(action: {
                                selectedStat = "hitter_xiso"
                            }) {
                                Text("xISO")
                            }
                            PercentileView(percentile: percentiles[0].xiso ?? 0)
                        }
                        if percentiles[0].xobp != nil {
                            Button(action: {
                                selectedStat = "hitter_xobp"
                            }) {
                                Text("xOBP")
                            }
                            PercentileView(percentile: percentiles[0].xobp ?? 0)
                        }
                        if percentiles[0].xslg != nil {
                            Button(action: {
                                selectedStat = "hitter_xslg"
                            }) {
                                Text("xSLG")
                            }
                            PercentileView(percentile: percentiles[0].xslg ?? 0)
                        }
                        if percentiles[0].xwoba != nil {
                            Button(action: {
                                selectedStat = "hitter_xwoba"
                            }) {
                                Text("xwOBA")
                            }
                            PercentileView(percentile: percentiles[0].xwoba ?? 0)
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
                
                VStack {
                    HStack {
                        Text("Misc Percentiles")
                            .font(.parkFactorFontSubtitleNorwester)
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                    }
                    .padding(20)
                    LazyVGrid(columns: [
                        GridItem(.flexible(minimum: 70 ,maximum: 70)),
                        GridItem(.flexible())
                    ], spacing: 20) {
                        if percentiles[0].armStrength != nil {
                            Button(action: {
                                selectedStat = "hitter_arm"
                            }) {
                                Text("Arm")
                            }
                            PercentileView(percentile: percentiles[0].armStrength ?? 0)
                        }
                        if percentiles[0].sprintSpeed != nil {
                            Button(action: {
                                selectedStat = "hitter_sprint"
                            }) {
                                Text("Sprint")
                            }
                            PercentileView(percentile: percentiles[0].sprintSpeed ?? 0)
                        }
                        else {
                            Text("No Data Available")
                        }
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
        .onChange(of: selectedStat) {
            isSheetPresented = true
        }
        .sheet(isPresented: $isSheetPresented) {
            StatExplanationView(stat: selectedStat)
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
    HitterPercentilesStatsView(player: Player(keyBbref: "troutmi01", keyFangraphs: 10155, keyMlbam: 545361, keyRetro: "troutm001", mlbPlayedFirst: 2011, mlbPlayedLast: 2024, nameFirst: "mike", nameLast: "trout"))
}
