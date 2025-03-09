//
//  FollowingView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/6/25.
//

import SwiftUI

struct FollowingView: View {
    @State private var selectedTab: String = "Teams"
    
    let subTabs = ["Teams", "Players"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.parkFactorSecondary.ignoresSafeArea()
                VStack {
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
                            .background(Color.parkFactorSecondary)
                            .cornerRadius(8)
                        }
                        .scrollDisabled(true)
                        .frame(width: .infinity, height: 70)
                        .padding()
                    }
                    .background(Color.parkFactorSecondary)
                    
                    if selectedTab == "Teams" {
                        TeamsFollowingView()
                    } else if selectedTab == "Players" {
                        PlayersFollowingView()
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
                        Text("Following")
                            .font(Font.parkFactorFontTitle)
                            .foregroundColor(.parkFactorPrimary)
                    }
                }
            }
        }
    }
}

#Preview {
    FollowingView()
}
