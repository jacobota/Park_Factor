//
//  VerifiedPost.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/23/25.
//

import Foundation

struct VerifiedUserPost: Codable {
    var authorProfilePicture: String = ""
    var content: String = ""
    var postImage: String = ""
}

struct VerifiedUserPostResponse: Codable {
    var postId: String
    var author: String
    var authorProfilePicture: String
    var content: String
    var postImage: String
    var createdAt: String
}
