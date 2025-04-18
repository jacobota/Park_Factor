//
//  TeamNoDataPageView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/18/25.
//

import SwiftUI

struct TeamNoDataPageView: View {
    var teamAbbr: String
    var body: some View {
        ZStack {
            Color.parkFactorSecondary.ignoresSafeArea()
            VStack(spacing: 0) {
                ZStack {
                    Color.parkFactorAppPageBackground.ignoresSafeArea()
                    VStack {
                        Text("Apologies!")
                            .foregroundStyle(Color.parkFactorPrimary)
                            .font(.parkFactorFontTitle)
                        Text("Could not find stats for")
                            .foregroundStyle(Color.parkFactorPrimary)
                            .font(.parkFactorFontTitle)
                            .multilineTextAlignment(.center)
                        Text(teamAbbr)
                            .foregroundStyle(Color.parkFactorPrimary)
                            .font(.parkFactorFontTitle)
                    }
                }
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom)
            .padding(.top, 10)
        }
    }
}

#Preview {
    TeamNoDataPageView(teamAbbr: "LAA")
}
