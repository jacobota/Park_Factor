//
//  TeamHittingLeaderboard.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/6/25.
//

import Foundation

struct TeamHittingLeaderboard: Codable {
    let teamHittingLeaderboard: HittingLeaders?
    
    enum CodingKeys: String, CodingKey {
        case teamHittingLeaderboard = "teamHittingLeaderboard"
    }
}

// Struct to hold the response of the team leaderboards request
struct HittingLeaders: Codable {
    let avg: [BattingAverageTeam]?
    let bbPercent: [WalkPercentageTeam]?
    let barrelPercent: [BarrelPercentageTeam]?
    let bsr: [BsRTeam]?
    let exitVelocity: [ExitVelocityTeam]?
    let hits: [HitsTeam]?
    let homeruns: [HomerunsTeam]?
    let kPercent: [StrikeoutPercentageTeam]?
    let onBasePercent: [OnBasePercentageTeam]?
    let onBasePlusSlugging: [OnBasePlusSluggingTeam]?
    let runs: [RunsTeam]?
    let rbi: [RunsBattedInTeam]?
    let sb: [StolenBaseTeam]?
    let slg: [SluggingTeam]?
    let war: [WARTeam]?
    let wRCPlus: [WRCPlusTeam]?
    
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
struct BattingAverageTeam: Codable, TeamStatDoubleProtocol {
    let team: String
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "AVG"
    }
}

struct WalkPercentageTeam: Codable, TeamStatDoubleProtocol {
    let team: String
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "BB%"
    }
}

struct BarrelPercentageTeam: Codable, TeamStatDoubleProtocol {
    let team: String
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "Barrel%"
    }
}

struct BsRTeam: Codable, TeamStatDoubleProtocol {
    let team: String
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "BsR"
    }
}

struct ExitVelocityTeam: Codable, TeamStatDoubleProtocol {
    let team: String
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "EV"
    }
}

struct HitsTeam: Codable, TeamStatIntProtocol {
    let team: String
    let value: Int
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "H"
    }
}

struct HomerunsTeam: Codable, TeamStatIntProtocol {
    let team: String
    let value: Int
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "HR"
    }
}

struct StrikeoutPercentageTeam: Codable, TeamStatDoubleProtocol {
    let team: String
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "K%"
    }
}

struct OnBasePercentageTeam: Codable, TeamStatDoubleProtocol {
    let team: String
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "OBP"
    }
}

struct OnBasePlusSluggingTeam: Codable, TeamStatDoubleProtocol {
    let team: String
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "OPS"
    }
}

struct RunsTeam: Codable, TeamStatIntProtocol {
    let team: String
    let value: Int
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "R"
    }
}

struct RunsBattedInTeam: Codable, TeamStatIntProtocol {
    let team: String
    let value: Int
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "RBI"
    }
}

struct StolenBaseTeam: Codable, TeamStatIntProtocol {
    let team: String
    let value: Int
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "SB"
    }
}

struct SluggingTeam: Codable, TeamStatDoubleProtocol {
    let team: String
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "SLG"
    }
}

struct WARTeam: Codable, TeamStatDoubleProtocol {
    let team: String
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "WAR"
    }
}

struct WRCPlusTeam: Codable, TeamStatIntProtocol {
    let team: String
    let value: Int
    
    enum CodingKeys: String, CodingKey {
        case team = "Team"
        case value = "wRC+"
    }
}
