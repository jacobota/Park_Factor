//
//  NewsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/6/25.
//

import SwiftUI

struct NewsView: View {
    @State private var selectedTab: String = "News"
    
    let subTabs = ["News", "Community"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.parkFactorSecondary.ignoresSafeArea()
                VStack(spacing: 0) {
                    VStack {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(subTabs, id: \.self) { subTab in
                                    Button(action: {
                                        selectedTab = subTab
                                    }) {
                                        Text(subTab)
                                            .font(Font.parkFactorFontTextNorwester)
                                            .foregroundColor(selectedTab == subTab ? Color.parkFactorPrimary : Color.gray)
                                            .padding()
                                            .cornerRadius(10)
                                    }
                                }
                            }
                            .background(Color.parkFactorSecondary)
                            .cornerRadius(8)
                        }
                        .scrollDisabled(true)
                        .frame(height: 25)
                        .padding()
                    }
                    .background(Color.parkFactorSecondary)
                    
                    if selectedTab == "News" {
                        LeagueNewsView(newsArticles: [NewsArticle(
                            source: NewsArticle.Source(id: "espn", name: "ESPN"),
                            author: "Alden Gonzalez",
                            title: "Manfred: Dodgers doing what the system allows",
                            description: "Commissioner Rob Manfred on Tuesday acknowledged the widespread concern over payroll disparity in MLB but said he blames the system, not the Dodgers.",
                            url: "https://www.espn.com/mlb/story/_/id/43911888/mlb-manfred-blame-system-not-dodgers-payroll-disparity",
                            urlToImage: "https://a1.espncdn.com/combiner/i?img=%2Fphoto%2F2024%2F0216%2Fr1291998_1296x729_16%2D9.jpg",
                            publishedAt: Date(),
                            content: "PHOENIX, Ariz. -- Major League Baseball commissioner Rob Manfred on Tuesday called payroll disparity a principal concern throughout the industry but would not necessarily commit to a salary cap as a … [+6149 chars]"
                        ), NewsArticle(
                            source: NewsArticle.Source(id: "espn", name: "ESPN"),
                            author: "Alden Gonzalez",
                            title: "Manfred: Dodgers doing what the system allows",
                            description: "Commissioner Rob Manfred on Tuesday acknowledged the widespread concern over payroll disparity in MLB but said he blames the system, not the Dodgers.",
                            url: "https://www.espn.com/mlb/story/_/id/43911888/mlb-manfred-blame-system-not-dodgers-payroll-disparity",
                            urlToImage: "https://a1.espncdn.com/combiner/i?img=%2Fphoto%2F2024%2F0216%2Fr1291998_1296x729_16%2D9.jpg",
                            publishedAt: Date(),
                            content: "PHOENIX, Ariz. -- Major League Baseball commissioner Rob Manfred on Tuesday called payroll disparity a principal concern throughout the industry but would not necessarily commit to a salary cap as a … [+6149 chars]"
                        )])
                    } else if selectedTab == "Community" {
                        ConcourseView()
                    }
                    
                    Spacer()
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom)
                .padding(.top, 10)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Image("ParkFactorLogo")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Text("The Concourse")
                            .font(Font.parkFactorFontTitle)
                            .foregroundColor(.parkFactorPrimary)
                    }
                }
            }
        }
    }
}

#Preview {
    NewsView()
}
