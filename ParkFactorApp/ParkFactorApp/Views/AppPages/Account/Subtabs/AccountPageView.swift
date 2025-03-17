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
        ScrollView {
            VStack {
                Section {
                    VStack {
                        Text("Profile Overview")
                                .font(.parkFactorFontSubtitleNorwester)
                                .foregroundStyle(Color.parkFactorPrimary)
                                .padding(.bottom, 15)
                        HStack {
                            if let profilePictureURL = savedUser.user.profilePicture, let url = URL(string: profilePictureURL) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
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
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(Color.parkFactorPrimary, lineWidth: 3)
                                    )
                            }
                            VStack(alignment: .leading) {
                                Text("\(savedUser.user.username)")
                                    .font(.parkFactorFontUsername)
                                    .foregroundStyle(Color.white)
                                    .padding(.top, 10)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                
                                Spacer()
                                
                                Text("\(savedUser.user.userTag)")
                                    .font(.parkFactorFontTextNorwester)
                                    .foregroundStyle(Color.white)
                                    .opacity(0.5)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 10)
                        }
                        .padding(.bottom, 20)
                        Divider()
                            .background(Color.white.opacity(0.9))
                        HStack {
                            Spacer()
                            VStack {
                                Text("Favorite Team")
                                    .font(.parkFactorFontTextNorwester)
                                    .foregroundStyle(Color.white)
                                    .opacity(0.5)
                            }
                            Spacer()
                            VStack {
                                Text("Favorite Player")
                                    .font(.parkFactorFontTextNorwester)
                                    .foregroundStyle(Color.white)
                                    .opacity(0.5)
                                if let favoritePlayer = savedUser.user.favoritePlayer {
                                    AsyncImage(url: URL(string: "https://img.mlbstatic.com/mlb-photos/image/upload/w_180,d_people:generic:headshot:silo:current.png,q_auto:best,f_auto/v1/people/\(favoritePlayer.keyMlbam)/headshot/silo/current"), scale: 3) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 75, height: 75)
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle().stroke(Color.parkFactorPrimary, lineWidth: 3)
                                            )
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 75, height: 75)
                                    .padding(.top)
                                    
                                    Text("\(favoritePlayer.fullName)")
                                        .font(.parkFactorFontTextNorwester)
                                        .foregroundStyle(Color.white)
                                        .opacity(0.8)
                                        .padding(.top)
                                } else {
                                    Text("N/A")
                                        .font(.parkFactorFontTextNorwester)
                                        .foregroundStyle(Color.white)
                                        .opacity(0.8)
                                }
                            }
                            Spacer()
                        }
                        .padding(.top)
                    }
                    .padding(30)
                    .background(Color.parkFactorSecondary)
                    .cornerRadius(20)
                }
                .padding()
                Section {
                    Text("Hello")
                }
                .padding(.top, 30)
            }
        }
    }
}

#Preview {
    AccountPageView(savedUser: SavedUser())
}
