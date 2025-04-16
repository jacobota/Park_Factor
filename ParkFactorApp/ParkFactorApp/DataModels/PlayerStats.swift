//
//  PlayerStats.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/14/25.
//

import Foundation

struct HitterStatsHelper: Codable {
    var hitterStats: HitterStats?
    
    enum CodingKeys: String, CodingKey {
        case hitterStats = "hitter_stats"
    }
}

struct PitchingStatsHelper: Codable {
    var pitchingStats: [PitchingStats]?
    
    enum CodingKeys: String, CodingKey {
        case pitchingStats = "pitcher_stats"
    }
}

struct HitterPreviewStatsHelper: Codable {
    var hitterPreviewStats: [HitterPreviewStats]?
    
    enum CodingKeys: String, CodingKey {
        case hitterPreviewStats = "hitter_preview_stats"
    }
}

struct PitchingPreviewStatsHelper: Codable {
    var pitchingPreviewStats: [PitchingPreviewStats]?
    
    enum CodingKeys: String, CodingKey {
        case pitchingPreviewStats = "pitcher_preview_stats"
    }
}

struct HitterStats: Codable {
    let average: Decimal?
    let babip: Decimal?
    let walkPercentage: Decimal?
    let walkToStrikeoutRatio: Decimal?
    let barrelPercentage: Decimal?
    let bsr: Decimal?
    let caughtStealing: Int?
    let contactPercentage: Decimal?
    let defensiveRunsSaved: Int?
    let errors: Int?
    let exitVelocity: Decimal?
    let fieldingPercentage: Decimal?
    let games: Int?
    let hits: Int?
    let homeRuns: Int?
    let hardHitPercentage: Decimal?
    let iso: Decimal?
    let strikeoutPercentage: Decimal?
    let outsAboveAverage: Int?
    let onBasePercentage: Decimal?
    let onBasePlusSlugging: Decimal?
    let runs: Int?
    let rbi: Int?
    let sb: Int?
    let sluggingPercentage: Decimal?
    let swingPercentage: Decimal?
    let team: String?
    let uzr: Decimal?
    let war: Decimal?
    let winProbabilityAdded: Decimal?
    let zSwingPercentage: Decimal?
    let maxExitVelocity: Decimal?
    let sprintSpeed: Decimal?
    let wOBA: Decimal?
    let wRCPlus: Int?
    let wSB: Decimal?
    let xBA: Decimal?
    let xSlg: Decimal?
    let xWOBA: Decimal?
    
    enum CodingKeys: String, CodingKey {
        case average = "AVG"
        case babip = "BABIP"
        case walkPercentage = "BB%"
        case walkToStrikeoutRatio = "BB/K"
        case barrelPercentage = "Barrel%"
        case bsr = "BsR"
        case caughtStealing = "CS"
        case contactPercentage = "Contact%"
        case defensiveRunsSaved = "DRS"
        case errors = "E"
        case exitVelocity = "EV"
        case fieldingPercentage = "FP"
        case games = "G"
        case hits = "H"
        case homeRuns = "HR"
        case hardHitPercentage = "HardHit%"
        case iso = "ISO"
        case strikeoutPercentage = "K%"
        case outsAboveAverage = "OAA"
        case onBasePercentage = "OBP"
        case onBasePlusSlugging = "OPS"
        case runs = "R"
        case rbi = "RBI"
        case sb = "SB"
        case sluggingPercentage = "SLG"
        case swingPercentage = "Swing%"
        case team = "Team"
        case uzr = "UZR"
        case war = "WAR"
        case winProbabilityAdded = "WPA"
        case zSwingPercentage = "Z-Swing%"
        case maxExitVelocity = "maxEV"
        case sprintSpeed = "sprint_speed"
        case wOBA = "wOBA"
        case wRCPlus = "wRC+"
        case wSB = "wSB"
        case xBA = "xBA"
        case xSlg = "xSLG"
        case xWOBA = "xwOBA"
    }
    
    var teamName: String? {
        switch team {
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
            return "Diamondbacks"
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
            return "Free Agent"
        }
    }
}

