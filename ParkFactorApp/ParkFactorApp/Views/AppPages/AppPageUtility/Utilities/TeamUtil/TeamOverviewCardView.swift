//
//  TeamOverviewCardView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/23/25.
//

import SwiftUI

struct TeamOverviewCardView: View {
    let gameDetails: GameDetails
    
    var body: some View {
        VStack {
            VStack {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 5) {
                    // First Row with stat category
                    Text("Record")
                        .foregroundColor(Color.gray)
                    Text("GB")
                        .foregroundColor(Color.gray)
                    Text("Streak")
                        .foregroundColor(Color.gray)
                    
                    Text(gameDetails.record ?? "N/A")
                    Text(gameDetails.gb ?? "N/A")
                    Text(getStreakInStringFormat(gameDetails.streak ?? 0))
                }
                .font(.parkFactorFontText)
                .foregroundColor(.white)
                .padding(20)
            }
            .background(Color.black)
            .cornerRadius(10)
            .padding(.bottom, 10)
        }
    }
    
    private func getStreakInStringFormat(_ streak: Int) -> String {
        if streak >= 0 {
            return "\(streak) W"
        } else {
            return "\(abs(streak)) L"
        }
    }
}

#Preview {
    TeamOverviewCardView(gameDetails: GameDetails(attendance: 39393, dayOrNight: "D", date: "Mar 27", gb: "1.0", homeAway: "Home", inn: 10, loss: "Long", opp: "CLE", origScheduled: nil, r: 4, ra: 7, rank: 3, save: "Sewald", streak: -1, time: "2:41", tm: "KCR", record: "0-1", wl: "L", win: "Clase", cli: "1.02"))
}
