//
//  PlayerPitchingLeaderboard.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/7/25.
//

import Foundation

struct PlayerPitchingLeaderboard: Codable {
    let playerPitchingLeaderboard: PlayerPitchingLeaders?
    
    enum CodingKeys: String, CodingKey {
        case playerPitchingLeaderboard = "playerPitchingLeaderboard"
    }
}

// Struct to hold the response of the player leaderboards request
struct PlayerPitchingLeaders: Codable {
    let avg: [BattingAveragePlayer]?
    let walks: [WalksPlayer]?
    let bbPercent: [WalkPercentagePlayer]?
    let era: [ERAPlayer]?
    let exitVelocity: [ExitVelocityPlayer]?
    let gbPercent: [GBPercentPlayer]?
    let hits: [HitsPlayer]?
    let homeruns: [HomerunsPlayer]?
    let inningsPitched: [InningsPitchedPlayer]?
    let kPercent: [StrikeoutPercentagePlayer]?
    let loss: [LossPlayer]?
    let runs: [RunsPlayer]?
    let siera: [SIERAPlayer]?
    let strikeouts: [StrikeoutPlayer]?
    let sv: [SavesPlayer]?
    let wins: [WinPlayer]?
    let war: [WARPlayer]?
    let whip: [WHIPPlayer]?
    let fastballVelocity: [FastballVelocityPlayer]?
    
    enum CodingKeys: String, CodingKey {
        case avg = "AVG"
        case walks = "BB"
        case bbPercent = "BB%"
        case era = "ERA"
        case exitVelocity = "EV"
        case gbPercent = "GB%"
        case hits = "H"
        case homeruns = "HR"
        case inningsPitched = "IP"
        case kPercent = "K%"
        case loss = "L"
        case runs = "R"
        case siera = "SIERA"
        case strikeouts = "SO"
        case sv = "SV"
        case wins = "W"
        case war = "WAR"
        case whip = "WHIP"
        case fastballVelocity = "vFA (pi)"
    }
}

struct WalksPlayer: Codable, PlayerStatIntProtocol {
    let team: String
    let value: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "BB"
        case name = "Name"
    }
}

struct ERAPlayer: Codable, PlayerStatDoubleProtocol {
    let team: String
    let value: Double
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "ERA"
        case name = "Name"
    }
}

struct GBPercentPlayer: Codable, PlayerStatDoubleProtocol {
    let team: String
    let value: Double
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "GB%"
        case name = "Name"
    }
}

struct SIERAPlayer: Codable, PlayerStatDoubleProtocol {
    let team: String
    let value: Double
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "SIERA"
        case name = "Name"
    }
}

struct StrikeoutPlayer: Codable, PlayerStatIntProtocol {
    let team: String
    let value: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "SO"
        case name = "Name"
    }
}

struct SavesPlayer: Codable, PlayerStatIntProtocol {
    let team: String
    let value: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "SV"
        case name = "Name"
    }
}

struct WHIPPlayer: Codable, PlayerStatDoubleProtocol {
    let team: String
    let value: Double
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "WHIP"
        case name = "Name"
    }
}

struct FastballVelocityPlayer: Codable, PlayerStatDoubleProtocol {
    let team: String
    let value: Double
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "vFA (pi)"
        case name = "Name"
    }
}

struct InningsPitchedPlayer: Codable, PlayerStatDoubleProtocol {
    let team: String
    let value: Double
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "IP"
        case name = "Name"
    }
}

struct LossPlayer: Codable, PlayerStatIntProtocol {
    let team: String
    let value: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "L"
        case name = "Name"
    }
}

struct WinPlayer: Codable, PlayerStatIntProtocol {
    let team: String
    let value: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "W"
        case name = "Name"
    }
}
