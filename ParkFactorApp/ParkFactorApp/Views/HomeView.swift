//
//  HomeView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/1/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color.parkFactorSecondary.ignoresSafeArea()
            Text("Home View")
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    HomeView()
}
