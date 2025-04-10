//
//  TeamStats.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/10/25.
//

import Foundation

struct TeamStats: Codable {
    let teamBatting: [TeamBatting]?
    let teamFielding: [TeamFielding]?
    let teamPitching: [TeamPitching]?
    
    enum CodingKeys: String, CodingKey {
        case teamBatting = "team_batting"
        case teamFielding = "team_fielding"
        case teamPitching = "team_pitching"
    }
}

struct TeamBatting: Codable {
    let average: Double?
    let age: Int?
    let babip: Double?
    let bbPercentage: Double?
    let bbToK: Double?
    let bsr: Double?
    let cs: Int?
    let hr: Int?
    let iso: Double?
    let kPercentage: Double?
    let ops: Double?
    let runs: Int?
    let sb: Int?
    let slg: Double?
    let war: Double?
    let woba: Double?
    let wrcPlus: Int?
    let wsb: Double?
    
    enum CodingKeys: String, CodingKey {
        case average = "AVG"
        case age = "Age"
        case babip = "BABIP"
        case bbPercentage = "BB%"
        case bbToK = "BB/K"
        case bsr = "BsR"
        case cs = "CS"
        case hr = "HR"
        case iso = "ISO"
        case kPercentage = "K%"
        case ops = "OPS"
        case runs = "R"
        case sb = "SB"
        case slg = "SLG"
        case war = "WAR"
        case woba = "wOBA"
        case wrcPlus = "wRC+"
        case wsb = "wSB"
    }
}

struct TeamFielding: Codable {
    let drs: Int?
    let errors: Int?
    let fieldingPercentage: Double?
    let oaa: Int?
    
    enum CodingKeys: String, CodingKey {
        case drs = "DRS"
        case errors = "E"
        case fieldingPercentage = "FP"
        case oaa = "OAA"
    }
}

struct TeamPitching: Codable {
    let babip: Double?
    let bbPercentage: Double?
    let era: Double?
    let fip: Double?
    let gbPercentage: Double?
    let hrPerFb: Double?
    let kPercentage: Double?
    let kMinusBbPercentage: Double?
    let losses: Int?
    let lobPercentage: Double?
    let locationPlus: Int?
    let pitchingPlus: Int?
    let runs: Int?
    let siera: Double?
    let stuffPlus: Int?
    let wins: Int?
    let war: Double?
    let whip: Double?
    let vfaPi: Double?
    let xfip: Double?
    
    enum CodingKeys: String, CodingKey {
        case babip = "BABIP"
        case bbPercentage = "BB%"
        case era = "ERA"
        case fip = "FIP"
        case gbPercentage = "GB%"
        case hrPerFb = "HR/FB"
        case kPercentage = "K%"
        case kMinusBbPercentage = "K-BB%"
        case losses = "L"
        case lobPercentage = "LOB%"
        case locationPlus = "Location+"
        case pitchingPlus = "Pitching+"
        case runs = "R"
        case siera = "SIERA"
        case stuffPlus = "Stuff+"
        case wins = "W"
        case war = "WAR"
        case whip = "WHIP"
        case vfaPi = "vFA (pi)"
        case xfip = "xFIP"
    }
}
