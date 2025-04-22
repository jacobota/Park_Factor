//
//  PitcherPitchArsenalGraphView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/19/25.
//

import SwiftUI

struct ArsenalDataPoint: Identifiable {
    var id = UUID()
    var entries: [PitchPoint]
    
    init(entries: [PitchPoint]) {
        self.entries = entries
    }
}

struct PitcherPitchArsenalGraphView: View {
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    @State private var isSheetPresented: Bool = false
    @State private var selectedStat: String = ""
    
    var player: Player
    
    @State private var pitcherAresenal: PitcherAresenal?
    @State private var pitchPointArray: [PitchPoint] = []
    
    var body: some View {
        VStack {
            if let pitchTypes = pitcherAresenal?.pitcher_arsenal {
                VStack {
                    HStack {
                        Text("Movement Profile")
                            .font(.parkFactorFontSubtitleNorwester)
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                    }
                    .padding(20)
                    PitchGraphView(data: ArsenalDataPoint(entries: pitchPointArray))
                }
                .background(Color.black)
                .cornerRadius(10)
                .padding(.bottom, 10)
                
                // Display Pitch Information
                VStack {
                    HStack {
                        Text("Summary")
                            .font(.parkFactorFontSubtitleNorwester)
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                    }
                    .padding(20)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 5) {
                        // First Row with stat category
                        Text("Type")
                            .font(.parkFactorFontSmallText)
                            .foregroundColor(Color.gray)
                        Button(action: {
                            selectedStat = "pitcher_velo"
                        }) {
                            Text("Velo")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                        }
                        Button(action: {
                            selectedStat = "pitcher_ivb"
                        }) {
                            Text("IVB")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                        }
                        Button(action: {
                            selectedStat = "pitcher_hb"
                        }) {
                            Text("HB")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                        }
                        Button(action: {
                            selectedStat = "pitcher_pitchpercentage"
                        }) {
                            Text("%")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                        }
                        
                        Text("")
                        Text("")
                        Text("")
                        Text("")
                        Text("")
                        
                        // Go through all the pitches and print out information
                        ForEach(pitchTypes) { pitch in
                            Text("\(pitch.shortenedPitchName ?? "N/A")")
                            Text(String(format: "%.1f", NSDecimalNumber(decimal: pitch.avg_speed ?? 0.0).doubleValue))
                            Text(String(format: "%.1f", NSDecimalNumber(decimal: pitch.pitcher_break_x ?? 0.0).doubleValue))
                            Text(String(format: "%.1f", NSDecimalNumber(decimal: pitch.pitcher_break_z_induced ?? 0.0).doubleValue))
                            Text("\(String(format: "%.2f", NSDecimalNumber(decimal: pitch.pitch_percentage_computed ?? 0.0).doubleValue))%")
                            
                            Text("")
                            Text("")
                            Text("")
                            Text("")
                            Text("")
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
                .onChange(of: selectedStat) {
                    isSheetPresented = true
                }
                .sheet(isPresented: $isSheetPresented) {
                    StatExplanationView(stat: selectedStat)
                }
            }
        }
        .onAppear {
            retrievePitcherArsenal()
        }
    }
    
    private func retrievePitcherArsenal() {
        // call the network request to retrieve players bio
        let baseUrl = Env.expressBaseURL
        guard let url = URL(string: "\(baseUrl)/pitchers/stats/pitcher-arsenal/\(player.keyMlbam ?? 0)") else {
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
                let decodedArsenal = try JSONDecoder().decode(PitcherAresenal.self, from: data)
                DispatchQueue.main.async {
                    pitcherAresenal = decodedArsenal
                    if let arsenal = pitcherAresenal?.pitcher_arsenal {
                        for pitch in arsenal {
                            if let pitchPoint = pitch.pitchPoint {
                                pitchPointArray.append(pitchPoint)
                            }
                        }
                    }
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

//#Preview {
//    PitcherPitchArsenalGraphView(player: Player(keyBbref: "glasnty01", keyFangraphs: 14374, keyMlbam: 607192, keyRetro: "glast001", mlbPlayedFirst: 2016, mlbPlayedLast: 2025, nameFirst: "tyler", nameLast: "glasnow"))
//}

//#Preview {
//    PitcherPitchArsenalGraphView(player: Player(keyBbref: "woobr01", keyFangraphs: 30279, keyMlbam: 693433, keyRetro: "woo-b001", mlbPlayedFirst: 2023, mlbPlayedLast: 2025, nameFirst: "bryan", nameLast: "woo"))
//}

#Preview {
    PitcherPitchArsenalGraphView(player: Player(keyBbref: "salech01", keyFangraphs: 10603, keyMlbam: 519242, keyRetro: "salec001", mlbPlayedFirst: 2010, mlbPlayedLast: 2025, nameFirst: "chris", nameLast: "sale"))
}

