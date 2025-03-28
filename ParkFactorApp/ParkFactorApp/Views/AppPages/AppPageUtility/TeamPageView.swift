//
//  TeamPageView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/27/25.
//

import SwiftUI

struct TeamPageView: View {
    var team: Team
    var body: some View {
        Text(team.teamMascot)
    }
}

#Preview {
    TeamPageView(team: Team(franchID: "ANA", lgID: "AL", teamID: "LAA", teamIDBR: "LAA", teamIDfg: 1, teamIDretro: "ANA", yearID: 2020))
}
