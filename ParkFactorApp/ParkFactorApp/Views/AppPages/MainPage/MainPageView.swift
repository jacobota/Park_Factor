//
//  MainPageView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/6/25.
//

import SwiftUI

struct MainPageView: View {
    @Binding var isLoggedIn: Bool
    @AppStorage("accessToken") private var accessToken: String?
    
    var savedUser: SavedUser
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    ScrollView {
                        Text("\(savedUser.user.username)")
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
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray)
                .transition(.opacity)
                .padding(.vertical)
            }
            .navigationTitle("Park Factor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Image("ParkFactorLogo")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Text("Park Factor")
                            .font(Font.parkFactorFontTitle)
                            .foregroundColor(Color.parkFactorPrimary)
                    }
                }
            }
        }
    }
}

#Preview {
    MainPageViewPreviewWrapper()
}

struct MainPageViewPreviewWrapper: View {
    @State private var isLoggedIn = true
    
    var body: some View {
        MainPageView(isLoggedIn: $isLoggedIn, savedUser: SavedUser())
    }
}
