//
//  AccountFromPostView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/20/25.
//

import SwiftUI

struct AccountFromPostView: View {
    @AppStorage("accessToken") private var accessToken: String?
    @State private var resultMessage: String = ""
    @State private var resultShow: Bool = false
    @State private var successShow: Bool = false
    
    var author: String
    @State var userAccount: User
    var savedUser: SavedUser
    
    var body: some View {
        ZStack {
            Color.parkFactorSecondary.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Text("\(userAccount.username)'s Profile")
                        .font(.parkFactorFontBigTextNorwester)
                        .foregroundColor(.parkFactorPrimary)
                        .padding(.bottom)
                    Spacer()
                }
                .background(Color.black)
                
                ZStack {
                    Color.parkFactorAppPageBackground.ignoresSafeArea()
                    ScrollView {
                        VStack {
                            Text("\(resultMessage)")
                                .font(.parkFactorFontText)
                                .foregroundStyle(resultShow ? Color.red : Color.parkFactorPrimary)
                                .multilineTextAlignment(.center)
                                .opacity(resultShow ? 1 : 0)
                            // Account Overview: username, tag, profile pic, fav team and player
                            Section {
                                VStack {
                                    HStack {
                                        if let profilePictureURL = userAccount.profilePicture, let url = URL(string: profilePictureURL) {
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
                                                Text("\(userAccount.username)")
                                                    .font(.parkFactorFontUsernameNorwester)
                                                    .foregroundStyle(Color.white)
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.5)
                                                if userAccount.verified {
                                                    Image(systemName: "checkmark.diamond.fill")
                                                        .foregroundStyle(Color.parkFactorPrimary)
                                                        .opacity(1)
                                                        .font(.system(size: 18))
                                                        .padding(.horizontal, 5)
                                                }
                                            }
                                            .padding(.top, 10)
                                            
                                            Spacer()
                                            
                                            Text("\(userAccount.userTag)")
                                                .font(.parkFactorFontSmallTextNorwester)
                                                .foregroundStyle(Color.white)
                                                .opacity(0.5)
                                            
                                            Spacer()
                                        }
                                        .padding(.horizontal, 10)
                                        Spacer()
                                    }
                                    .padding(.bottom, 20)
                                    
                                    Rectangle()
                                        .fill(Color.white.opacity(0.9))
                                        .frame(height: 2)
                                        .padding(.vertical, 10)
                                    
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Text("Favorite Team")
                                                .font(.parkFactorFontSmallTextNorwester)
                                                .foregroundStyle(Color.white)
                                                .opacity(0.5)
                                            
                                            if let favoriteTeam = userAccount.favoriteTeam {
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
                                            
                                            if let favoritePlayer = userAccount.favoritePlayer {
                                                AsyncImage(url: URL(string: "https://img.mlbstatic.com/mlb-photos/image/upload/w_180,d_people:generic:headshot:silo:current.png,q_auto:best,f_auto/v1/people/\(favoritePlayer.keyMlbam ?? 1)/headshot/silo/current"), scale: 3) { image in
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
                                    }
                                    
                                    Rectangle()
                                        .fill(Color.white.opacity(0.9))
                                        .frame(height: 2)
                                        .padding(.vertical, 10)
                                    
                                    
                                    if userAccount.userBiography.isEmpty {
                                        Text("N/A")
                                            .font(.parkFactorFontTextNorwester)
                                            .foregroundStyle(Color.white)
                                            .padding(.top, 20)
                                    } else {
                                        Text(userAccount.userBiography)
                                            .font(.parkFactorFontSmallText)
                                            .foregroundStyle(Color.white)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.top, 10)
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
                                VStack {
                                    Text("Posts")
                                        .font(Font.parkFactorFontTextNorwester)
                                        .foregroundColor(Color.white)
                                        .padding()
                                        .cornerRadius(10)
                                    
                                    Rectangle()
                                        .fill(Color.white.opacity(0.9))
                                        .frame(height: 2)
                                        .padding(.vertical, 10)
                                    
                                    OtherAccountPostsView(savedUser: savedUser, user: author)
                                }
                                .padding(20)
                                .background(Color.parkFactorSecondary)
                                .cornerRadius(20)
                            }
                            .padding()
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom)
            .padding(.top, 10)
        }
        .onAppear {
            Task {
                await getUserAccountInformation()
            }
        }
    }
    
    private func getUserAccountInformation() async {
        // call the network request to retrieve user
        let baseUrl = Env.expressBaseURL
        guard let url = URL(string: "\(baseUrl)/users/profile/\(author)") else {
            // Consider fatalError here if server is not active
            DispatchQueue.main.async {
                resultMessage = "Error fetching data"
                resultShow = true
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    resultMessage = "Error fetching data"
                    resultShow = true
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    resultMessage = "Error fetching data"
                    resultShow = true
                }
                return
            }
            
            if response.statusCode != 200 {
                DispatchQueue.main.async {
                    resultMessage = "Error fetching data"
                    resultShow = true
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    resultMessage = "Error fetching data"
                    resultShow = true
                }
                return
            }
            
            do {
                let decodedUser = try JSONDecoder().decode(User.self, from: data)
                DispatchQueue.main.async {
                    userAccount = decodedUser
                }
            } catch {
                resultMessage = "Error fetching data"
                resultShow = true
                return
            }
        }
        
        dataTask.resume()
    }
}

#Preview {
    AccountFromPostView(author: "jacobota", userAccount: User(username: "", admin: false, email: "", favoritePlayer: nil, favoriteTeam: nil, followingPlayers: [], followingTeams: [], password: "", profilePicture: "", userBiography: "", userLikedPosts: [], userTag: "", verified: false), savedUser: SavedUser())
}
