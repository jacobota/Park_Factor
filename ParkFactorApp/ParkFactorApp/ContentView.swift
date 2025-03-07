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
        ZStack {
            Color.parkFactorSecondary.ignoresSafeArea()
            if isLoading {
                LoadingScreenView()
                    .onAppear {
                        checkLoginStatus()
                    }
            } else {
                if !isLoggedIn {
                    LoginView(isLoggedIn: $isLoggedIn, savedUser: savedUser)
                } else {
                    TabBarView(isLoggedIn: $isLoggedIn, savedUser: savedUser)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
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
