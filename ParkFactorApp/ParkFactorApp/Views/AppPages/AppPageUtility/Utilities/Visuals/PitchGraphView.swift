//
//  PitchGraphView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/19/25.
//

import SwiftUI

struct PitchPoint: Identifiable {
    var id = UUID()
    var x: Decimal
    var y: Decimal
    var color: Color
    var pitchName: String
    
    init(x: Decimal, y: Decimal, color: Color, pitchName: String) {
        self.x = x
        self.y = y
        self.color = color
        self.pitchName = pitchName
    }
}

struct PitchGraphView: View {
    var center: CGPoint
    var width: CGFloat = 325
    var dividers: Int = 3
    var sides: Int = 4
    var data: ArsenalDataPoint
    
    // Max Value of 24 inches and marker points for inches
    var maxValue: CGFloat = 24
    
    init(data: ArsenalDataPoint) {
        self.center = CGPoint(x: width / 2, y: width / 2)
        self.data = data
    }
    
    var body: some View {
        ZStack {
            Color.parkFactorSecondary.ignoresSafeArea()
            VStack {
                HStack {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(Color.white)
                        .opacity(1)
                        .font(.system(size: 24))
                    Text("L")
                        .font(.parkFactorFontText)
                        .foregroundStyle(Color.white)
                    Text("      ")
                    Text("R")
                        .font(.parkFactorFontText)
                        .foregroundStyle(Color.white)
                    Image(systemName: "arrow.right")
                        .foregroundStyle(Color.white)
                        .opacity(1)
                        .font(.system(size: 24))
                }
                .padding(.bottom, 40)
                
                ZStack {
                    // Draw the Spokes
                    Path { path in
                        for i in 0..<self.sides {
                            // Angle for spokes and length of spokes by x and y coordinates
                            let angle = radianAngleFromFraction(num: i, den: self.sides)
                            let x = (self.width) / 2 * cos(angle)
                            let y = (self.width) / 2 * sin(angle)
                            path.move(to: center)
                            // Draw the spokes
                            path.addLine(to: CGPoint(x: center.x + x, y: center.y + y))
                        }
                    }
                    .stroke(Color.white, style: StrokeStyle(lineWidth: 2))
                    
                    // Print the inches labels
                    Text("\(24)''")
                        .font(.parkFactorFontSmallText)
                        .foregroundStyle(Color.white)
                        .frame(width: 30, height: 10)
                    // This rotation effect helps with printing the text the correct way for the left side of the graph (as nothing would create upside down text)
                        .rotationEffect(.degrees(
                            (degreeAngleFromFraction(num: 3, den: self.sides) > 0) && (degreeAngleFromFraction(num: 3, den: self.sides) < 180) ? 270 : 90)
                        )
                        .offset(x: (self.width + 40) / 2, y: 20)
                        .rotationEffect(.radians(Double(radianAngleFromFraction(num: 3, den: self.sides))))
                    
                    Text("\(18)''")
                        .font(.parkFactorFontSmallText)
                        .foregroundStyle(Color.white)
                        .frame(width: 30, height: 10)
                    // This rotation effect helps with printing the text the correct way for the left side of the graph (as nothing would create upside down text)
                        .rotationEffect(.degrees(
                            (degreeAngleFromFraction(num: 3, den: self.sides) > 0) && (degreeAngleFromFraction(num: 3, den: self.sides) < 180) ? 270 : 90)
                        )
                        .offset(x: ((self.width / 1.35) + 40) / 2, y: 20)
                        .rotationEffect(.radians(Double(radianAngleFromFraction(num: 3, den: self.sides))))
                    
                    Text("\(12)''")
                        .font(.parkFactorFontSmallText)
                        .foregroundStyle(Color.white)
                        .frame(width: 30, height: 10)
                    // This rotation effect helps with printing the text the correct way for the left side of the graph (as nothing would create upside down text)
                        .rotationEffect(.degrees(
                            (degreeAngleFromFraction(num: 3, den: self.sides) > 0) && (degreeAngleFromFraction(num: 3, den: self.sides) < 180) ? 270 : 90)
                        )
                        .offset(x: ((self.width / 2.1) + 40) / 2, y: 20)
                        .rotationEffect(.radians(Double(radianAngleFromFraction(num: 3, den: self.sides))))
                    
                    Text("\(6)''")
                        .font(.parkFactorFontSmallText)
                        .foregroundStyle(Color.white)
                        .frame(width: 30, height: 10)
                    // This rotation effect helps with printing the text the correct way for the left side of the graph (as nothing would create upside down text)
                        .rotationEffect(.degrees(
                            (degreeAngleFromFraction(num: 3, den: self.sides) > 0) && (degreeAngleFromFraction(num: 3, den: self.sides) < 180) ? 270 : 90)
                        )
                        .offset(x: ((self.width / 4.4) + 40) / 2, y: 20)
                        .rotationEffect(.radians(Double(radianAngleFromFraction(num: 3, den: self.sides))))
                    
                    // Draw outer circle
                    Circle()
                        .stroke(.white, lineWidth: 5)
                        .frame(width: width, height: width)
                    
                    ForEach(0..<self.dividers) { i in
                        let size = ((self.width) * (CGFloat(i + 1) / CGFloat(self.dividers + 1)))
                        Circle()
                            .stroke(.white.opacity(0.5), lineWidth: 3)
                            .frame(width: size, height: size)
                    }
                    
                    // Show Pitch Circles
                    ForEach(data.entries) { pitch in
                        let transformed_x = ((self.width) / 2) * (CGFloat(truncating: pitch.x as NSNumber) / CGFloat(maxValue))
                        let transformed_y = -(((self.width) / 2) * (CGFloat(truncating: pitch.y as NSNumber) / CGFloat(maxValue)))
                        Circle()
                            .fill(pitch.color.opacity(0.5))
                            .offset(x: transformed_x, y: transformed_y)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Circle()
                                    .stroke(pitch.color, lineWidth: 4)
                                    .offset(x: transformed_x, y: transformed_y)
                                    .frame(width: 50, height: 50)
                            )
                    }
                }
                .frame(width: width, height: width)
                .padding(.bottom, 30)
                
                // Legend
                HStack {
                    Spacer()
                    ForEach(data.entries) { pitch in
                        VStack {
                            Capsule()
                                .fill(pitch.color.opacity(0.5))
                                .frame(width: 50, height: 20)
                                .overlay(
                                    Capsule()
                                        .stroke(pitch.color, lineWidth: 4)
                                        .frame(width: 50, height: 20)
                                )
                            Text("\(pitch.pitchName)")
                                .font(.parkFactorFontSmallText)
                                .foregroundStyle(Color.white)
                        }
                        Spacer()
                    }
                }
            }
        }
        .frame(width: 350, height: 550)
    }
}

#Preview {
    PitchGraphView(data: ArsenalDataPoint(entries: [PitchPoint(x: -4.7, y: 18.1, color: .red, pitchName: "4-Seam"), PitchPoint(x: 12.8, y: -5.2, color: .blue, pitchName: "Curve"), PitchPoint(x: -12.5, y: 10.7, color: .green, pitchName: "Change"), PitchPoint(x: 1.1, y: 8.7, color: .yellow, pitchName: "Slider")]))
}
