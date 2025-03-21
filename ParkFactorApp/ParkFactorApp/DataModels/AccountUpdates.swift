//
//  AccountUpdates.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/9/25.
//

import Foundation

// Password Update
struct UpdatePassword: Codable {
    var password: String = ""
}

// Email update
struct UpdateEmail: Codable {
    var email: String = ""
}

// Profile picture update
struct UpdateProfilePicture: Codable {
    var profilePicture: String = ""
}

struct UpdateFavoritePlayer: Codable {
    var favoritePlayer: Player?
}

struct UpdateFavoriteTeam: Codable {
    var favoriteTeam: Team?
}

struct UpdateUserBio: Codable {
    var userBiography: String = ""
}

struct UpdateUserLikedPosts: Codable {
    var likedPosts: [String] = []
}

struct UpdateUserTag: Codable {
    var userTag: String = ""
}
