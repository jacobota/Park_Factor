//
//  StatExplanationView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/21/25.
//

import SwiftUI

struct StatExplanationView: View {
    let stat: String
    // Decode the JSON in statcategory
    let statCategory = Bundle.main.decode("statcategory.json")
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            VStack {
                ScrollView {
                    VStack {
                        HStack {
                            Text(statCategory[stat]?.name ?? "N/A")
                                .foregroundStyle(Color.white)
                                .font(.parkFactorFontSubtitleNorwester)
                            Text(stat)
                                .foregroundStyle(Color.white)
                                .font(.parkFactorFontSubtitleNorwester)
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
                                Text(statCategory[stat]?.description ?? "N/A")
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
                                Text(statCategory[stat]?.why ?? "N/A")
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
                                Text(statCategory[stat]?.formula ?? "N/A")
                                    .foregroundStyle(Color.white)
                                    .font(.parkFactorFontBigTextArchivo)
                                Spacer()
                            }
                        }
                    }
                }
                .padding(20)
            }
        }
    }
}

#Preview {
    StatExplanationView(stat: "sb")
}
