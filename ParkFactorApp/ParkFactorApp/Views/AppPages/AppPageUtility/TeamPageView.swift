//
//  TeamPageView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/27/25.
//

import SwiftUI

struct TeamPageView: View {
    var teamAbbr: String
    var body: some View {
        Text(teamAbbr)
    }
}

#Preview {
    TeamPageView(teamAbbr: "LAA")
}
