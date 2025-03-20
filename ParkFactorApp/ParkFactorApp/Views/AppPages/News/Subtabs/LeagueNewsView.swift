//
//  LeagueNewsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/8/25.
//

import SwiftUI

struct LeagueNewsView: View {
    @State private var filterText: String = "All"
    
    let newsArticles: [NewsArticle] = [NewsArticle(
        source: NewsArticle.Source(id: "espn", name: "ESPN"),
        author: "Alden Gonzalez",
        title: "Manfred: Dodgers doing what the system allows",
        description: "Commissioner Rob Manfred on Tuesday acknowledged the widespread concern over payroll disparity in MLB but said he blames the system, not the Dodgers.",
        url: "https://www.espn.com/mlb/story/_/id/43911888/mlb-manfred-blame-system-not-dodgers-payroll-disparity",
        urlToImage: "https://a1.espncdn.com/combiner/i?img=%2Fphoto%2F2024%2F0216%2Fr1291998_1296x729_16%2D9.jpg",
        publishedAt: Date(),
        content: "PHOENIX, Ariz. -- Major League Baseball commissioner Rob Manfred on Tuesday called payroll disparity a principal concern throughout the industry but would not necessarily commit to a salary cap as a … [+6149 chars]"
    )]
    
    //let newsArticles: [NewsArticle] = []
    let allMlbTeams = [
        "All", "Angels", "Astros", "Athletics", "Blue Jays", "Braves", "Brewers",
        "Cardinals", "Cubs", "Diamondbacks", "Dodgers","Giants", "Guardians",
        "Mariners", "Marlins", "Mets", "Nationals", "Orioles", "Padres",
        "Phillies", "Pirates", "Rangers", "Rays", "Red Sox", "Reds", "Rockies",
        "Royals", "Tigers", "Twins", "White Sox", "Yankees"
    ]
    
    // TODO: Implement addition of favorite team and following teams
    var savedUser: SavedUser
    
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            ScrollView {
                HStack {
                    Spacer()
                    NavigationLink(destination: FilterNewsView(filterText: $filterText)) {
                        HStack {
                            Image(systemName: "line.horizontal.3.decrease.circle")
                                .foregroundColor(.parkFactorPrimary)
                                .font(.system(size: 20))
                            Text("Filter By Team")
                                .font(.parkFactorFontTextNorwester)
                                .foregroundColor(.parkFactorPrimary)
                        }
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 10)
                }
                Text("\(filterText) News")
                    .font(.parkFactorFontSubtitleNorwester)
                    .foregroundColor(.parkFactorPrimary)
                    .padding(.bottom, 0)
                LazyVStack(spacing: 0) {
                    ForEach(newsArticles) { newsArticle in
                        NavigationLink(destination: NewsArticleDetailedPageView(newsArticle: newsArticle)) {
                            NewsArticleCardView(newsArticle: newsArticle)
                        }
                        .buttonStyle(.plain)
                        Rectangle()
                            .fill(Color.parkFactorPrimary)
                            .frame(height: 2)
                            .padding(.vertical, 10)
                    }
                }
            }
        }
        .onAppear {
            
        }
    }
}

#Preview {
   LeagueNewsView(savedUser: SavedUser())
}
