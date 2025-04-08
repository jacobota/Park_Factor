//
//  TeamPitchingLeaderboard.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/7/25.
//

import Foundation

struct TeamPitchingLeaderboard: Codable {
    let teamPitchingLeaderboard: PitchingLeaders?
    
    enum CodingKeys: String, CodingKey {
        case teamPitchingLeaderboard = "teamPitchingLeaderboard"
    }
}

// Struct to hold the response of the team leaderboards request
struct PitchingLeaders: Codable {
    let avg: [BattingAverageTeam]?
    let walks: [WalksTeam]?
    let bbPercent: [WalkPercentageTeam]?
    let era: [ERATeam]?
    let exitVelocity: [ExitVelocityTeam]?
    let gbPercent: [GBPercentTeam]?
    let hits: [HitsTeam]?
    let homeruns: [HomerunsTeam]?
    let kPercent: [StrikeoutPercentageTeam]?
    let runs: [RunsTeam]?
    let siera: [SIERATeam]?
    let strikeouts: [StrikeoutTeam]?
    let sv: [SavesTeam]?
    let war: [WARTeam]?
    let whip: [WHIPTeam]?
    let fastballVelocity: [FastballVelocityTeam]?
    
    enum CodingKeys: String, CodingKey {
        case avg = "AVG"
        case walks = "BB"
        case bbPercent = "BB%"
        case era = "ERA"
        case exitVelocity = "EV"
        case gbPercent = "GB%"
        case hits = "H"
        case homeruns = "HR"
        case kPercent = "K%"
        case runs = "R"
        case siera = "SIERA"
        case strikeouts = "SO"
        case sv = "SV"
        case war = "WAR"
        case whip = "WHIP"
        case fastballVelocity = "vFA (pi)"
    }
}

struct WalksTeam: Codable, TeamStatIntProtocol {
    let team: String
    let value: Int
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "BB"
    }
}

struct ERATeam: Codable, TeamStatDoubleProtocol {
    let team: String
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "ERA"
    }
}

struct GBPercentTeam: Codable, TeamStatDoubleProtocol {
    let team: String
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "GB%"
    }
}

struct SIERATeam: Codable, TeamStatDoubleProtocol {
    let team: String
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "SIERA"
    }
}

struct StrikeoutTeam: Codable, TeamStatIntProtocol {
    let team: String
    let value: Int
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "SO"
    }
}

struct SavesTeam: Codable, TeamStatIntProtocol {
    let team: String
    let value: Int
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "SV"
    }
}

struct WHIPTeam: Codable, TeamStatDoubleProtocol {
    let team: String
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "WHIP"
    }
}

struct FastballVelocityTeam: Codable, TeamStatDoubleProtocol {
    let team: String
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "vFA (pi)"
    }
}
