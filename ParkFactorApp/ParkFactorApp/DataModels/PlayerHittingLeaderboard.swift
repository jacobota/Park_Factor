//
//  PlayerHittingLeaderboard.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/7/25.
//

import Foundation

struct PlayerHittingLeaderboard: Codable {
    let playerHittingLeaderboard: PlayerHittingLeaders?
    
    enum CodingKeys: String, CodingKey {
        case playerHittingLeaderboard = "playerHittingLeaderboard"
    }
}

// Struct to hold the response of the team leaderboards request
struct PlayerHittingLeaders: Codable {
    let avg: [BattingAveragePlayer]?
    let bbPercent: [WalkPercentagePlayer]?
    let barrelPercent: [BarrelPercentagePlayer]?
    let bsr: [BsRPlayer]?
    let exitVelocity: [ExitVelocityPlayer]?
    let hits: [HitsPlayer]?
    let homeruns: [HomerunsPlayer]?
    let kPercent: [StrikeoutPercentagePlayer]?
    let onBasePercent: [OnBasePercentagePlayer]?
    let onBasePlusSlugging: [OnBasePlusSluggingPlayer]?
    let runs: [RunsPlayer]?
    let rbi: [RunsBattedInPlayer]?
    let sb: [StolenBasePlayer]?
    let slg: [SluggingPlayer]?
    let war: [WARPlayer]?
    let wRCPlus: [WRCPlusPlayer]?
    
    enum CodingKeys: String, CodingKey {
        case avg = "AVG"
        case bbPercent = "BB%"
        case barrelPercent = "Barrel%"
        case bsr = "BsR"
        case exitVelocity = "EV"
        case hits = "H"
        case homeruns = "HR"
        case kPercent = "K%"
        case onBasePercent = "OBP"
        case onBasePlusSlugging = "OPS"
        case runs = "R"
        case rbi = "RBI"
        case sb = "SB"
        case slg = "SLG"
        case war = "WAR"
        case wRCPlus = "wRC+"
    }
}

// Structs to hold the categories retrieved from the leaderboard request
struct BattingAveragePlayer: Codable, PlayerStatDoubleProtocol {
    let team: String
    let value: Double
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "AVG"
        case name = "Name"
    }
}

struct WalkPercentagePlayer: Codable, PlayerStatDoubleProtocol {
    let team: String
    let value: Double
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "BB%"
        case name = "Name"
    }
}

struct BarrelPercentagePlayer: Codable, PlayerStatDoubleProtocol {
    let team: String
    let value: Double
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "Barrel%"
        case name = "Name"
    }
}

struct BsRPlayer: Codable, PlayerStatDoubleProtocol {
    let team: String
    let value: Double
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "BsR"
        case name = "Name"
    }
}

struct ExitVelocityPlayer: Codable, PlayerStatDoubleProtocol {
    let team: String
    let value: Double
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "EV"
        case name = "Name"
    }
}

struct HitsPlayer: Codable, PlayerStatIntProtocol {
    let team: String
    let value: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "H"
        case name = "Name"
    }
}

struct HomerunsPlayer: Codable, PlayerStatIntProtocol {
    let team: String
    let value: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "HR"
        case name = "Name"
    }
}

struct StrikeoutPercentagePlayer: Codable, PlayerStatDoubleProtocol {
    let team: String
    let value: Double
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "K%"
        case name = "Name"
    }
}

struct OnBasePercentagePlayer: Codable, PlayerStatDoubleProtocol {
    let team: String
    let value: Double
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "OBP"
        case name = "Name"
    }
}

struct OnBasePlusSluggingPlayer: Codable, PlayerStatDoubleProtocol {
    let team: String
    let value: Double
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "OPS"
        case name = "Name"
    }
}

struct RunsPlayer: Codable, PlayerStatIntProtocol {
    let team: String
    let value: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "R"
        case name = "Name"
    }
}

struct RunsBattedInPlayer: Codable, PlayerStatIntProtocol {
    let team: String
    let value: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "RBI"
        case name = "Name"
    }
}

struct StolenBasePlayer: Codable, PlayerStatIntProtocol {
    let team: String
    let value: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "SB"
        case name = "Name"
    }
}

struct SluggingPlayer: Codable, PlayerStatDoubleProtocol {
    let team: String
    let value: Double
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "SLG"
        case name = "Name"
    }
}

struct WARPlayer: Codable, PlayerStatDoubleProtocol {
    let team: String
    let value: Double
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "WAR"
        case name = "Name"
    }
}

struct WRCPlusPlayer: Codable, PlayerStatIntProtocol {
    let team: String
    let value: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "wRC+"
        case name = "Name"
    }
}
