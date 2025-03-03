//
//  FavoriteTeamsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/2/25.
//

import SwiftUI

struct FavoriteTeamsView: View {
    var body: some View {
        ZStack {
            Color.parkFactorSecondary.ignoresSafeArea()
            VStack {
                Section {
                    Text("Select Favorite Teams")
                        .font(.parkFactorFontTitle)
                        .foregroundStyle(Color.white)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
                .padding(.bottom, 20)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    FavoriteTeamsView()
}
