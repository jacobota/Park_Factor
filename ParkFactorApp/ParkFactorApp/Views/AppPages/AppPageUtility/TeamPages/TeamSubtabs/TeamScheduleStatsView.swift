//
//  TeamScheduleStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/18/25.
//

import SwiftUI

struct TeamScheduleStatsView: View {
    //let todaysDate: Date = Date()
    @State private var selectedDate: Date = Date()
    // Get date range of the current season
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2025, month: 3, day: 17)
        let endComponents = DateComponents(year: 2025, month: 11, day: 10)
        return calendar.date(from:startComponents)! ... calendar.date(from:endComponents)!
    }()
    
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    @State private var scheduleAndResults: ScheduleAndResults?
    @State private var lastGamePlayed: GameDetails?
    @State private var selectedGameDetails: GameDetails?
    
    let teamAbbr: String
    var teamAbbrForRequest: String {
        switch teamAbbr {
        case "OAK":
            return "ATH"
        default:
            return teamAbbr
        }
    }
    
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            ScrollView {
                VStack {
                    TeamOverviewCardView(gameDetails: lastGamePlayed ?? GameDetails(attendance: nil, dayOrNight: nil, date: nil, gb: nil, homeAway: nil, inn: nil, loss: nil, opp: nil, origScheduled: nil, r: nil, ra: nil, rank: nil, save: nil, streak: nil, time: nil, tm: nil, record: nil, wl: nil, win: nil, cli: nil))
                    TeamGameDetailsCardView(gameDetails: lastGamePlayed ?? GameDetails(attendance: nil, dayOrNight: nil, date: nil, gb: nil, homeAway: nil, inn: nil, loss: nil, opp: nil, origScheduled: nil, r: nil, ra: nil, rank: nil, save: nil, streak: nil, time: nil, tm: nil, record: nil, wl: nil, win: nil, cli: nil), previousGame: true)
                    HStack {
                        Spacer()
                        DatePicker("", selection: $selectedDate, in: dateRange, displayedComponents: .date)
                            .frame(width: 125, height: 40, alignment: .trailing)
                            .background(Color.white)
                    }
                    .padding(10)
                    if selectedGameDetails != nil {
                        TeamGameDetailsCardView(gameDetails: selectedGameDetails ?? GameDetails(attendance: nil, dayOrNight: nil, date: nil, gb: nil, homeAway: nil, inn: nil, loss: nil, opp: nil, origScheduled: nil, r: nil, ra: nil, rank: nil, save: nil, streak: nil, time: nil, tm: nil, record: nil, wl: nil, win: nil, cli: nil), previousGame: false)
                    } else {
                        TeamGameDetailsCardView(gameDetails: nil, previousGame: false)
                    }
                }
                .padding(20)
            }
        }
        .onChange(of: selectedDate) {
            getGameOnDate()
        }
        .onAppear {
            getScheduleAndResults()
        }
    }
    
    private func getGameOnDate() {
        // Get the string of the Date being picked
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        let stringedDate = dateFormatter.string(from: selectedDate)
        // Filter for the GameDetail with the same date
        let selectedGame = scheduleAndResults?.scheduleAndResults.filter { $0.date == stringedDate }
        selectedGameDetails = selectedGame?.first
    }
    
    private func getScheduleAndResults() {
        // call the network request to retrieve schedule and records for a team
        let baseUrl = Env.expressBaseURL
        guard let url = URL(string: "\(baseUrl)/teams/team-schedule/\(teamAbbrForRequest)") else {
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
                let decodedSchedule = try JSONDecoder().decode(ScheduleAndResults.self, from: data)
                DispatchQueue.main.async {
                    scheduleAndResults = decodedSchedule
                    
                    // Get the last played game
                    let playedGames = scheduleAndResults?.scheduleAndResults.filter { $0.r != nil }
                    lastGamePlayed = playedGames?.last
                    
                    // Get todays game details
                    getGameOnDate()
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
    TeamScheduleStatsView(teamAbbr: "LAA")
}
