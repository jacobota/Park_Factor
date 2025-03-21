//
//  Post.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/20/25.
//

import Foundation

struct Post: Identifiable, Codable {
    let id: UUID = UUID()
    let postId: String
    let author: String?
    let authorProfilePicture: String?
    let createdAt: String?
    let content: String?
    let postImage: String?

    var formattedCreatedAtDate: String? {
        guard let postCreatedAt = createdAt else {return nil}
        // Format the ISO8601 to a string formatted date
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
            
        // get the output to the date or return nil
        if let date = inputFormatter.date(from: postCreatedAt) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMMM dd, yyyy"
            return outputFormatter.string(from: date)
        } else {
            return nil
        }
    }
}
