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
    var password: String
    var admin: Bool
    var favoritePlayers: [Player]
    var profilePicture: String
    var username: String
    var email: String
    var favoriteTeams: [String]
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
            self.user = User(password: "", admin: false, favoritePlayers: [], profilePicture: "", username: "", email: "", favoriteTeams: [], verified: false)
        }
    }
}
