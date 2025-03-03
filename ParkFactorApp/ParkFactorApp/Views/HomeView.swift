//
//  HomeView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/1/25.
//

import SwiftUI

struct HomeView: View {
    @Binding var isLoggedIn: Bool
    @AppStorage("accessToken") private var accessToken: String?
    
    var savedUser: SavedUser
    
    var body: some View {
        ZStack {
            Color.parkFactorSecondary.ignoresSafeArea()
            VStack {
                Text("\(savedUser.user.admin)")
                    .font(.largeTitle)
                    .foregroundColor(.parkFactorPrimary)
                
                Button(action: {
                    // Log out and clear the token
                    accessToken = nil
                    isLoggedIn = false
                }) {
                    Text("Logout")
                        .font(.headline)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                .padding(.top, 20)
            }
        }
        .transition(.opacity)
    }
}

#Preview {
    HomeViewPreviewWrapper()
}

struct HomeViewPreviewWrapper: View {
    @State private var isLoggedIn = true
    
    var body: some View {
        HomeView(isLoggedIn: $isLoggedIn, savedUser: SavedUser())
    }
}
