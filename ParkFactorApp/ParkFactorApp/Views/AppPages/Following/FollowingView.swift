//
//  FollowingView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/6/25.
//

import SwiftUI

struct FollowingView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.parkFactorSecondary.ignoresSafeArea()
                VStack {
                    ScrollView {
                        Text("Following Page")
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray)
                .transition(.opacity)
                .padding(.vertical)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Image("ParkFactorLogo")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Text("Following")
                            .font(Font.parkFactorFontTitle)
                            .foregroundColor(.parkFactorPrimary)
                    }
                }
            }
        }
    }
}

#Preview {
    FollowingView()
}
