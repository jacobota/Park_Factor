//
//  StatExplanationView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/21/25.
//

import SwiftUI

struct StatExplanationView: View {
    let stat: String
    @State private var statCategory: [String: StatCategory] = Bundle.main.decode("statcategory.json")
    
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            VStack {
                if let stat = statCategory[stat] {
                    ScrollView {
                        VStack {
                            HStack {
                                Text(stat.name)
                                    .foregroundStyle(Color.white)
                                    .font(.parkFactorFontSubtitleNorwester)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.bottom, 30)
                            
                            VStack {
                                HStack {
                                    Text("Description:")
                                        .foregroundStyle(Color.white)
                                        .font(.parkFactorFontSubtitleNorwester)
                                    Spacer()
                                }
                                .padding(.bottom, 5)
                                HStack {
                                    Text(stat.description)
                                        .foregroundStyle(Color.white)
                                        .font(.parkFactorFontBigTextArchivo)
                                    Spacer()
                                }
                            }
                            .padding(.bottom, 20)
                            
                            VStack {
                                HStack {
                                    Text("Importance:")
                                        .foregroundStyle(Color.white)
                                        .font(.parkFactorFontSubtitleNorwester)
                                    Spacer()
                                }
                                .padding(.bottom, 5)
                                HStack {
                                    Text(stat.why)
                                        .foregroundStyle(Color.white)
                                        .font(.parkFactorFontBigTextArchivo)
                                    Spacer()
                                }
                            }
                            .padding(.bottom, 20)
                            
                            VStack {
                                HStack {
                                    Text("Formula:")
                                        .foregroundStyle(Color.white)
                                        .font(.parkFactorFontSubtitleNorwester)
                                    Spacer()
                                }
                                .padding(.bottom, 5)
                                HStack {
                                    Text(stat.formula)
                                        .foregroundStyle(Color.white)
                                        .font(.parkFactorFontBigTextArchivo)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding(20)
                } else {
                    Text("Unable to find Stat")
                        .foregroundStyle(Color.white)
                        .font(.parkFactorFontSubtitleNorwester)
                }
            }
        }
    }
}

#Preview {
    StatExplanationView(stat: "hitter_sb")
}
