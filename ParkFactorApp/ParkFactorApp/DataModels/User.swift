//
//  User.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/2/25.
//

import Foundation

// Codable struct to hold username and password
struct UserLoginFields : Codable {
    var username: String = ""
    var password: String = ""
}

// Codable struct to hold username, email and password
struct UserSignupFields : Codable {
    var username: String = ""
    var email: String = ""
    var password: String = ""
}

// Codable struct for user response when calling http login
struct UserLoginResponse: Codable {
    var user: User
    var token: String
}

// Codable Struct of a User object
struct User: Codable {
    var username: String
    var admin: Bool
    var email: String
    var favoritePlayer: Player?
    var favoriteTeam: Team?
    var followingPlayers: [Player]
    var followingTeams: [Team]
    var password: String
    var profilePicture: String?
    var userBiography: String
    var userLikedPosts: [String]
    var userTag: String
    var verified: Bool
}

// Codable struct for user response when calling the http register
struct UserRegisterResponse: Codable {
    let message: String
    let user: User
}

// This is the main way of saving a users information to User Defaults
@Observable
class SavedUser {
    var user: User {
        didSet {
            if let encoded = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(encoded, forKey: "User")
            }
        }
    }
    
    init() {
        if let savedUserData = UserDefaults.standard.data(forKey: "User"),
           let decodedUser = try? JSONDecoder().decode(User.self, from: savedUserData) {
            self.user = decodedUser
        } else {
            // Initialize with default or empty user
            self.user = User(username: "", admin: false, email: "", favoritePlayer: nil, favoriteTeam: nil, followingPlayers: [], followingTeams: [],  password: "", profilePicture: "", userBiography: "", userLikedPosts: [], userTag: "", verified: false)
        }
    }
}
