//
//  ContentView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 2/28/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading = true
    @State private var isLoggedIn = false
    @State private var isNextView = false
    
    var body: some View {
        ZStack {
            Color.parkFactorSecondary.ignoresSafeArea()
            if isLoading {
                LoadingScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            // TODO: Check if the user is logged in
                            isLoading = false
                            isNextView.toggle()
                        }
                        
                    }
                    .transition(.opacity)
            } else {
                if isNextView {
                    if !isLoggedIn {
                        LoginView()
                            .transition(.opacity)
                    }
                    else {
                        HomeView()
                            .transition(.opacity)
                    }
                }
            }
        }
        .animation(.linear(duration: 1), value: isNextView)
    }
}

#Preview {
    ContentView()
}
