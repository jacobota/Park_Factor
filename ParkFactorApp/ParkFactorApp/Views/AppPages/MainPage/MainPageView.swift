//
//  MainPageView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/6/25.
//

import SwiftUI

struct MainPageView: View {
    @AppStorage("accessToken") private var accessToken: String?
    
    var savedUser: SavedUser
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.parkFactorSecondary.ignoresSafeArea()
                VStack {
                    ScrollView {
                        
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.parkFactorAppPageBackground)
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
    MainPageView(savedUser: SavedUser())
}
