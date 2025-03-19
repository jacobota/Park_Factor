//
//  AccountPageView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/8/25.
//

import SwiftUI

struct AccountPageView: View {
    @AppStorage("accessToken") private var accessToken: String?
    @State private var resultMessage: String = ""
    @State private var resultShow: Bool = false
    @State private var successShow: Bool = false
    @State private var isEditingBio = false
    @State private var userBio: String = ""
    
    var savedUser: SavedUser
    
    var body: some View {
        ScrollView {
            VStack {
                // Account Overview: username, tag, profile pic, fav team and player
                Section {
                    VStack {
                        HStack {
                            if let profilePictureURL = savedUser.user.profilePicture, let url = URL(string: profilePictureURL) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 75, height: 75)
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
                                    .frame(width: 75, height: 75)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(Color.parkFactorPrimary, lineWidth: 2)
                                    )
                            }
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("\(savedUser.user.username)")
                                        .font(.parkFactorFontUsernameNorwester)
                                        .foregroundStyle(Color.white)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                    if savedUser.user.verified {
                                        Image(systemName: "checkmark.diamond.fill")
                                            .foregroundStyle(Color.parkFactorPrimary)
                                            .opacity(1)
                                            .font(.system(size: 18))
                                            .padding(.horizontal, 5)
                                    }
                                }
                                .padding(.top, 10)
                                
                                Spacer()
                                
                                Text("\(savedUser.user.userTag)")
                                    .font(.parkFactorFontSmallTextNorwester)
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
                                                Circle().stroke(Color.parkFactorPrimary, lineWidth: 2)
                                            )
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .padding(.top, 5)
                                    
                                    Text("\(favoriteTeam.teamMascot)")
                                        .font(.parkFactorFontSmallTextNorwester)
                                        .foregroundStyle(Color.white)
                                        .opacity(0.8)
                                        .padding(.top, 5)
                                } else {
                                    Image("ParkFactorLogo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle().stroke(Color.parkFactorPrimary, lineWidth: 2)
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
                                                Circle().stroke(Color.parkFactorPrimary, lineWidth: 2)
                                            )
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .padding(.top, 5)
                                    
                                    Text("\(favoritePlayer.fullName)")
                                        .font(.parkFactorFontSmallTextNorwester)
                                        .foregroundStyle(Color.white)
                                        .opacity(0.8)
                                        .padding(.top, 5)
                                } else {
                                    AsyncImage(url: URL(string: "https://img.mlbstatic.com/mlb-photos/image/upload/w_180,d_people:generic:headshot:silo:current.png,q_auto:best,f_auto/v1/people/headshot/silo/current"), scale: 2) { image in
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
                .padding(.top)
                .padding(.horizontal)
                
                // User Biography
                Section {
                    VStack {
                        HStack {
                            Text("Bio")
                                .font(.parkFactorFontBigTextNorwester)
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                            
                            Button(action: {
                                isEditingBio.toggle()
                            }) {
                                Image(systemName: "pencil.circle")
                                    .foregroundStyle(isEditingBio ? Color.parkFactorPrimary : Color.white)
                                    .opacity(isEditingBio ? 1 : 0.8)
                                    .font(.system(size: 24))
                            }
                        }
                        
                        Divider()
                            .background(Color.white.opacity(0.9))
                        
                        if isEditingBio {
                            TextEditor(text: $userBio)
                                .font(.parkFactorFontText)
                                .foregroundColor(.black)
                                .padding()
                                .cornerRadius(8)
                                .frame(height: 150)
                                .padding(.top, 20)
                            
                            HStack {
                                Spacer()
                                Spacer()
                                Spacer()
                                Button(action: {
                                    Task {
                                        await updateUserBioFunc()
                                    }
                                }) {
                                    Text("Save")
                                        .padding()
                                        .background(Color.parkFactorPrimary)
                                        .foregroundColor(.parkFactorSecondary)
                                        .cornerRadius(8)
                                }
                                .padding(.top, 10)
                                
                                Spacer()
                                
                                Text("\(userBio.count)/255")
                                    .font(.parkFactorFontSmallTextNorwester)
                                    .foregroundStyle(Color.parkFactorPrimary)
                                    .padding(.horizontal, 20)
                            }
                            
                            Text("\(resultMessage)")
                                .font(.parkFactorFontSmallText)
                                .foregroundStyle(resultShow ? Color.red : Color.parkFactorPrimary)
                                .multilineTextAlignment(.center)
                                .opacity(resultShow || successShow ? 1 : 0)
                            
                        } else {
                            if userBio.isEmpty {
                                Text("N/A")
                                    .font(.parkFactorFontBigTextNorwester)
                                    .foregroundStyle(Color.white)
                                    .padding(.top, 20)
                            } else {
                                Text(savedUser.user.userBiography)
                                    .font(.parkFactorFontText)
                                    .foregroundStyle(Color.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 10)
                            }
                        }
                    }
                    .padding(20)
                    .background(Color.parkFactorSecondary)
                    .cornerRadius(20)
                }
                .padding(.top)
                .padding(.horizontal)
                
                // User Liked Posts / Verified User Posts
                Section {
                    Text("Hello")
                }
                .padding(.top, 30)
            }
        }
        .onAppear {
            setBiography()
        }
    }
    
    private func setBiography() {
        userBio = savedUser.user.userBiography
    }
    
    private func updateUserBioFunc() async {
        if userBio.count > 255 {
            resultMessage = "Bio exceeds Character limit"
            resultShow = true
            return
        }
        // call the network request to send an update to the user bio
        let baseUrl = Env.expressBaseURL
        var updateUserBio = UpdateUserBio()
        updateUserBio.userBiography = userBio
        guard let encoded = try? JSONEncoder().encode(updateUserBio) else {
            resultMessage = "Failed to encode bio"
            resultShow = true
            return
        }
        
        //create the url
        let url = URL(string: "\(baseUrl)/users/update/userBiography")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        
        do {
            let (data, res) = try await URLSession.shared.upload(for: request, from: encoded)
            
            // handle the result if bad
            if let httpResponse = res as? HTTPURLResponse {
                // If the result of the http response is a 400 then return
                if httpResponse.statusCode != 201 {
                    let decodedNodeError = try JSONDecoder().decode(NodeError.self, from: data)
                    resultMessage = decodedNodeError.message
                    resultShow = true
                    return
                }
                
                savedUser.user.userBiography = userBio
                isEditingBio = false
                resultShow = false
            }
        } catch {
            resultMessage = error.localizedDescription
            resultShow = true
        }
    }
}

#Preview {
    AccountPageView(savedUser: SavedUser())
}
