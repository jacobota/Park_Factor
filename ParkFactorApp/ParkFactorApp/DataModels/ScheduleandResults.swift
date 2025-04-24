//
//  ScheduleandResults.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/23/25.
//

import Foundation

struct ScheduleAndResults: Codable {
    let scheduleAndResults: [GameDetails]
    
    enum CodingKeys: String, CodingKey {
        case scheduleAndResults = "schedule_and_results"
    }
}

struct GameDetails: Codable {
    let attendance: Int?
    let dayOrNight: String?
    let date: String?
    let gb: String?
    let homeAway: String?
    let inn: Int?
    let loss: String?
    let opp: String?
    let origScheduled: String?
    let r: Int?
    let ra: Int?
    let rank: Int?
    let save: String?
    let streak: Int?
    let time: String?
    let tm: String?
    let record: String?
    let wl: String?
    let win: String?
    let cli: String?
    
    enum CodingKeys: String, CodingKey {
        case attendance = "Attendance"
        case dayOrNight = "D/N"
        case date = "Date"
        case gb = "GB"
        case homeAway = "Home_Away"
        case inn = "Inn"
        case loss = "Loss"
        case opp = "Opp"
        case origScheduled = "Orig. Scheduled"
        case r = "R"
        case ra = "RA"
        case rank = "Rank"
        case save = "Save"
        case streak = "Streak"
        case time = "Time"
        case tm = "Tm"
        case record = "W-L"
        case wl = "W/L"
        case win = "Win"
        case cli = "cLI"
    }
    
    var oppTeamMascot: String {
        switch opp {
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
            return "Dbacks"
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
            return "Unknown Name"
        }
    }
    
    var teamMascot: String {
        switch tm {
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
            return "Dbacks"
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
            return "Unknown Name"
        }
    }
}
