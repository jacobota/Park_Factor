//
//  PlayerPageView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/27/25.
//

import SwiftUI

struct PlayerPageView: View {
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    var player: Player
    var savedUser: SavedUser
    
    @State private var hitterStatsHelper: HitterStatsHelper?
    @State private var pitchingStatsHelper: PitchingStatsHelper?
    @State private var hitterPreviewStatsHelper: HitterPreviewStatsHelper?
    @State private var pitchingPreviewStatsHelper: PitchingPreviewStatsHelper?
    @State private var isLoading: Bool = true
    @State private var didRetrievePitching: Bool = false
    @State private var didRetrieveHitting: Bool = false
    @State private var didRetrievePitchingPreview: Bool = false
    @State private var didRetrieveHittingPreview: Bool = false
    @State private var foundStat: Bool = false
    
    var body: some View {
        ZStack {
            Color.parkFactorSecondary.ignoresSafeArea()
            VStack {
                if isLoading {
                    ProgressView()
                } else {
                    if (hitterStatsHelper?.hitterStats) != nil {
                        HittersPageView(player: player, hitterStatsHelper: hitterStatsHelper ?? HitterStatsHelper(hitterStats: HitterStats(average: nil, babip: nil, walkPercentage: nil, walkToStrikeoutRatio: nil, barrelPercentage: nil, bsr: nil, caughtStealing: nil, contactPercentage: nil, defensiveRunsSaved: nil, errors: nil, exitVelocity: nil, fieldingPercentage: nil, games: nil, hits: nil, homeRuns: nil, hardHitPercentage: nil, iso: nil, strikeoutPercentage: nil, outsAboveAverage: nil, onBasePercentage: nil, onBasePlusSlugging: nil, runs: nil, rbi: nil, sb: nil, sluggingPercentage: nil, swingPercentage: nil, team: "", uzr: nil, war: nil, winProbabilityAdded: nil, zSwingPercentage: nil, maxExitVelocity: nil, sprintSpeed: nil, wOBA: nil, wRCPlus: nil, wSB: nil, xBA: nil, xSlg: nil, xWOBA: nil)), savedUser: savedUser)
                    } else if (hitterPreviewStatsHelper?.hitterPreviewStats) != nil {
                        HittersPreviewPageView(player: player, hitterPreviewStatsHelper: hitterPreviewStatsHelper ?? HitterPreviewStatsHelper(hitterPreviewStats: [HitterPreviewStats(days: nil, doubles: nil, triples: nil, atBats: nil, age: nil, battingAverage: nil, walks: nil, caughtStealing: nil, games: nil, gdp: nil, hits: nil, hitByPitch: nil, homeRuns: nil, intentionalWalks: nil, level: nil, name: nil, onBasePercentage: nil, onBasePlusSlugging: nil, pa: nil, runs: nil, rbi: nil, sb: nil, sacrificeFlies: nil, sacrificeHits: nil, sluggingPercentage: nil, strikeouts: nil, team: nil, mlbID: nil)]), savedUser: savedUser)
                    } else if (pitchingStatsHelper?.pitchingStats) != nil {
                        PitchersPageView(savedUser: savedUser, player: player, pitchingStatsHelper: pitchingStatsHelper ?? PitchingStatsHelper(pitchingStats: [PitchingStats(babip: nil, walks: nil, walkPercentage: nil, barrelPercentage: nil, completeGames: nil, changeupPercentage: nil, curveballPercentage: nil, era: nil, exitVelocity: nil, fastballPercentage: nil, cutterPercentage: nil, fip: nil, splitterPercentage: nil, games: nil, groundBallPercentage: nil, gamesStarted: nil, hardHitPercentage: nil, inningsPitched: nil, strikeoutPercentage: nil, strikeoutMinusWalkPercentage: nil, losses: nil, locationPlusChangeup: nil, locationPlusCurveball: nil, locationPlusFastball: nil, locationPlusCutter: nil, locationPlusOther: nil, locationPlusSplitter: nil, locationPlusKnuckleCurve: nil, locationPlusSinker: nil, locationPlusSlider: nil, locationPlus: nil, oSwingPercentage: nil, pitchPlusChangeup: nil, pitchPlusCurveball: nil, pitchPlusFastball: nil, pitchPlusCutter: nil, pitchPlusOther: nil, pitchPlusSplitter: nil, pitchPlusKnuckleCurve: nil, pitchPlusSinker: nil, pitchPlusSlider: nil, pitchingPlus: nil, sinkerPercentage: nil, siera: nil, sliderPercentage: nil, strikeouts: nil, saves: nil, stuffPlusChangeup: nil, stuffPlusCurveball: nil, stuffPlusFastball: nil, stuffPlusCutter: nil, stuffPlusOther: nil, stuffPlusSplitter: nil, stuffPlusKnuckleCurve: nil, stuffPlusSinker: nil, stuffPlusSlider: nil, stuffPlus: nil, team: nil, wins: nil, war: nil, whip: nil, velocityChangeup: nil, velocityCurveball: nil, velocityFastball: nil, velocityCutter: nil, velocitySplitter: nil, velocitySinker: nil, velocitySlider: nil, expectedEra: nil, expectedFip: nil)]))
                    } else if (pitchingPreviewStatsHelper?.pitchingPreviewStats) != nil {
                        PitchersPreviewPageView(player: player, pitchingPreviewStatsHelper: pitchingPreviewStatsHelper ?? PitchingPreviewStatsHelper(pitchingPreviewStats: [PitchingPreviewStats(days: nil, doubles: nil, triples: nil, atBats: nil, age: nil, babip: nil, walks: nil, battersFaced: nil, caughtStealing: nil, earnedRuns: nil, era: nil, games: nil, groundBallToFlyBallRatio: nil, gdp: nil, gamesStarted: nil, hits: nil, hitByPitch: nil, homeRuns: nil, intentionalWalks: nil, inningsPitched: nil, losses: nil, lineDrivePercentage: nil, level: nil, name: nil, putouts: nil, popupPercentage: nil, pitches: nil, runs: nil, stolenBases: nil, sacrificeFlies: nil, strikeouts: nil, strikeoutsToWalksRatio: nil, strikeoutsPerNine: nil, saves: nil, strikeLookingPercentage: nil, strikeSwingingPercentage: nil, strikePercentage: nil, team: nil, wins: nil, whip: nil, mlbID: nil)]), savedUser: savedUser)
                    }else {
                        PlayerNoDataPageView(player: player)
                    }
                }
            }
        }
        .onAppear {
            retrieveHitterPreviewStats()
            retrievePitcherPreviewStats()
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
            didRetrieveHitting = false
            checkIfStatsRetrieved()
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                    errorShow = true
                    didRetrieveHitting = false
                    checkIfStatsRetrieved()
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    errorMessage = "Invalid response"
                    errorShow = true
                    didRetrieveHitting = false
                    checkIfStatsRetrieved()
                }
                return
            }
            
