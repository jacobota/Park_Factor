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


struct PitchingCareerStatsHelper: Codable {
    let pitchingCareerStats: [PitchingCareerStats]?

        enum CodingKeys: String, CodingKey {
            case pitchingCareerStats = "pitching_career_stats"
        }
}

struct PitchingCareerStats: Codable {
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
}
