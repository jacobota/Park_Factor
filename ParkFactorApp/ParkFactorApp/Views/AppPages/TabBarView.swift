//
//  TabBarView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/1/25.
//

import SwiftUI

struct TabBarView: View {
    @Binding var isLoggedIn: Bool
    @AppStorage("accessToken") private var accessToken: String?
    @State private var selectedTab: Tabs = .stats
    
    var savedUser: SavedUser
    
    enum Tabs {
        case stats
        case news
        case favorites
        case account
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Stats", systemImage: "chart.bar.xaxis", value: .stats) {
                StatsView()
            }
            Tab("Concourse", systemImage: "newspaper", value: .news) {
                NewsView(savedUser: savedUser)
            }
            Tab("Following", systemImage: "flag", value: .favorites) {
                FollowingView(savedUser: savedUser)
            }
            Tab("Account", systemImage: "person", value: .account) {
                AccountView(isLoggedIn: $isLoggedIn, savedUser: savedUser)
            }
        }
        .accentColor(Color.parkFactorPrimary)
        .onAppear {
            UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
        }
    }
}

#Preview {
    TabBarViewPreviewWrapper()
}

struct TabBarViewPreviewWrapper: View {
    @State private var isLoggedIn = true
    
    var body: some View {
        TabBarView(isLoggedIn: $isLoggedIn, savedUser: SavedUser())
    }
}
