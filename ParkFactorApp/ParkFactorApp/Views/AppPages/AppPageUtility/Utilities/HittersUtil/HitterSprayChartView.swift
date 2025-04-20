//
//  HitterSprayChartView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/20/25.
//

import SwiftUI

struct HitterSprayChartView: View {
    var player: Player
    var teamAbbr: String
    
    var body: some View {
        VStack {
            HStack {
                Text("Spray Chart")
                    .font(.parkFactorFontSubtitleNorwester)
                    .foregroundStyle(Color.white)
                
                Spacer()
            }
            .padding(20)
            
            AsyncImage(url: URL(string: "\(Env.flaskBaseUrl)/hitters/api/hitter-stats/spraychart?mlbam-id=\(player.keyMlbam ?? 0)&team=\(teamAbbr)")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            } placeholder: {
                ProgressView()
            }
            .padding(.bottom, 30)
        }
        .background(Color.black)
        .cornerRadius(10)
    }
}

#Preview {
    HitterSprayChartView(player: Player(keyBbref: "troutmi01", keyFangraphs: 10155, keyMlbam: 592518, keyRetro: "troutm001", mlbPlayedFirst: 2011, mlbPlayedLast: 2024, nameFirst: "mike", nameLast: "trout"), teamAbbr: "SD")
}
