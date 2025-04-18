//
//  PlayerCareerStats.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/17/25.
//

import Foundation

struct HittingCareerStatsHelper: Codable {
    let hittingCareerStats: [HittingCareerStats]?

        enum CodingKeys: String, CodingKey {
            case hittingCareerStats = "hitting_career_stats"
        }
}

struct HittingCareerStats: Codable {
    let avg: Decimal?
    let babip: Decimal?
    let bbPercent: Decimal?
    let bbK: Decimal?
    let barrelPercent: Decimal?
    let bsr: Decimal?
    let cs: Int?
    let contactPercent: Decimal?
    let ev: Decimal?
    let g: Int?
    let h: Int?
    let hr: Int?
    let hardHitPercent: Decimal?
    let iso: Decimal?
    let kPercent: Decimal?
    let obp: Decimal?
    let ops: Decimal?
    let r: Int?
    let rbi: Int?
    let sb: Int?
    let slg: Decimal?
    let swingPercent: Decimal?
    let war: Decimal?
    let wpa: Decimal?
    let zSwingPercent: Decimal?
    let maxEv: Decimal?
    let woba: Decimal?
    let wrcPlus: Int?
    let wsb: Decimal?

    enum CodingKeys: String, CodingKey {
        case avg = "AVG"
        case babip = "BABIP"
        case bbPercent = "BB%"
        case bbK = "BB/K"
        case barrelPercent = "Barrel%"
        case bsr = "BsR"
        case cs = "CS"
        case contactPercent = "Contact%"
        case ev = "EV"
        case g = "G"
        case h = "H"
        case hr = "HR"
        case hardHitPercent = "HardHit%"
        case iso = "ISO"
        case kPercent = "K%"
        case obp = "OBP"
        case ops = "OPS"
        case r = "R"
        case rbi = "RBI"
        case sb = "SB"
        case slg = "SLG"
        case swingPercent = "Swing%"
        case war = "WAR"
        case wpa = "WPA"
        case zSwingPercent = "Z-Swing%"
        case maxEv = "maxEV"
        case woba = "wOBA"
        case wrcPlus = "wRC+"
        case wsb = "wSB"
    }
}
