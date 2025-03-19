//
//  NewsArticleCardView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/19/25.
//

import SwiftUI

struct NewsArticleCardView: View {
    let newsArticle: NewsArticle

    var body: some View {
        VStack {
            if let url = URL(string: newsArticle.urlToImage) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .cornerRadius(15)
                } placeholder: {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: 200)
                }
            }
            Text(newsArticle.title)
                .font(.parkFactorFontBigTextNorwester)
                .foregroundStyle(Color.parkFactorPrimary)
                .multilineTextAlignment(.center)
                .padding(.top, 5)
            VStack(alignment: .leading) {
                Text(newsArticle.description)
                    .font(.parkFactorFontSubSectionText)
                    .foregroundColor(.gray)
                    .padding(.top, 2)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}
#Preview {
    NewsArticleCardView(newsArticle: NewsArticle(
        source: NewsArticle.Source(id: "espn", name: "ESPN"),
        author: "Alden Gonzalez",
        title: "Manfred: Dodgers doing what the system allows",
        description: "Commissioner Rob Manfred on Tuesday acknowledged the widespread concern over payroll disparity in MLB but said he blames the system, not the Dodgers.",
        url: "https://www.espn.com/mlb/story/_/id/43911888/mlb-manfred-blame-system-not-dodgers-payroll-disparity",
        urlToImage: "https://a1.espncdn.com/combiner/i?img=%2Fphoto%2F2024%2F0216%2Fr1291998_1296x729_16%2D9.jpg",
        publishedAt: Date(),
        content: "PHOENIX, Ariz. -- Major League Baseball commissioner Rob Manfred on Tuesday called payroll disparity a principal concern throughout the industry but would not necessarily commit to a salary cap as a … [+6149 chars]"
    ))
}
