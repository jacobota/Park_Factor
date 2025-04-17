//
//  PlayerBio.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/16/25.
//

import Foundation

struct PlayerBioHelper: Codable {
    let playerBio: PlayerBio?

    enum CodingKeys: String, CodingKey {
        case playerBio = "player_bio"
    }
}

struct PlayerBio: Codable {
    let battingSide: String?
    let born: String?
    let height: String?
    let origin: String?
    let position: String?
    let throwingSide: String?
    let weight: String?

    enum CodingKeys: String, CodingKey {
        case battingSide = "Bats"
        case born = "Born"
        case height = "Height"
        case origin = "Origin"
        case position = "Position"
        case throwingSide = "Throws"
        case weight = "Weight"
    }
}
