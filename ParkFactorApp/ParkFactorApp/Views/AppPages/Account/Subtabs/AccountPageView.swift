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
                        HStack {
                            if let profilePictureURL = savedUser.user.profilePicture, let url = URL(string: profilePictureURL) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                        .scaledToFill()
                                        .frame(width: 110, height: 110)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle().stroke(Color.parkFactorPrimary, lineWidth: 2)
                                        )
                                } placeholder: {
                                    ProgressView()
                                }
                            } else {
                                Image("ParkFactorLogo")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 110, height: 110)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(Color.parkFactorPrimary, lineWidth: 2)
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
                            Spacer()
                        }
                        .padding(.bottom, 20)
                        Divider()
                            .background(Color.white.opacity(0.9))
                        HStack {
                            Spacer()
                            VStack {
                                Text("Favorite Team")
                                    .font(.parkFactorFontSmallTextNorwester)
                                    .foregroundStyle(Color.white)
                                    .opacity(0.5)
                                
                                if let favoriteTeam = savedUser.user.favoriteTeam {
                                    AsyncImage(url: URL(string: "https://cdn.ssref.net/req/202502211/tlogo/br/\(favoriteTeam.franchID).png"), scale: 3) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle().stroke(Color.parkFactorPrimary, lineWidth: 3)
                                            )
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 50, height: 50)
                                    .padding(.top, 5)
                                    
                                    Text("\(favoriteTeam.teamMascot)")
                                        .font(.parkFactorFontSmallTextNorwester)
                                        .foregroundStyle(Color.white)
                                        .opacity(0.8)
                                        .padding(.top, 5)
                                } else {
                                    Image("mlbLogo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .background(Color.black)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle().stroke(Color.parkFactorPrimary, lineWidth: 3)
                                        )
                                        .padding(.top, 5)
                                    
                                    Text("N/A")
                                        .font(.parkFactorFontSmallTextNorwester)
                                        .foregroundStyle(Color.white)
                                        .opacity(0.8)
                                        .padding(.top, 5)
                                }
                            }
                            Spacer()
                            VStack {
                                Text("Favorite Player")
                                    .font(.parkFactorFontSmallTextNorwester)
                                    .foregroundStyle(Color.white)
                                    .opacity(0.5)
                                
                                if let favoritePlayer = savedUser.user.favoritePlayer {
                                    AsyncImage(url: URL(string: "https://img.mlbstatic.com/mlb-photos/image/upload/w_180,d_people:generic:headshot:silo:current.png,q_auto:best,f_auto/v1/people/\(favoritePlayer.keyMlbam)/headshot/silo/current"), scale: 3) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle().stroke(Color.parkFactorPrimary, lineWidth: 3)
                                            )
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 50, height: 50)
                                    .padding(.top, 5)
                                    
                                    Text("\(favoritePlayer.fullName)")
                                        .font(.parkFactorFontSmallTextNorwester)
                                        .foregroundStyle(Color.white)
                                        .opacity(0.8)
                                        .padding(.top, 5)
                                } else {
                                    AsyncImage(url: URL(string: "https://img.mlbstatic.com/mlb-photos/image/upload/w_180,d_people:generic:headshot:silo:current.png,q_auto:best,f_auto/v1/people/headshot/silo/current"), scale: 3) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle().stroke(Color.parkFactorPrimary, lineWidth: 2)
                                            )
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 50, height: 50)
                                    .padding(.top, 5)
                                    
                                    Text("N/A")
                                        .font(.parkFactorFontSmallTextNorwester)
                                        .foregroundStyle(Color.white)
                                        .opacity(0.8)
                                        .padding(.top, 5)
                                }
                            }
                            Spacer()
                        }
                        .padding(.top)
                    }
                    .padding(20)
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
