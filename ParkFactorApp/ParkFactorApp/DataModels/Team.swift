//
//  Team.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/17/25.
//

import Foundation

struct Team: Identifiable, Codable {
    let id: UUID = UUID()
    let franchID: String
    let lgID: String
    let teamID: String
    let teamIDBR: String
    let teamIDfg: Int
    let teamIDretro: String
    let yearID: Int
    
    var teamName: String {
        switch teamIDBR {
        case "LAA":
            return "Los Angeles Angels"
        case "SEA":
            return "Seattle Mariners"
        case "TEX":
            return "Texas Rangers"
        case "HOU":
            return "Houston Astros"
        case "OAK":
            return "Oakland Athletics"
        case "CHW":
            return "Chicago White Sox"
        case "MIN":
            return "Minnesota Twins"
        case "KCR":
            return "Kansas City Royals"
        case "DET":
            return "Detroit Tigers"
        case "CLE":
            return "Cleveland Guardians"
        case "NYY":
            return "New York Yankees"
        case "BOS":
            return "Boston Red Sox"
        case "TBR":
            return "Tampa Bay Rays"
        case "TOR":
            return "Toronto Blue Jays"
        case "BAL":
            return "Baltimore Orioles"
        case "SFG":
            return "San Francisco Giants"
        case "LAD":
            return "Los Angeles Dodgers"
        case "SDP":
            return "San Diego Padres"
        case "ARI":
            return "Arizona Diamondbacks"
        case "COL":
            return "Colorado Rockies"
        case "CHC":
            return "Chicago Cubs"
        case "CIN":
            return "Cincinatti Reds"
        case "PIT":
            return "Pittsburgh Pirates"
        case "MIL":
            return "Milwaukee Brewers"
        case "STL":
            return "St. Louis Cardinals"
        case "NYM":
            return "New York Mets"
        case "WSN":
            return "Washington Nationals"
        case "MIA":
            return "Miami Marlins"
        case "ATL":
            return "Atlanta Braves"
        case "PHI":
            return "Philadelphia Phillies"
        default:
            return "Unknown Team"
        }
    }
    
    var teamMascot: String {
        switch teamIDBR {
        case "LAA":
            return "Angels"
        case "SEA":
            return "Mariners"
        case "TEX":
            return "Rangers"
        case "HOU":
            return "Astros"
        case "OAK":
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
}
