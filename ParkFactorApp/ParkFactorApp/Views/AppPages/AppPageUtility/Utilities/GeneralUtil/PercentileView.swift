//
//  PercentileView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/16/25.
//

import SwiftUI

struct PercentileView: View {
    var percentile: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Outer capsule with a grey border
                Capsule()
                    .strokeBorder(Color.gray, lineWidth: 2)
                    .background(Capsule().fill(Color.parkFactorAppPageBackground))
                    .frame(height: 20)
                
                // Inner capsule, filling based on the percentile
                Capsule()
                    .fill(percentileColor())
                    .frame(width: CGFloat(percentile) / 100 * geometry.size.width, height: 18)
                    .padding(.leading, 2)
                    .overlay(
                        Text("\(percentile)")
                            .foregroundColor(Color.black)
                            .font(.parkFactorFontTextNorwester)
                            .padding(.trailing, 10)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    )
            }
        }
    }
    
    private func percentileColor() -> Color {
        if percentile > 97 {
            return Color(red: 1.0, green: 0.843, blue: 0.0)
        } else if percentile > 90 {
            return Color(red: 0.0, green: 0.392, blue: 0.0)
        } else if percentile > 75 {
            return Color(red: 0.678, green: 1.0, blue: 0.184)
        } else if percentile > 50 {
            return Color(red: 1.0, green: 1.0, blue: 0.0)
        } else if percentile > 25 {
            return Color(red: 1.0, green: 0.647, blue: 0.0)
        } else if percentile > 5 {
            return Color(red: 1.0, green: 0.0, blue: 0.0)
        } else {
            return Color(red: 0.545, green: 0.0, blue: 0.0)
        }
    }
}

#Preview {
    PercentileView(percentile: 76)
}
