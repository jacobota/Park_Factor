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