struct PitchingStats: Codable {
    let babip: Decimal?
    let walks: Int?
    let walkPercentage: Decimal?
    let barrelPercentage: Decimal?
    let completeGames: Int?
    let changeupPercentage: Decimal?
    let curveballPercentage: Decimal?
    let era: Decimal?
    let exitVelocity: Decimal?
    let fastballPercentage: Decimal?
    let cutterPercentage: Decimal?
    let fip: Decimal?
    let splitterPercentage: Decimal?
    let games: Int?
    let groundBallPercentage: Decimal?
    let gamesStarted: Int?
    let hardHitPercentage: Decimal?
    let inningsPitched: Decimal?
    let strikeoutPercentage: Decimal?
    let strikeoutMinusWalkPercentage: Decimal?
    let losses: Int?
    let locationPlusChangeup: Int?
    let locationPlusCurveball: Int?
    let locationPlusFastball: Int?
    let locationPlusCutter: Int?
    let locationPlusOther: Int?
    let locationPlusSplitter: Int?
    let locationPlusKnuckleCurve: Int?
    let locationPlusSinker: Int?
    let locationPlusSlider: Int?
    let locationPlus: Int?
    let oSwingPercentage: Decimal?
    let pitchPlusChangeup: Int?
    let pitchPlusCurveball: Int?
    let pitchPlusFastball: Int?
    let pitchPlusCutter: Int?
    let pitchPlusOther: Int?
    let pitchPlusSplitter: Int?
    let pitchPlusKnuckleCurve: Int?
    let pitchPlusSinker: Int?
    let pitchPlusSlider: Int?
    let pitchingPlus: Int?
    let sinkerPercentage: Decimal?
    let siera: Decimal?
    let sliderPercentage: Decimal?
    let strikeouts: Int?
    let saves: Int?
    let stuffPlusChangeup: Int?
    let stuffPlusCurveball: Int?
    let stuffPlusFastball: Int?
    let stuffPlusCutter: Int?
    let stuffPlusOther: Int?
    let stuffPlusSplitter: Int?
    let stuffPlusKnuckleCurve: Int?
    let stuffPlusSinker: Int?
    let stuffPlusSlider: Int?
    let stuffPlus: Int?
    let team: String?
    let wins: Int?
    let war: Decimal?
    let whip: Decimal?
    let velocityChangeup: Decimal?
    let velocityCurveball: Decimal?
    let velocityFastball: Decimal?
    let velocityCutter: Decimal?
    let velocitySplitter: Decimal?
    let velocitySinker: Decimal?
    let velocitySlider: Decimal?
    let expectedEra: Decimal?
    let expectedFip: Decimal?
    
    enum CodingKeys: String, CodingKey {
        case babip = "BABIP"
        case walks = "BB"
        case walkPercentage = "BB%"
        case barrelPercentage = "Barrel%"
        case completeGames = "CG"
        case changeupPercentage = "CH% (pi)"
        case curveballPercentage = "CU% (pi)"
        case era = "ERA"
        case exitVelocity = "EV"
        case fastballPercentage = "FA% (pi)"
        case cutterPercentage = "FC% (pi)"
        case fip = "FIP"
        case splitterPercentage = "FS% (pi)"
        case games = "G"
        case groundBallPercentage = "GB%"
        case gamesStarted = "GS"
        case hardHitPercentage = "HardHit%"
        case inningsPitched = "IP"
        case strikeoutPercentage = "K%"
        case strikeoutMinusWalkPercentage = "K-BB%"
        case losses = "L"
        case locationPlusChangeup = "Loc+ CH"
        case locationPlusCurveball = "Loc+ CU"
        case locationPlusFastball = "Loc+ FA"
        case locationPlusCutter = "Loc+ FC"
        case locationPlusOther = "Loc+ FO"
        case locationPlusSplitter = "Loc+ FS"
        case locationPlusKnuckleCurve = "Loc+ KC"
        case locationPlusSinker = "Loc+ SI"
        case locationPlusSlider = "Loc+ SL"
        case locationPlus = "Location+"
        case oSwingPercentage = "O-Swing% (pi)"
        case pitchPlusChangeup = "Pit+ CH"
        case pitchPlusCurveball = "Pit+ CU"
        case pitchPlusFastball = "Pit+ FA"
        case pitchPlusCutter = "Pit+ FC"
        case pitchPlusOther = "Pit+ FO"
        case pitchPlusSplitter = "Pit+ FS"
        case pitchPlusKnuckleCurve = "Pit+ KC"
        case pitchPlusSinker = "Pit+ SI"
        case pitchPlusSlider = "Pit+ SL"
        case pitchingPlus = "Pitching+"
        case sinkerPercentage = "SI% (pi)"
        case siera = "SIERA"
        case sliderPercentage = "SL% (pi)"
        case strikeouts = "SO"
        case saves = "SV"
        case stuffPlusChangeup = "Stf+ CH"
        case stuffPlusCurveball = "Stf+ CU"
        case stuffPlusFastball = "Stf+ FA"
        case stuffPlusCutter = "Stf+ FC"
        case stuffPlusOther = "Stf+ FO"
        case stuffPlusSplitter = "Stf+ FS"
        case stuffPlusKnuckleCurve = "Stf+ KC"
        case stuffPlusSinker = "Stf+ SI"
        case stuffPlusSlider = "Stf+ SL"
        case stuffPlus = "Stuff+"
        case team = "Team"
        case wins = "W"
        case war = "WAR"
        case whip = "WHIP"
        case velocityChangeup = "vCH (pi)"
        case velocityCurveball = "vCU (pi)"
        case velocityFastball = "vFA (pi)"
        case velocityCutter = "vFC (pi)"
        case velocitySplitter = "vFS (pi)"
        case velocitySinker = "vSI (pi)"
        case velocitySlider = "vSL (pi)"
        case expectedEra = "xERA"
        case expectedFip = "xFIP"
    }
    
