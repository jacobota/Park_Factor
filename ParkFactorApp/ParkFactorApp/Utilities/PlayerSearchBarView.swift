//
//  PlayerSearchBarView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/5/25.
//

import SwiftUI

struct PlayerSearchBarView: View {
    @Binding var searchText: String
    @Binding var searchIsFocused: Bool
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            TextField("Search players", text: $searchText)
                .padding(10)
                .font(.parkFactorFontText)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.parkFactorSecondary)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.parkFactorPrimary, lineWidth: 4)
                )
                .foregroundStyle(Color.parkFactorPrimary)
                .focused($isFocused)
                .onChange(of: isFocused) { oldValue, newValue in
                    searchIsFocused = newValue
                }
                .onAppear {
                    isFocused = searchIsFocused
                }
                
                
            Button(action: {
                searchText = ""
                searchIsFocused = false
                isFocused = false
            }) {
                Text("Clear")
                    .font(.parkFactorFontText)
                    .foregroundColor(Color.parkFactorPrimary)
            }
            .padding(10)
        }
        .padding(10)
    }
}

#Preview {
    PlayerSearchBarPreviewWrapper()
}

struct PlayerSearchBarPreviewWrapper: View {
    @State private var searchText: String = ""
    @State private var searchIsFocused: Bool = false
    
    var body: some View {
        PlayerSearchBarView(searchText: $searchText, searchIsFocused: $searchIsFocused)
    }
}
