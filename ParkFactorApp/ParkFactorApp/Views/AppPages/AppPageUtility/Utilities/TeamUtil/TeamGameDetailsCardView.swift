//
//  TeamGameDetailsCardView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/23/25.
//

import SwiftUI

struct TeamGameDetailsCardView: View {
    let gameDetails: GameDetails?
    let previousGame: Bool
    
    var body: some View {
        VStack {
            VStack {
                if gameDetails != nil {
                    HStack {
                        Spacer()
                        if previousGame {
                            Text("Last Game Played")
                                .font(.parkFactorFontSubtitleNorwester)
                                .foregroundStyle(Color.white)
                        }
                        else {
                            Text(gameDetails?.date ?? "N/A")
                                .font(.parkFactorFontSubtitleNorwester)
                                .foregroundStyle(Color.white)
                        }
                        Spacer()
                    }
                    .padding(.top, 25)
                    .padding(.horizontal, 20)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 5) {
                        // First Row with stat category
                        if gameDetails?.homeAway == "Home" {
                            Text(gameDetails?.oppTeamMascot ?? "N/A")
                                .font(.parkFactorFontBigTextNorwester)
                            Text("")
                            Text(gameDetails?.teamMascot ?? "N/A")
                                .font(.parkFactorFontBigTextNorwester)
                            
                            Text("")
                            Text("")
                            Text("")
                            
                            AsyncImage(url: URL(string: "https://cdn.ssref.net/req/202502211/tlogo/br/\(getTeamPicId(gameDetails?.opp ?? "")).png"), scale: 3) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                            Text("vs")
                            AsyncImage(url: URL(string: "https://cdn.ssref.net/req/202502211/tlogo/br/\(getTeamPicId(gameDetails?.tm ?? "")).png"), scale: 3) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                        } else {
                            Text(gameDetails?.teamMascot ?? "N/A")
                                .font(.parkFactorFontBigTextNorwester)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            Text("")
                            Text(gameDetails?.oppTeamMascot ?? "N/A")
                                .font(.parkFactorFontBigTextNorwester)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            
                            Text("")
                            Text("")
                            Text("")
                            
                            AsyncImage(url: URL(string: "https://cdn.ssref.net/req/202502211/tlogo/br/\(getTeamPicId(gameDetails?.tm ?? "")).png"), scale: 3) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                            Text("vs")
                            AsyncImage(url: URL(string: "https://cdn.ssref.net/req/202502211/tlogo/br/\(getTeamPicId(gameDetails?.opp ?? "")).png"), scale: 3) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        
                        // If Runs exist then this game was played so show details
                        if gameDetails?.r != nil {
                            Text("")
                            Text("")
                            Text("")
                            // Display Score
                            if gameDetails?.homeAway == "Home" {
                                Text("\(gameDetails?.ra ?? -1)")
                                Text("")
                                Text("\(gameDetails?.r ?? -1)")
                            } else {
                                Text("\(gameDetails?.r ?? -1)")
                                Text("")
                                Text("\(gameDetails?.ra ?? -1)")
                            }
                            
                            Text("")
                            Text("")
                            Text("")
                            
                            Text("W: \(gameDetails?.win ?? "N/A")")
                                .font(.parkFactorFontText)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            Text("L: \(gameDetails?.loss ?? "N/A")")
                                .font(.parkFactorFontText)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            Text("")
                            
                            Text("SV: \(gameDetails?.save ?? "N/A")")
                                .font(.parkFactorFontText)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            Text("")
                            Text("")
                        }
                    }
                    .font(.parkFactorFontSubtitleNorwester)
                    .foregroundColor(.white)
                    .padding(30)
                } else {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 5) {
                        Text("No Game Scheduled")
                    }
                    .font(.parkFactorFontSubtitleNorwester)
                    .foregroundColor(.white)
                    .padding(30)
                }
            }
            .background(Color.black)
            .cornerRadius(10)
            .padding(.bottom, 10)
        }
    }
    
    private func getTeamPicId(_ id: String) -> String {
        switch id {
        case "ATH":
            return "OAK"
        case "LAA":
            return "ANA"
        case "TBR":
            return "TBD"
        case "MIA":
            return "FLA"
        default:
            return id
        }
    }
}

#Preview {
    TeamGameDetailsCardView(gameDetails: GameDetails(attendance: 39393, dayOrNight: "D", date: "Mar 27", gb: "1.0", homeAway: "Home", inn: 10, loss: "Long", opp: "TBR", origScheduled: nil, r: 4, ra: 7, rank: 3, save: "Sewald", streak: -1, time: "2:41", tm: "KCR", record: "0-1", wl: "L", win: "Clase", cli: "1.02"), previousGame: false)
}

//#Preview {
//    TeamGameDetailsCardView(gameDetails: nil, previousGame: true)
//}