            if response.statusCode != 200 {
                DispatchQueue.main.async {
                    errorMessage = "Failed to fetch data: \(response.statusCode)"
                    errorShow = true
                    didRetrieveHitting = false
                    checkIfStatsRetrieved()
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "No data received"
                    errorShow = true
                    didRetrieveHitting = false
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
                    didRetrieveHitting = false
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
            didRetrievePitching = false
            checkIfStatsRetrieved()
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                    errorShow = true
                    didRetrievePitching = false
                    checkIfStatsRetrieved()
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    errorMessage = "Invalid response"
                    errorShow = true
                    didRetrievePitching = false
                    checkIfStatsRetrieved()
                }
                return
            }
            
            if response.statusCode != 200 {
                DispatchQueue.main.async {
                    errorMessage = "Failed to fetch data: \(response.statusCode)"
                    errorShow = true
                    didRetrievePitching = false
                    checkIfStatsRetrieved()
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "No data received"
                    errorShow = true
                    didRetrievePitching = false
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
                    didRetrievePitching = false
                    checkIfStatsRetrieved()
                }
            }
        }
        
        dataTask.resume()
    }
    
    private func retrieveHitterPreviewStats() {
        // call the network request to retrieve hitter preview stats
        let baseUrl = Env.expressBaseURL
        guard let url = URL(string: "\(baseUrl)/hitters/stats/current-season-preview/\(player.keyMlbam ?? 0)") else {
            errorMessage = "Missing URL"
            errorShow = true
            didRetrieveHittingPreview = false
            checkIfStatsRetrieved()
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                    errorShow = true
                    didRetrieveHittingPreview = false
                    checkIfStatsRetrieved()
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    errorMessage = "Invalid response"
                    errorShow = true
                    didRetrieveHittingPreview = false
                    checkIfStatsRetrieved()
                }
                return
            }
            
            if response.statusCode != 200 {
                DispatchQueue.main.async {
                    errorMessage = "Failed to fetch data: \(response.statusCode)"
                    errorShow = true
                    didRetrieveHittingPreview = false
                    checkIfStatsRetrieved()
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "No data received"
                    errorShow = true
                    didRetrieveHittingPreview = false
                    checkIfStatsRetrieved()
                }
                return
            }
            
            do {
                let decodedStats = try JSONDecoder().decode(HitterPreviewStatsHelper.self, from: data)
                DispatchQueue.main.async {
                    hitterPreviewStatsHelper = decodedStats
                    didRetrieveHittingPreview = true
                    checkIfStatsRetrieved()
                }
            } catch let error {
                DispatchQueue.main.async {
                    errorMessage = "Failed to decode data: \(error.localizedDescription)"
                    errorShow = true
                    didRetrieveHittingPreview = false
                    checkIfStatsRetrieved()
                }
            }
        }
        dataTask.resume()
    }
    
    private func retrievePitcherPreviewStats() {
        // call the network request to retrieve pitcher preview stats
        let baseUrl = Env.expressBaseURL
        guard let url = URL(string: "\(baseUrl)/pitchers/stats/current-season-preview/\(player.keyMlbam ?? 0)") else {
            errorMessage = "Missing URL"
            errorShow = true
            didRetrievePitchingPreview = false
            checkIfStatsRetrieved()
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                    errorShow = true
                    didRetrievePitchingPreview = false
                    checkIfStatsRetrieved()
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    errorMessage = "Invalid response"
                    errorShow = true
                    didRetrievePitchingPreview = false
                    checkIfStatsRetrieved()
                }
                return
            }
            
            if response.statusCode != 200 {
                DispatchQueue.main.async {
                    errorMessage = "Failed to fetch data: \(response.statusCode)"
                    errorShow = true
                    didRetrievePitchingPreview = false
                    checkIfStatsRetrieved()
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "No data received"
                    errorShow = true
                    didRetrievePitchingPreview = false
                    checkIfStatsRetrieved()
                }
                return
            }
            
            do {
                let decodedStats = try JSONDecoder().decode(PitchingPreviewStatsHelper.self, from: data)
                DispatchQueue.main.async {
                    pitchingPreviewStatsHelper = decodedStats
                    didRetrievePitchingPreview = true
                    checkIfStatsRetrieved()
                }
            } catch let error {
                DispatchQueue.main.async {
                    errorMessage = "Failed to decode data: \(error.localizedDescription)"
                    errorShow = true
                    didRetrievePitchingPreview = false
                    checkIfStatsRetrieved()
                }
            }
        }
        
        dataTask.resume()
    }
    
    private func checkIfStatsRetrieved() {
        if (hitterStatsHelper?.hitterStats) != nil || (pitchingStatsHelper?.pitchingStats) != nil || (hitterPreviewStatsHelper?.hitterPreviewStats) != nil || (pitchingPreviewStatsHelper?.pitchingPreviewStats) != nil {
            isLoading = false
            foundStat = true
        }
    }
}

