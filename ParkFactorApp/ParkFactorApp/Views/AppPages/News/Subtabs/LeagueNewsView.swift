//
//  LeagueNewsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/8/25.
//

import SwiftUI

struct LeagueNewsView: View {
    let newsArticles: [NewsArticle]
    
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(newsArticles) { newsArticle in
                        NavigationLink(destination: NewsArticleDetailedPageView(newsArticle: newsArticle)) {
                            NewsArticleCardView(newsArticle: newsArticle)
                        }
                        .buttonStyle(.plain)
                        Rectangle()
                            .fill(Color.parkFactorPrimary)
                            .frame(height: 4)
                            .padding(.vertical, 10)
                    }
                }
            }
        }
    }
}

#Preview {
   LeagueNewsView(
        newsArticles: [NewsArticle(
        source: NewsArticle.Source(id: "espn", name: "ESPN"),
        author: "Alden Gonzalez",
        title: "Manfred: Dodgers doing what the system allows",
        description: "Commissioner Rob Manfred on Tuesday acknowledged the widespread concern over payroll disparity in MLB but said he blames the system, not the Dodgers.",
        url: "https://www.espn.com/mlb/story/_/id/43911888/mlb-manfred-blame-system-not-dodgers-payroll-disparity",
        urlToImage: "https://a1.espncdn.com/combiner/i?img=%2Fphoto%2F2024%2F0216%2Fr1291998_1296x729_16%2D9.jpg",
        publishedAt: Date(),
        content: "PHOENIX, Ariz. -- Major League Baseball commissioner Rob Manfred on Tuesday called payroll disparity a principal concern throughout the industry but would not necessarily commit to a salary cap as a … [+6149 chars]"
    )])
}
