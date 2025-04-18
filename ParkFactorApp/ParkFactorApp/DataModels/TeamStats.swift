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
    let average: Decimal?
    let age: Int?
    let babip: Decimal?
    let walks: Int?
    let bbPercentage: Decimal?
    let bbToK: Decimal?
    let bsr: Decimal?
    let cs: Int?
    let hits: Int?
    let hr: Int?
    let iso: Decimal?
    let kPercentage: Decimal?
    let obp: Decimal?
    let ops: Decimal?
    let runs: Int?
    let sb: Int?
    let slg: Decimal?
    let strikeout: Int?
    let war: Decimal?
    let woba: Decimal?
    let wrcPlus: Int?
    let wsb: Decimal?
    
    enum CodingKeys: String, CodingKey {
        case average = "AVG"
        case age = "Age"
        case babip = "BABIP"
        case walks = "BB"
        case bbPercentage = "BB%"
        case bbToK = "BB/K"
        case bsr = "BsR"
        case cs = "CS"
        case hits = "H"
        case hr = "HR"
        case iso = "ISO"
        case kPercentage = "K%"
        case obp = "OBP"
        case ops = "OPS"
        case runs = "R"
        case sb = "SB"
        case slg = "SLG"
        case strikeout = "SO"
        case war = "WAR"
        case woba = "wOBA"
        case wrcPlus = "wRC+"
        case wsb = "wSB"
    }
}

struct TeamFielding: Codable {
    let drs: Int?
    let errors: Int?
    let fieldingPercentage: Decimal?
    let oaa: Int?
    
    enum CodingKeys: String, CodingKey {
        case drs = "DRS"
        case errors = "E"
        case fieldingPercentage = "FP"
        case oaa = "OAA"
    }
}

struct TeamPitching: Codable {
    let average: Decimal?
    let babip: Decimal?
    let walks: Int?
    let bbPercentage: Decimal?
    let era: Decimal?
    let fip: Decimal?
    let gbPercentage: Decimal?
    let hitsAllowed: Int?
    let hrPerFb: Decimal?
    let kPercentage: Decimal?
    let kMinusBbPercentage: Decimal?
    let losses: Int?
    let lobPercentage: Decimal?
    let locationPlus: Int?
    let pitchingPlus: Int?
    let runs: Int?
    let siera: Decimal?
    let strikeouts: Int?
    let saves: Int?
    let stuffPlus: Int?
    let wins: Int?
    let war: Decimal?
    let whip: Decimal?
    let vfaPi: Decimal?
    let xfip: Decimal?
    
    enum CodingKeys: String, CodingKey {
        case average = "AVG"
        case babip = "BABIP"
        case walks = "BB"
        case bbPercentage = "BB%"
        case era = "ERA"
        case fip = "FIP"
        case gbPercentage = "GB%"
        case hitsAllowed = "H"
        case hrPerFb = "HR/FB"
        case kPercentage = "K%"
        case kMinusBbPercentage = "K-BB%"
        case losses = "L"
        case lobPercentage = "LOB%"
        case locationPlus = "Location+"
        case pitchingPlus = "Pitching+"
        case runs = "R"
        case siera = "SIERA"
        case strikeouts = "SO"
        case saves = "SV"
        case stuffPlus = "Stuff+"
        case wins = "W"
        case war = "WAR"
        case whip = "WHIP"
        case vfaPi = "vFA (pi)"
        case xfip = "xFIP"
    }
}
