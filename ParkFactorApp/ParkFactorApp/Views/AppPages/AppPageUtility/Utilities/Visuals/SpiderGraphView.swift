//
//  SpiderGraphView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/18/25.
//  Followed tutorial from ChrisLearns video on Radar Graphs: https://www.youtube.com/watch?v=e3K9XxU3Pvk
//  Adjusted to my use case, but video did prove helpful for stylings and mathematical functions for working with angles
//  Personally learned a lot about the power of Path and drawing lines

import SwiftUI

struct Ray: Identifiable {
    var id = UUID()
    var name: String
    var maxValue: Int
    var rayCase: RayCase
    init(maxValue: Int, rayCase: RayCase) {
        self.rayCase = rayCase
        self.name = rayCase.rawValue
        self.maxValue = maxValue
    }
}

struct RayEntry {
    var rayCase: RayCase
    var value: Int
}

// Functions to Transform degrees to Radians
func degreeToRadian(_ degree: CGFloat) -> CGFloat {
    return degree * .pi / 180
}

func radianAngleFromFraction(num: Int, den: Int) -> CGFloat {
    return degreeToRadian(360 * (CGFloat((num)) / CGFloat(den)))
}

func degreeAngleFromFraction(num: Int, den: Int) -> CGFloat {
    return 360 * (CGFloat((num)) / CGFloat(den))
}

struct SpiderGraphView: View {
    var center: CGPoint
    var labelWidth: CGFloat = 80
    var width: CGFloat = 370
    var dividers: Int = 3
    var sides: [Ray]
    var data: DataPoint
    
    init(sides: [Ray], data: DataPoint) {
        self.center = CGPoint(x: width / 2, y: width / 2)
        self.sides = sides
        self.data = data
    }
    
    var body: some View {
        ZStack {
            Color.parkFactorSecondary.ignoresSafeArea()
            // Draw the Spokes
            Path { path in
                for i in 0..<self.sides.count {
                    // Angle for spokes and length of spokes by x and y coordinates
                    let angle = radianAngleFromFraction(num: i, den: self.sides.count)
                    let x = (self.width - (50 + self.labelWidth)) / 2 * cos(angle)
                    let y = (self.width - (50 + self.labelWidth)) / 2 * sin(angle)
                    path.move(to: center)
                    // Draw the spokes
                    path.addLine(to: CGPoint(x: center.x + x, y: center.y + y))
                }
            }
            .stroke(Color.white, style: StrokeStyle(lineWidth: 2))
            
            // Print the labels
            ForEach(0..<self.sides.count) { i in
                // Print the labels and rotate around the graph
                Text(self.sides[i].rayCase.rawValue)
                    .font(.parkFactorFontSmallText)
                    .foregroundStyle(Color.white)
                    .frame(width: self.labelWidth, height: 10)
                // This rotation effect helps with printing the text the correct way for the left side of the graph (as nothing would create upside down text)
                    .rotationEffect(.degrees(
                        (degreeAngleFromFraction(num: i, den: self.sides.count) > 0) && (degreeAngleFromFraction(num: i, den: self.sides.count) < 180) ? 270 : 90)
                    )
                    .offset(x: (self.width - (50)) / 2)
                    .rotationEffect(.radians(Double(radianAngleFromFraction(num: i, den: self.sides.count))))
            }
            
            // Draw the outer edge of graph
            Path { path in
                for i in 0..<self.sides.count + 1 {
                    let angle = radianAngleFromFraction(num: i, den: self.sides.count)
                    let x = (self.width - (50 + self.labelWidth)) / 2 * cos(angle)
                    let y = (self.width - (50 + self.labelWidth)) / 2 * sin(angle)
                    if i == 0 {
                        // Move the path to start at end of first spoke
                        path.move(to: CGPoint(x: center.x + x, y: center.y + y))
                    } else {
                        // Draw from last spoke to the next one
                        path.addLine(to: CGPoint(x: center.x + x, y: center.y + y))
                    }
                }
            }
            .stroke(Color.white, style: StrokeStyle(lineWidth: 2))
            
            // Dividers from center to outer border
            ForEach(0..<self.dividers) { i in
                Path { path in
                    for j in 0..<self.sides.count + 1 {
                        let angle = radianAngleFromFraction(num: j, den: self.sides.count)
                        // Set the distance between dividers evenly
                        let size = ((self.width - (50 + self.labelWidth)) / 2) * (CGFloat(i + 1) / CGFloat(self.dividers + 1))
                        let x = size * cos(angle)
                        let y = size * sin(angle)
                        if j == 0 {
                            // Move the path to start at where the divider is going to start
                            path.move(to: CGPoint(x: center.x + x, y: center.y + y))
                        } else {
                            // Draw from last spoke to the next one
                            path.addLine(to: CGPoint(x: center.x + x, y: center.y + y))
                        }
                    }
                }
                .stroke(Color.white.opacity(0.4), style: StrokeStyle(lineWidth: 2))
            }
            
            Path { path in
                for i in 0..<self.sides.count + 1 {
                    // Loops back to current side if it reachs the last number to complete the visual polygon
                    let currentSide = self.sides[i == self.sides.count ? 0 : i]
                    let maxValue = currentSide.maxValue
                    let value: Int = {
                        for dataPoint in self.data.entries {
                            if currentSide.rayCase == dataPoint.rayCase {
                                return dataPoint.value
                            }
                        }
                        return 0
                    }()
                    
                    let angle = radianAngleFromFraction(num: i == self.sides.count ? 0 : i, den: self.sides.count)
                    let size = ((self.width - (50 + self.labelWidth)) / 2) * (CGFloat(value) / CGFloat(maxValue))
                    
                    let x = size * cos(angle)
                    let y = size * sin(angle)
                    if i == 0 {
                        // Move the path to start at where the divider is going to start
                        path.move(to: CGPoint(x: center.x + x, y: center.y + y))
                    } else {
                        // Draw from last spoke to the next one
                        path.addLine(to: CGPoint(x: center.x + x, y: center.y + y))
                    }
                    
                }
            }
            .stroke(self.data.color, style: StrokeStyle(lineWidth: 4))
            .fill(self.data.color.opacity(0.6))
        }
        .frame(width: self.width, height: width)
    }
}

#Preview {
    SpiderGraphView(sides: [
        Ray(maxValue: 100, rayCase: .Xwoba),
        Ray(maxValue: 100, rayCase: .ExitVelocity),
        Ray(maxValue: 100, rayCase: .BarrelPercent),
        Ray(maxValue: 100, rayCase: .StrikoutPercent),
        Ray(maxValue: 100, rayCase: .WalkPercent),
        Ray(maxValue: 100, rayCase: .OutsAboveAverage)],
                    data: DataPoint(rc1: .Xwoba, rc2: .ExitVelocity, rc3: .BarrelPercent, rc4: .StrikoutPercent, rc5: .WalkPercent, rc6: .OutsAboveAverage, val1: 22, val2: 55, val3: 75, val4: 10, val5: 85, val6: 99, color: .blue))
}
