//
//  NewsArticle.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/19/25.
//

import Foundation

struct NewsArticle: Identifiable, Codable {
    let id: UUID = UUID()
    let source: Source
    let author: String?
    let title: String
    let description: String
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String

    struct Source: Codable {
        let id: String?
        let name: String?
    }
    
    var formattedPublishedDate: String? {
        // Format the ISO8601 to a string formatted date
        guard let publishedAt = publishedAt else { return nil }
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
            
        // get the output to the date or return nil
        if let date = inputFormatter.date(from: publishedAt) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMMM dd, yyyy"
            return outputFormatter.string(from: date)
        } else {
            return nil
        }
    }
    
    var cleanedContent: String {
        // Regix patterns to identify the starting date and chars output at the end
        let datePattern = "\\b[A-Z][a-z]{2} \\d{2}, \\d{4}, \\d{2}:\\d{2} (AM|PM) ET\\r\\n"
        let charsPattern = "\\[\\+\\d+ chars\\]"
        
        var cleanContent = content
        
        // Remove the starting date pattern and chars at the end
        if let dateRange = cleanContent.range(of: datePattern, options: .regularExpression) {
            cleanContent.removeSubrange(dateRange)
        }
        if let charsRange = cleanContent.range(of: charsPattern, options: .regularExpression) {
            cleanContent.removeSubrange(charsRange)
        }
        
        return cleanContent
    }
}
