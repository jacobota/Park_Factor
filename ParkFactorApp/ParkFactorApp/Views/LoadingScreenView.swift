//
//  LoadingScreenView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 2/28/25.
//

import SwiftUI

struct LoadingScreenView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.parkFactorSecondary.ignoresSafeArea()
            Image("ParkFactorLogo")
                .resizable()
                .scaledToFit()
                .containerRelativeFrame(.horizontal) { size, axis in
                    size * 0.85
                }
                .scaleEffect(isAnimating ? 1.15 : 1.0)
                
                .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(.bouncy(duration: 0.5, extraBounce: 0.5).repeatForever(autoreverses: true)) {
                            isAnimating = true
                        }
                    }
                }
        }
    }
}

#Preview {
    LoadingScreenView()
}
