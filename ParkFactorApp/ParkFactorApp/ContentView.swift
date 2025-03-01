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
    
    var body: some View {
        if isLoading {
            LoadingScreenView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                        isLoading = false
                    }
                }
        } else {
            Text("Hello Park Factor")
        }
    }
}

#Preview {
    ContentView()
}
