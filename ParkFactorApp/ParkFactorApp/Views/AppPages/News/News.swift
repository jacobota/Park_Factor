//
//  NewsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/6/25.
//

import SwiftUI

struct NewsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    ScrollView {
                        Text("News Page")
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
                        Text("News")
                            .font(Font.parkFactorFontTitle)
                            .foregroundColor(.parkFactorPrimary)
                    }
                }
            }
        }
    }
}

#Preview {
    NewsView()
}
