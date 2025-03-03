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

// Codable struct for user response when calling http login
struct UserResponse: Codable {
    let user: User
    let token: String
}

// Codable Struct of a User object
struct User: Codable {
    let password: String
    let admin: Bool
    let favoritePlayers: [String]
    let profilePicture: String
    let username: String
    let email: String
    let favoriteTeams: [String]
    let verified: Bool
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
            self.user = User(password: "", admin: false, favoritePlayers: [], profilePicture: "", username: "", email: "", favoriteTeams: [], verified: false)
        }
    }
}
