//
//  StatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/6/25.
//

import SwiftUI

struct StatsView: View {
    @State private var selectedTab: String = "Teams"
    
    let subTabs = ["Teams", "Players"]
    
    var savedUser: SavedUser
    
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
                    
                    if selectedTab == "Players" {
                        PlayerStatsPageView(savedUser: savedUser)
                    } else if selectedTab == "Teams" {
                        TeamStatsPageView(savedUser: savedUser)
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
                        Text("Stats")
                            .font(Font.parkFactorFontTitle)
                            .foregroundColor(.parkFactorPrimary)
                    }
                }
            }
        }
    }
}

#Preview {
    StatsView(savedUser: SavedUser())
}
