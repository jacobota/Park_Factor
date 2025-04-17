//
//  HitterPercentiles.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/16/25.
//

import Foundation

struct HitterPercentileHelper: Codable {
    let hitter_percentile: [HitterPercentile]?
    
    enum CodingKeys: String, CodingKey {
        case hitter_percentile = "hitter_percentile"
    }
}

struct HitterPercentile: Codable {
    let armStrength: Int?
    let batSpeed: Int?
    let bbPercent: Int?
    let barrel: Int?
    let barrelPercent: Int?
    let chasePercent: Int?
    let exitVelocity: Int?
    let hardHitPercent: Int?
    let kPercent: Int?
    let maxEv: Int?
    let oaa: Int?
    let playerID: Int?
    let playerName: String?
    let sprintSpeed: Int?
    let squaredUpRate: Int?
    let swingLength: Int?
    let whiffPercent: Int?
    let xba: Int?
    let xiso: Int?
    let xobp: Int?
    let xslg: Int?
    let xwoba: Int?
    let year: Int?

    enum CodingKeys: String, CodingKey {
        case armStrength = "arm_strength"
        case batSpeed = "bat_speed"
        case bbPercent = "bb_percent"
        case barrel = "brl"
        case barrelPercent = "brl_percent"
        case chasePercent = "chase_percent"
        case exitVelocity = "exit_velocity"
        case hardHitPercent = "hard_hit_percent"
        case kPercent = "k_percent"
        case maxEv = "max_ev"
        case oaa = "oaa"
        case playerID = "player_id"
        case playerName = "player_name"
        case sprintSpeed = "sprint_speed"
        case squaredUpRate = "squared_up_rate"
        case swingLength = "swing_length"
        case whiffPercent = "whiff_percent"
        case xba = "xba"
        case xiso = "xiso"
        case xobp = "xbp"
        case xslg = "xslg"
        case xwoba = "xwoba"
        case year = "year"
    }
}
