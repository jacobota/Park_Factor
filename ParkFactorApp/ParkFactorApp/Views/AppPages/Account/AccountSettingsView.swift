//
//  AccountSettingsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/8/25.
//

import SwiftUI

struct AccountSettingsView: View {
    @Binding var isLoggedIn: Bool
    @AppStorage("accessToken") private var accessToken: String?
    
    var savedUser: SavedUser
    
    var body: some View {
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
    }
}
    
#Preview {
    AccountSettingsViewPreviewWrapper()
}

struct AccountSettingsViewPreviewWrapper: View {
    @State private var isLoggedIn = true
    
    var body: some View {
        AccountSettingsView(isLoggedIn: $isLoggedIn, savedUser: SavedUser())
    }
}
