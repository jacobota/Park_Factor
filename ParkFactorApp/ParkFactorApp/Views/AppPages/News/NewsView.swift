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
                VStack {
                    ZStack {
                        Color.parkFactorSecondary
                        VStack {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(subTabs, id: \.self) { subTab in
                                        Button(action: {
                                            selectedTab = subTab
                                        }) {
                                            Text(subTab)
                                                .font(Font.parkFactorFontTextNorwester)
                                                .foregroundColor(selectedTab == subTab ? Color.parkFactorSecondary : Color.parkFactorPrimary)
                                                .padding()
                                                .background(selectedTab == subTab ? Color.parkFactorPrimary : Color.clear)
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.parkFactorSecondary)
                                .cornerRadius(8)
                            }
                            .defaultScrollAnchor(.center) 
                            .scrollDisabled(true)
                        }
                    }
                    .frame(width: .infinity, height: 75)
                    
                    Spacer()
                    
                    if selectedTab == "Around the League" {
                        LeagueNewsView()
                    } else if selectedTab == "The Concourse" {
                        ConcourseView()
                    }
                    
                    Spacer()

                    .padding()
                
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.parkFactorAppPageBackground)
                .padding(.vertical)
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
