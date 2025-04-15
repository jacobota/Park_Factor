//
//  PlayerStatsCardView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/10/25.
//

import SwiftUI

struct PlayerStatsCardView: View {
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    var savedUser: SavedUser
    var player: Player
    var isFollowing: Bool
    @State private var hitterStatsHelper: HitterStatsHelper?
    @State private var pitchingStatsHelper: PitchingStatsHelper?
    @State private var isLoading: Bool = true
    @State private var didRetrievePitching: Bool = false
    @State private var didRetrieveHitting: Bool = false
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                if (hitterStatsHelper?.hitterStats) != nil {
                    HitterStatsCardView(savedUser: savedUser, player: player, isFollowing: isFollowing, hitterStatsHelper: hitterStatsHelper ?? HitterStatsHelper(hitterStats: HitterStats(average: nil, babip: nil, walkPercentage: nil, walkToStrikeoutRatio: nil, barrelPercentage: nil, bsr: nil, caughtStealing: nil, contactPercentage: nil, defensiveRunsSaved: nil, errors: nil, exitVelocity: nil, fieldingPercentage: nil, games: nil, hits: nil, homeRuns: nil, hardHitPercentage: nil, iso: nil, strikeoutPercentage: nil, outsAboveAverage: nil, onBasePercentage: nil, onBasePlusSlugging: nil, runs: nil, rbi: nil, sb: nil, sluggingPercentage: nil, swingPercentage: nil, team: "", uzr: nil, war: nil, winProbabilityAdded: nil, zSwingPercentage: nil, maxExitVelocity: nil, sprintSpeed: nil, wOBA: nil, wRCPlus: nil, wSB: nil, xBA: nil, xSlg: nil, xWOBA: nil)))
                } else if (pitchingStatsHelper?.pitchingStats) != nil {
                    PitcherStatsCardView(savedUser: savedUser, player: player, isFollowing: isFollowing, pitchingStatsHelper: pitchingStatsHelper ?? PitchingStatsHelper(pitchingStats: [PitchingStats(babip: nil, walks: nil, walkPercentage: nil, barrelPercentage: nil, completeGames: nil, changeupPercentage: nil, curveballPercentage: nil, era: nil, exitVelocity: nil, fastballPercentage: nil, cutterPercentage: nil, fip: nil, splitterPercentage: nil, games: nil, groundBallPercentage: nil, gamesStarted: nil, hardHitPercentage: nil, inningsPitched: nil, strikeoutPercentage: nil, strikeoutMinusWalkPercentage: nil, losses: nil, locationPlusChangeup: nil, locationPlusCurveball: nil, locationPlusFastball: nil, locationPlusCutter: nil, locationPlusOther: nil, locationPlusSplitter: nil, locationPlusKnuckleCurve: nil, locationPlusSinker: nil, locationPlusSlider: nil, locationPlus: nil, oSwingPercentage: nil, pitchPlusChangeup: nil, pitchPlusCurveball: nil, pitchPlusFastball: nil, pitchPlusCutter: nil, pitchPlusOther: nil, pitchPlusSplitter: nil, pitchPlusKnuckleCurve: nil, pitchPlusSinker: nil, pitchPlusSlider: nil, pitchingPlus: nil, sinkerPercentage: nil, siera: nil, sliderPercentage: nil, strikeouts: nil, saves: nil, stuffPlusChangeup: nil, stuffPlusCurveball: nil, stuffPlusFastball: nil, stuffPlusCutter: nil, stuffPlusOther: nil, stuffPlusSplitter: nil, stuffPlusKnuckleCurve: nil, stuffPlusSinker: nil, stuffPlusSlider: nil, stuffPlus: nil, team: nil, wins: nil, war: nil, whip: nil, velocityChangeup: nil, velocityCurveball: nil, velocityFastball: nil, velocityCutter: nil, velocitySplitter: nil, velocitySinker: nil, velocitySlider: nil, expectedEra: nil, expectedFip: nil)]))
                } else {
                    GenericPlayerCardView(savedUser: savedUser, player: player, isFollowing: isFollowing)
                }
            }
        }
        .onAppear {
            retrieveHitterStats()
            retrievePitcherStats()
        }
    }
    
    private func retrieveHitterStats() {
        // call the network request to retrieve hitter preview stats
        let baseUrl = Env.expressBaseURL
        guard let url = URL(string: "\(baseUrl)/hitters/stats/current-season/\(player.keyFangraphs ?? 0)/\(player.keyMlbam ?? 0)") else {
            errorMessage = "Missing URL"
            errorShow = true
            didRetrieveHitting = true
            checkIfStatsRetrieved()
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                    errorShow = true
                    didRetrieveHitting = true
                    checkIfStatsRetrieved()
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    errorMessage = "Invalid response"
                    errorShow = true
                    didRetrieveHitting = true
                    checkIfStatsRetrieved()
                }
                return
            }
            
            if response.statusCode != 200 {
                DispatchQueue.main.async {
                    errorMessage = "Failed to fetch data: \(response.statusCode)"
                    errorShow = true
                    didRetrieveHitting = true
                    checkIfStatsRetrieved()
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "No data received"
                    errorShow = true
                    didRetrieveHitting = true
                    checkIfStatsRetrieved()
                }
                return
            }
            
            do {
                let decodedStats = try JSONDecoder().decode(HitterStatsHelper.self, from: data)
                DispatchQueue.main.async {
                    hitterStatsHelper = decodedStats
                    didRetrieveHitting = true
                    checkIfStatsRetrieved()
                }
            } catch let error {
                DispatchQueue.main.async {
                    errorMessage = "Failed to decode data: \(error.localizedDescription)"
                    errorShow = true
                    didRetrieveHitting = true
                    checkIfStatsRetrieved()
                }
            }
        }
        dataTask.resume()
    }
    
    private func retrievePitcherStats() {
        // call the network request to retrieve pitcher preview stats
        let baseUrl = Env.expressBaseURL
        guard let url = URL(string: "\(baseUrl)/pitchers/stats/current-season/\(player.keyFangraphs ?? 0)/\(player.keyMlbam ?? 0)") else {
            errorMessage = "Missing URL"
            errorShow = true
            didRetrievePitching = true
            checkIfStatsRetrieved()
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                    errorShow = true
                    didRetrievePitching = true
                    checkIfStatsRetrieved()
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    errorMessage = "Invalid response"
                    errorShow = true
                    didRetrievePitching = true
                    checkIfStatsRetrieved()
                }
                return
            }
            
            if response.statusCode != 200 {
                DispatchQueue.main.async {
                    errorMessage = "Failed to fetch data: \(response.statusCode)"
                    errorShow = true
                    didRetrievePitching = true
                    checkIfStatsRetrieved()
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "No data received"
                    errorShow = true
                    didRetrievePitching = true
                    checkIfStatsRetrieved()
                }
                return
            }
            
            do {
                let decodedStats = try JSONDecoder().decode(PitchingStatsHelper.self, from: data)
                DispatchQueue.main.async {
                    pitchingStatsHelper = decodedStats
                    didRetrievePitching = true
                    checkIfStatsRetrieved()
                }
            } catch let error {
                DispatchQueue.main.async {
                    errorMessage = "Failed to decode data: \(error.localizedDescription)"
                    errorShow = true
                    didRetrievePitching = true
                    checkIfStatsRetrieved()
                }
            }
        }
        
        dataTask.resume()
    }
    
    private func checkIfStatsRetrieved() {
        if didRetrieveHitting && didRetrievePitching {
            isLoading = false
        }
    }
}

// Hitter
//#Preview {
//    PlayerStatsCardView(savedUser: SavedUser(), player: Player(keyBbref: "harpebr03", keyFangraphs: 11579, keyMlbam: 547180, keyRetro: "harpb003", mlbPlayedFirst: 2012, mlbPlayedLast: 2025, nameFirst: "bryce", nameLast: "harper"), isFollowing: true)
//}

// Pitcher
#Preview {
    PlayerStatsCardView(savedUser: SavedUser(), player: Player(keyBbref: "anderty01", keyFangraphs: 12880, keyMlbam: 542881, keyRetro: "andet002", mlbPlayedFirst: 2016, mlbPlayedLast: 2025, nameFirst: "tyler", nameLast: "anderson"), isFollowing: true)
}