// Hitters Preview
#Preview {
    PlayerPageView(player: Player(keyBbref: "troutmi01", keyFangraphs: 10155, keyMlbam: 545361, keyRetro: "troutm001", mlbPlayedFirst: 2011, mlbPlayedLast: 2025, nameFirst: "mike", nameLast: "trout"), savedUser: SavedUser())
}

// Pitchers Preview
//#Preview {
//    PlayerPageView(player: Player(keyBbref: "anderty01", keyFangraphs: 12880, keyMlbam: 542881, keyRetro: "andet002", mlbPlayedFirst: 2016, mlbPlayedLast: 2025, nameFirst: "tyler", nameLast: "anderson"), savedUser: SavedUser())
//}

// Hitters Preview Stats Preview
//#Preview {
//    PlayerPageView(player: Player(keyBbref: "smithca07", keyFangraphs: -1, keyMlbam: 701358, keyRetro: nil, mlbPlayedFirst: 2025, mlbPlayedLast: 2025, nameFirst: "cam", nameLast: "smith"), savedUser: SavedUser())
//}

// Pitchers Preview Stats Preview
//#Preview {
//    PlayerPageView(player: Player(keyBbref: "skenepa01", keyFangraphs: -1, keyMlbam: 694973, keyRetro: "skenp001", mlbPlayedFirst: 2024, mlbPlayedLast: 2025, nameFirst: "paul", nameLast: "skenes"), savedUser: SavedUser())
//}
