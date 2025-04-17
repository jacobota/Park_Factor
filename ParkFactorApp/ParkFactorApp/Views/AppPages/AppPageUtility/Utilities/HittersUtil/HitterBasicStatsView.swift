//
//  HitterBasicStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/16/25.
//

import SwiftUI

struct HitterBasicStatsView: View {
    var hitterStatsHelper: HitterStatsHelper
    
    var body: some View {
        VStack {
            HStack {
                Text("Standard")
                    .font(.parkFactorFontSubtitleNorwester)
                    .foregroundStyle(Color.white)
                
                Spacer()
            }
            .padding(20)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 5) {
                // First Row with stat category
                Text("G")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("BA")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("OBP")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("SLG")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("OPS")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                
                // Second Row with above categories
                Text("\(hitterStatsHelper.hitterStats?.games ?? -1)")
                Text(String(format: "%.3f", NSDecimalNumber(decimal: hitterStatsHelper.hitterStats?.average ?? 0.0).doubleValue))
                Text(String(format: "%.3f", NSDecimalNumber(decimal: hitterStatsHelper.hitterStats?.onBasePercentage ?? 0.0).doubleValue))
                Text(String(format: "%.3f", NSDecimalNumber(decimal: hitterStatsHelper.hitterStats?.sluggingPercentage ?? 0.0).doubleValue))
                Text(String(format: "%.3f", NSDecimalNumber(decimal: hitterStatsHelper.hitterStats?.onBasePlusSlugging ?? 0.0).doubleValue))
                
                // Row for spacing
                Text("")
                Text("")
                Text("")
                Text("")
                Text("")
                
                // Fourth Row with more stat categories
                Text("H")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("HR")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("R")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("RBI")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("SB")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                
                // Second Row with above categories
                Text("\(hitterStatsHelper.hitterStats?.hits ?? -1)")
                Text("\(hitterStatsHelper.hitterStats?.homeRuns ?? -1)")
                Text("\(hitterStatsHelper.hitterStats?.runs ?? -1)")
                Text("\(hitterStatsHelper.hitterStats?.rbi ?? -1)")
                Text("\(hitterStatsHelper.hitterStats?.sb ?? -1)")
            }
            .font(.parkFactorFontSmallText)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color.black)
        .cornerRadius(10)
    }
}

#Preview {
    HitterBasicStatsView(hitterStatsHelper: HitterStatsHelper(hitterStats: HitterStats(average: 0.196, babip: 0.132, walkPercentage: 0.119, walkToStrikeoutRatio: 0.57, barrelPercentage: 0.182, bsr: 0.5, caughtStealing: 0, contactPercentage: 0.726, defensiveRunsSaved: -1, errors: 1, exitVelocity: 89.3, fieldingPercentage: 0.96, games: 15, hits: 11, homeRuns: 6, hardHitPercentage: 0.455, iso: 0.339, strikeoutPercentage: 0.209, outsAboveAverage: -2, onBasePercentage: 0.299, onBasePlusSlugging: 0.834, runs: 9, rbi: 14, sb: 1, sluggingPercentage: 0.536, swingPercentage: 0.461, team: "LAA", uzr: nil, war: 0.2, winProbabilityAdded: 0.32, zSwingPercentage: 0.625, maxExitVelocity: 107.9, sprintSpeed: 28.2, wOBA: 0.345, wRCPlus: 125, wSB: 0.1, xBA: 0.269, xSlg: 0.665, xWOBA: 0.414)))
}
