//
//  PitcherPercentiles.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/18/25.
//

import Foundation

struct PitcherPercentileHelper: Codable {
    let pitcher_percentile: [PitcherPercentile]?

    enum CodingKeys: String, CodingKey {
        case pitcher_percentile = "pitcher_percentile"
    }
}

struct PitcherPercentile: Codable {
    let armStrength: Int?
    let bbPercent: Int?
    let barrel: Int?
    let barrelPercent: Int?
    let chasePercent: Int?
    let curveSpin: Int?
    let exitVelocity: Int?
    let fbSpin: Int?
    let fbVelocity: Int?
    let hardHitPercent: Int?
    let kPercent: Int?
    let maxEv: Int?
    let playerId: Int?
    let playerName: String?
    let whiffPercent: Int?
    let xba: Int?
    let xera: Int?
    let xiso: Int?
    let xobp: Int?
    let xslg: Int?
    let xwoba: Int?
    let year: Int?

    enum CodingKeys: String, CodingKey {
        case armStrength = "arm_strength"
        case bbPercent = "bb_percent"
        case barrel = "brl"
        case barrelPercent = "brl_percent"
        case chasePercent = "chase_percent"
        case curveSpin = "curve_spin"
        case exitVelocity = "exit_velocity"
        case fbSpin = "fb_spin"
        case fbVelocity = "fb_velocity"
        case hardHitPercent = "hard_hit_percent"
        case kPercent = "k_percent"
        case maxEv = "max_ev"
        case playerId = "player_id"
        case playerName = "player_name"
        case whiffPercent = "whiff_percent"
        case xba = "xba"
        case xera = "xera"
        case xiso = "xiso"
        case xobp = "xobp"
        case xslg = "xslg"
        case xwoba = "xwoba"
        case year = "year"
    }
}
