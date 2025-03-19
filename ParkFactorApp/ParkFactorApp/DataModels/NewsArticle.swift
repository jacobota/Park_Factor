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
    let author: String
    let title: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: Date
    let content: String

    struct Source: Codable {
        let id: String?
        let name: String
    }
}