    var teamName: String? {
        switch team {
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
            return "Diamondbacks"
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
            return "Free Agent"
        }
    }
}

struct HitterPreviewStats: Codable {
    let days: Int?
    let doubles: Int?
    let triples: Int?
    let atBats: Int?
    let age: Int?
    let battingAverage: Decimal?
    let walks: Int?
    let caughtStealing: Int?
    let games: Int?
    let gdp: Int?
    let hits: Int?
    let hitByPitch: Int?
    let homeRuns: Int?
    let intentionalWalks: Int?
    let level: String?
    let name: String?
    let onBasePercentage: Decimal?
    let onBasePlusSlugging: Decimal?
    let pa: Int?
    let runs: Int?
    let rbi: Int?
    let sb: Int?
    let sacrificeFlies: Int?
    let sacrificeHits: Int?
    let sluggingPercentage: Decimal?
    let strikeouts: Int?
    let team: String?
    let mlbID: Int?
    
    enum CodingKeys: String, CodingKey {
        case days = "#days"
        case doubles = "2B"
        case triples = "3B"
        case atBats = "AB"
        case age = "Age"
        case battingAverage = "BA"
        case walks = "BB"
        case caughtStealing = "CS"
        case games = "G"
        case gdp = "GDP"
        case hits = "H"
        case hitByPitch = "HBP"
        case homeRuns = "HR"
        case intentionalWalks = "IBB"
        case level = "Lev"
        case name = "Name"
        case onBasePercentage = "OBP"
        case onBasePlusSlugging = "OPS"
        case pa = "PA"
        case runs = "R"
        case rbi = "RBI"
        case sb = "SB"
        case sacrificeFlies = "SF"
        case sacrificeHits = "SH"
        case sluggingPercentage = "SLG"
        case strikeouts = "SO"
        case team = "Tm"
        case mlbID = "mlbID"
    }
}

struct PitchingPreviewStats: Codable {
    let days: Int?
    let doubles: Int?
    let triples: Int?
    let atBats: Int?
    let age: Int?
    let babip: Decimal?
    let walks: Int?
    let battersFaced: Int?
    let caughtStealing: Int?
    let earnedRuns: Int?
    let era: Decimal?
    let games: Int?
    let groundBallToFlyBallRatio: Decimal?
    let gdp: Int?
    let gamesStarted: Int?
    let hits: Int?
    let hitByPitch: Int?
    let homeRuns: Int?
    let intentionalWalks: Int?
    let inningsPitched: Decimal?
    let losses: Int?
    let lineDrivePercentage: Decimal?
    let level: String?
    let name: String?
    let putouts: Int?
    let popupPercentage: Decimal?
    let pitches: Int?
    let runs: Int?
    let stolenBases: Int?
    let sacrificeFlies: Int?
    let strikeouts: Int?
    let strikeoutsToWalksRatio: Decimal?
    let strikeoutsPerNine: Decimal?
    let saves: Int?
    let strikeLookingPercentage: Decimal?
    let strikeSwingingPercentage: Decimal?
    let strikePercentage: Decimal?
    let team: String?
    let wins: Int?
    let whip: Decimal?
    let mlbID: String?
    
    enum CodingKeys: String, CodingKey {
        case days = "#days"
        case doubles = "2B"
        case triples = "3B"
        case atBats = "AB"
        case age = "Age"
        case babip = "BAbip"
        case walks = "BB"
        case battersFaced = "BF"
        case caughtStealing = "CS"
        case earnedRuns = "ER"
        case era = "ERA"
        case games = "G"
        case groundBallToFlyBallRatio = "GB/FB"
        case gdp = "GDP"
        case gamesStarted = "GS"
        case hits = "H"
        case hitByPitch = "HBP"
        case homeRuns = "HR"
        case intentionalWalks = "IBB"
        case inningsPitched = "IP"
        case losses = "L"
        case lineDrivePercentage = "LD"
        case level = "Lev"
        case name = "Name"
        case putouts = "PO"
        case popupPercentage = "PU"
        case pitches = "Pit"
        case runs = "R"
        case stolenBases = "SB"
        case sacrificeFlies = "SF"
        case strikeouts = "SO"
        case strikeoutsToWalksRatio = "SO/W"
        case strikeoutsPerNine = "SO9"
        case saves = "SV"
        case strikeLookingPercentage = "StL"
        case strikeSwingingPercentage = "StS"
        case strikePercentage = "Str"
        case team = "Tm"
        case wins = "W"
        case whip = "WHIP"
        case mlbID = "mlbID"
    }
}
