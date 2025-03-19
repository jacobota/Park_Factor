//
//  NewsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/6/25.
//

import SwiftUI

struct NewsView: View {
    @State private var selectedTab: String = "Around the League"
    
    let subTabs = ["Around the League", "The Concourse"]
    
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
                    
                    if selectedTab == "Around the League" {
                        LeagueNewsView()
                    } else if selectedTab == "The Concourse" {
                        ConcourseView()
                    }
                    
                    Spacer()
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.parkFactorAppPageBackground)
                .padding(.bottom)
                .padding(.top, 10)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Image("ParkFactorLogo")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Text("News")
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
