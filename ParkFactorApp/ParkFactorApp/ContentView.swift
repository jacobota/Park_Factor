//
//  ContentView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 2/28/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("accessToken") private var accessToken: String?
    @State private var savedUser = SavedUser()
    @State private var isLoading = true
    @State private var isLoggedIn = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.parkFactorSecondary.ignoresSafeArea()
                if isLoading {
                    LoadingScreenView()
                        .onAppear {
                            checkLoginStatus()
                        }
                        .transition(.opacity)
                } else {
                    if !isLoggedIn {
                        LoginView(isLoggedIn: $isLoggedIn, savedUser: savedUser)
                            .transition(.opacity)
                    } else {
                        HomeView(isLoggedIn: $isLoggedIn, savedUser: savedUser)
                            .transition(.opacity)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .animation(.linear(duration: 1), value: isLoading)
        .animation(.linear(duration: 1), value: isLoggedIn)
    }
    
    private func checkLoginStatus() {
        // Checks if the value in accessToken is not nil with a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let _ = accessToken {
                isLoggedIn = true
            }
            isLoading = false
        }
    }
}

#Preview {
    ContentView()
}
