//
//  AccountPageView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/8/25.
//

import SwiftUI

struct AccountPageView: View {
    var savedUser: SavedUser
    
    var body: some View {
        ZStack {
            VStack {                
                Section {
                    VStack {
                        if let profilePictureURL = savedUser.user.profilePicture, let url = URL(string: profilePictureURL) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .scaledToFill()
                                    .frame(width: 175, height: 175)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(Color.parkFactorPrimary, lineWidth: 3)
                                    )
                            } placeholder: {
                                ProgressView()
                            }
                        } else {
                            Image("ParkFactorLogo")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 175, height: 175)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.parkFactorPrimary, lineWidth: 3)
                                )
                        }
                    }
                }
                .padding(.top, 30)
            }
        }
    }
}

#Preview {
    AccountPageView(savedUser: SavedUser())
}
