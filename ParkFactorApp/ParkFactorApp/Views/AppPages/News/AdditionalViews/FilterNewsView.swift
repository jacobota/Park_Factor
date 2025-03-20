//
//  FilterNewsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/19/25.
//

import SwiftUI

struct FilterNewsView: View {
    @Binding var filterText: String
    let allMlbTeams = [
            "Angels", "Astros", "Athletics", "Blue Jays", "Braves", "Brewers", "Cardinals", "Cubs", "Diamondbacks", "Dodgers",
            "Giants", "Guardians", "Mariners", "Marlins", "Mets", "Nationals", "Orioles", "Padres", "Phillies", "Pirates",
            "Rangers", "Rays", "Red Sox", "Reds", "Rockies", "Royals", "Tigers", "Twins", "White Sox", "Yankees"
        ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            List {
                ForEach(allMlbTeams, id: \.self) { team in
                    Button(action: {
                        if filterText == team {
                            filterText = "All"
                        } else {
                            filterText = team
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text(team)
                                .font(.parkFactorFontBigTextNorwester)
                                .padding()
                                .background(filterText == team ? Color.parkFactorPrimary : Color.parkFactorSecondary)
                                .foregroundColor(filterText == team ? .parkFactorSecondary : Color.parkFactorPrimary)
                                .cornerRadius(10)
                            Spacer()
                        }
                    }
                    .listRowBackground(
                        Capsule()
                            .stroke(Color.parkFactorPrimary, lineWidth: 4)
                            .fill(filterText == team ? Color.parkFactorPrimary : Color.parkFactorSecondary)
                            .padding(20)
                    )
                }
                .padding(10)
                .listRowSeparator(.hidden)
            }
            .environment(\.defaultMinListRowHeight, 60)
            .listStyle(GroupedListStyle())
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .containerRelativeFrame(.horizontal) { size, axis in
                size * 0.9
            }
        }
    }
}

#Preview {
    FilterNewsViewPreviewWrapper()
}

struct FilterNewsViewPreviewWrapper: View {
    @State private var filterText = "All"
    
    var body: some View {
        FilterNewsView(filterText: $filterText)
    }
}
