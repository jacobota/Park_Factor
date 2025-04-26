//
//  HitterCareerAdvancedStatsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/17/25.
//

import SwiftUI

struct HitterCareerAdvancedStatsView: View {
    var hittingCareerStatsHelper: HittingCareerStatsHelper?
    
    @State private var isSheetPresented: Bool = false
    @State private var selectedStat: String = ""
    
    var body: some View {
        VStack {
            if let careerStats = hittingCareerStatsHelper?.hittingCareerStats {
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
                        Button(action: {
                            selectedStat = "hitter_wrcplus"
                        }) {
                            Text("wRC+")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                        }
                        Button(action: {
                            selectedStat = "hitter_woba"
                        }) {
                            Text("wOBA")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                        }
                        Button(action: {
                            selectedStat = "hitter_bbpercent"
                        }) {
                            Text("BB%")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                        }
                        Button(action: {
                            selectedStat = "hitter_kpercent"
                        }) {
                            Text("K%")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                        }
                        Button(action: {
                            selectedStat = "hitter_babip"
                        }) {
                            Text("BABIP")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                        }
                        
                        // Second Row with above categories
                        Text("\(careerStats[0].wrcPlus ?? -1)")
                        Text(String(format: "%.3f", NSDecimalNumber(decimal: careerStats[0].woba ?? 0.0).doubleValue))
                        Text(String(format: "%.3f", NSDecimalNumber(decimal: careerStats[0].bbPercent ?? 0.0).doubleValue))
                        Text(String(format: "%.3f", NSDecimalNumber(decimal: careerStats[0].kPercent ?? 0.0).doubleValue))
                        Text(String(format: "%.3f", NSDecimalNumber(decimal: careerStats[0].babip ?? 0.0).doubleValue))
                        
                        // Row for spacing
                        Text("")
                        Text("")
                        Text("")
                        Text("")
                        Text("")
                        
                        // Fourth Row with more stat categories
                        Button(action: {
                            selectedStat = "hitter_war"
                        }) {
                            Text("WAR")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                        }
                        Button(action: {
                            selectedStat = "hitter_iso"
                        }) {
                            Text("ISO")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                        }
                        Button(action: {
                            selectedStat = "hitter_wpa"
                        }) {
                            Text("WPA")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                        }
                        Button(action: {
                            selectedStat = "hitter_wsb"
                        }) {
                            Text("wSB")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                        }
                        Button(action: {
                            selectedStat = "hitter_bsr"
                        }) {
                            Text("BsR")
                                .font(.parkFactorFontSmallText)
                                .foregroundColor(Color.gray)
                        }
                        
                        // Second Row with above categories
                        Text(String(format: "%.1f", NSDecimalNumber(decimal: careerStats[0].war ?? 0.0).doubleValue))
                        Text(String(format: "%.3f", NSDecimalNumber(decimal: careerStats[0].iso ?? 0.0).doubleValue))
                        Text(String(format: "%.2f", NSDecimalNumber(decimal: careerStats[0].wpa ?? 0.0).doubleValue))
                        Text(String(format: "%.1f", NSDecimalNumber(decimal: careerStats[0].wsb ?? 0.0).doubleValue))
                        Text("\(careerStats[0].bsr ?? -1)")
                    }
                    .font(.parkFactorFontSmallText)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .background(Color.black)
                .cornerRadius(10)
                .onChange(of: selectedStat) {
                    isSheetPresented = true
                }
                .sheet(isPresented: $isSheetPresented) {
                    StatExplanationView(stat: selectedStat)
                }
            }
        }
    }
}

#Preview {
    HitterCareerAdvancedStatsView(hittingCareerStatsHelper: HittingCareerStatsHelper(hittingCareerStats: [HittingCareerStats(avg: 0.298, babip: 0.341, bbPercent: 0.147, bbK: 0.66, barrelPercent: 0.157, bsr: 51, cs: 38, contactPercent: 0.804, ev: 91.3, g: 1535, h: 1660, hr: 384, hardHitPercent: 0.46, iso: 0.282, kPercent: 0.223, obp: 0.409, ops: 0.989, r: 1132, rbi: 968, sb: 214, slg: 0.58, swingPercent: 0.39, war: 85.8, wpa: 52.25, zSwingPercent: 0.597, maxEv: 118, woba: 0.414, wrcPlus: 169, wsb: 21.2)]))
}
