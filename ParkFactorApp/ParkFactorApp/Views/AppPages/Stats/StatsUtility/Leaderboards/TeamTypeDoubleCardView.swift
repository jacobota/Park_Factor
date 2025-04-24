//
//  TeamTypeDoubleCardView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/7/25.
//

import SwiftUI

struct TeamTypeDoubleCardView<T: TeamStatDoubleProtocol>: View {
    var decimalCount: Int
    var title: String
    var leaderboardStats: [T]
    var savedUser: SavedUser
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(title)
                        .font(.parkFactorFontSubtitleNorwester)
                        .foregroundStyle(Color.parkFactorPrimary)
                    Spacer()
                }
                ForEach(Array(leaderboardStats.enumerated()), id: \.offset) { index, record in
                    HStack {
                        Text("\(index + 1)")
                            .font(.parkFactorFontTextNorwester)
                            .foregroundStyle(Color.white)
                        NavigationLink(destination: TeamPageView(teamAbbr: getTeamAbbrForNavLinks(record.team), savedUser: savedUser)) {
                            AsyncImage(url: URL(string: "https://cdn.ssref.net/req/202502211/tlogo/br/\(correctIncorrectTeamLogo(record.team)).png"), scale: 3) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 35, height: 35)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(lineWidth: 0)
                                    )
                            } placeholder: {
                                ProgressView()
                            }
                            .padding(10)
                            
                            Text(getTeamName(record.team))
                                .font(.parkFactorFontTextNorwester)
                                .foregroundStyle(Color.white)
                                .frame(width: 150, alignment: .leading)
                        }
        
                        Spacer()
                        Text("\(record.value, specifier: "%.\(decimalCount)f")")
                            .font(.parkFactorFontTextNorwester)
                            .foregroundStyle(Color.parkFactorPrimary)
                        Spacer()
                    }
                }
            }
            .padding(20)
            .background(Color.parkFactorSecondary)
            .cornerRadius(20)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private func getTeamName(_ abbr: String) -> String {
        switch abbr {
        case "LAA":
            return "Angels"
        case "SEA":
            return "Mariners"
        case "TEX":
            return "Rangers"
        case "HOU":
            return "Astros"
        case "ATH":
            return "Athletics"
        case "CHW":
            return "White Sox"
        case "MIN":
            return "Twins"
        case "KCR":
            return "Royals"
        case "DET":
            return "Tigers"
        case "CLE":
            return "Guardians"
        case "NYY":
            return "Yankees"
        case "BOS":
            return "Red Sox"
        case "TBR":
            return "Rays"
        case "TOR":
            return "Blue Jays"
        case "BAL":
            return "Orioles"
        case "SFG":
            return "Giants"
        case "LAD":
            return "Dodgers"
        case "SDP":
            return "Padres"
        case "ARI":
            return "Diamondbacks"
        case "COL":
            return "Rockies"
        case "CHC":
            return "Cubs"
        case "CIN":
            return "Reds"
        case "PIT":
            return "Pirates"
        case "MIL":
            return "Brewers"
        case "STL":
            return "Cardinals"
        case "NYM":
            return "Mets"
        case "WSN":
            return "Nationals"
        case "MIA":
            return "Marlins"
        case "ATL":
            return "Braves"
        case "PHI":
            return "Phillies"
        default:
            return "Unknown Team"
        }
    }
    
    private func correctIncorrectTeamLogo(_ abbr: String) -> String {
        switch abbr {
        case "LAA":
            return "ANA"
        case "TBR":
            return "TBD"
        case "ATH":
            return "OAK"
        case "MIA":
            return "FLA"
        default:
            return abbr
        }
    }
    
    private func getTeamAbbrForNavLinks(_ abbr: String) -> String {
        switch abbr {
        case "ATH":
            return "OAK"
        default:
            return abbr
        }
    }
}

#Preview {
    TeamTypeDoubleCardView(decimalCount: 3, title: "Batting Average", leaderboardStats: [BattingAverageTeam(team: "STL", value: 0.302), BattingAverageTeam(team: "ARI", value: 0.299), BattingAverageTeam(team: "SDP", value: 0.279), BattingAverageTeam(team: "DET", value: 0.274), BattingAverageTeam(team: "PHI", value: 0.274)], savedUser: SavedUser())
}
