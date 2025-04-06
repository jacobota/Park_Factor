//
//  Player.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/4/25.
//

import Foundation

struct Player: Identifiable, Codable {
    let id: UUID = UUID()
    let keyBbref: String?
    let keyFangraphs: Int?
    let keyMlbam: Int?
    let keyRetro: String?
    let mlbPlayedFirst: Int?
    let mlbPlayedLast: Int?
    let nameFirst: String?
    let nameLast: String?
    
    var fullName: String {
        return "\(nameFirst!.capitalized) \(nameLast!.capitalized)"
    }
    
    enum CodingKeys: String, CodingKey {
        case keyBbref = "key_bbref"
        case keyFangraphs = "key_fangraphs"
        case keyMlbam = "key_mlbam"
        case keyRetro = "key_retro"
        case mlbPlayedFirst = "mlb_played_first"
        case mlbPlayedLast = "mlb_played_last"
        case nameFirst = "name_first"
        case nameLast = "name_last"
    }
}
