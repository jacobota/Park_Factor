//
//  HitterAdvancedStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/16/25.
//

import SwiftUI

struct HitterAdvancedStatsView: View {
    var hitterStatsHelper: HitterStatsHelper
    
    var body: some View {
        VStack {
            HStack {
                Text("Advanced")
                    .font(.parkFactorFontSubtitleNorwester)
                    .foregroundStyle(Color.white)
                
                Spacer()
            }
            .padding(20)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 5) {
                // First Row with stat category
                Text("wRC+")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("xwOBA")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("BB%")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("K%")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("BABIP")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                
                // Second Row with above categories
                Text("\(hitterStatsHelper.hitterStats?.wRCPlus ?? -1)")
                Text(String(format: "%.3f", NSDecimalNumber(decimal: hitterStatsHelper.hitterStats?.xWOBA ?? 0.0).doubleValue))
                Text(String(format: "%.3f", NSDecimalNumber(decimal: hitterStatsHelper.hitterStats?.walkPercentage ?? 0.0).doubleValue))
                Text(String(format: "%.3f", NSDecimalNumber(decimal: hitterStatsHelper.hitterStats?.strikeoutPercentage ?? 0.0).doubleValue))
                Text(String(format: "%.3f", NSDecimalNumber(decimal: hitterStatsHelper.hitterStats?.babip ?? 0.0).doubleValue))
                
                // Row for spacing
                Text("")
                Text("")
                Text("")
                Text("")
                Text("")
                
                // Fourth Row with more stat categories
                Text("WAR")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("ISO")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("DRS")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("OAA")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                Text("BsR")
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(Color.gray)
                
                // Second Row with above categories
                Text(String(format: "%.1f", NSDecimalNumber(decimal: hitterStatsHelper.hitterStats?.war ?? 0.0).doubleValue))
                Text(String(format: "%.3f", NSDecimalNumber(decimal: hitterStatsHelper.hitterStats?.iso ?? 0.0).doubleValue))
                Text("\(hitterStatsHelper.hitterStats?.defensiveRunsSaved ?? -1)")
                Text("\(hitterStatsHelper.hitterStats?.outsAboveAverage ?? -1)")
                Text("\(hitterStatsHelper.hitterStats?.bsr ?? -1)")
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
    HitterAdvancedStatsView(hitterStatsHelper: HitterStatsHelper(hitterStats: HitterStats(average: 0.196, babip: 0.132, walkPercentage: 0.119, walkToStrikeoutRatio: 0.57, barrelPercentage: 0.182, bsr: 0.5, caughtStealing: 0, contactPercentage: 0.726, defensiveRunsSaved: -1, errors: 1, exitVelocity: 89.3, fieldingPercentage: 0.96, games: 15, hits: 11, homeRuns: 6, hardHitPercentage: 0.455, iso: 0.339, strikeoutPercentage: 0.209, outsAboveAverage: -2, onBasePercentage: 0.299, onBasePlusSlugging: 0.834, runs: 9, rbi: 14, sb: 1, sluggingPercentage: 0.536, swingPercentage: 0.461, team: "LAA", uzr: nil, war: 0.2, winProbabilityAdded: 0.32, zSwingPercentage: 0.625, maxExitVelocity: 107.9, sprintSpeed: 28.2, wOBA: 0.345, wRCPlus: 125, wSB: 0.1, xBA: 0.269, xSlg: 0.665, xWOBA: 0.414)))
}
