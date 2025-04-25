//
//  PitcherArsenal.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/19/25.
//

import Foundation
import SwiftUICore

struct PitcherAresenal: Codable {
    let pitcher_arsenal: [PitchType]?
    
    enum CodingKeys: String, CodingKey {
        case pitcher_arsenal = "pitcher_arsenal"
    }
}

struct PitchType: Codable, Identifiable {
    var id = UUID()
    let avg_speed: Decimal?
    let diff_x: Decimal?
    let league_break_x: Decimal?
    let pitch_hand: String?
    let pitch_per: Decimal?
    let pitch_type: String?
    let pitch_type_name: String?
    let pitcher_break_z_induced: Decimal?
    let pitches_thrown: Int?
    
    enum CodingKeys: String, CodingKey {
        case avg_speed = "avg_speed"
        case diff_x = "diff_x"
        case league_break_x = "league_break_x"
        case pitch_hand = "pitch_hand"
        case pitch_per = "pitch_per"
        case pitch_type = "pitch_type"
        case pitch_type_name = "pitch_type_name"
        case pitcher_break_z_induced = "pitcher_break_z_induced"
        case pitches_thrown = "pitches_thrown"
    }
    
    // Calculate pitch percentage
    var pitch_percentage_computed: Decimal? {
        return (pitch_per ?? 0) * 100
    }
    
    // Computed property for pitcher_break_x
    var pitcher_break_x: Decimal? {
        guard let leagueX = league_break_x, let diffX = diff_x else {
            return nil
        }
        
        let result: Decimal
        // Add the values if both are positive or both are negative, but normal math if they are any other condition
        if leagueX > 0 && diffX > 0 || leagueX < 0 && diffX < 0{
            result = leagueX + diffX
        } else {
            result = leagueX - diffX
        }
        
        
        // For the pitcher arsenal graph, need to flip the sign if the pitcher is Righty, for correctly orienting the points
        return pitch_hand == "R" ? -result : result
    }
    
    // Give a shortened pitch name for longer named pitches
    var shortenedPitchName: String? {
        guard let pitchName = pitch_type_name else {
            return nil
        }
        
        switch pitchName {
        case "4-Seam Fastball":
            return "4-Seam"
        case "Changeup":
            return "Change"
        case "Curveball":
            return "Curve"
        case "Split-Finger":
            return "Split"
        case "Sweeper":
            return "Sweep"
        default:
            return pitchName
        }
    }
    
    // Give pitches their colors
    var pitchColor: Color? {
        guard let pitchName = pitch_type_name else {
            return nil
        }
        
        switch pitchName {
        case "4-Seam Fastball":
            return Color.red
        case "Changeup":
            return Color.green
        case "Curveball":
            return Color.blue
        case "Sinker":
            return Color.orange
        case "Slider":
            return Color.purple
        case "Sweeper":
            return Color.yellow
        default:
            return Color.white
        }
    }
    
    // Make a PitchPoint for each pitch
    var pitchPoint: PitchPoint? {
        guard let x = pitcher_break_x, let y = pitcher_break_z_induced, let pitchName = shortenedPitchName, let color = pitchColor else {
            return nil
        }
        
        return PitchPoint(x: x, y: y, color: color, pitchName: pitchName)
    }
}
