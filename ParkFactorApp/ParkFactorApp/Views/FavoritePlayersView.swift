//
//  FavoritePlayersView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/3/25.
//

import SwiftUI

struct FavoritePlayersView: View {
    @Binding var isLoggedIn: Bool
    
    var savedUser: SavedUser
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    FavoritePlayersViewPreviewWrapper()
}

struct FavoritePlayersViewPreviewWrapper: View {
    @State private var isLoggedIn = false
    
    var body: some View {
        FavoritePlayersView(isLoggedIn: $isLoggedIn, savedUser: SavedUser())
    }
}
