//
//  PostCardView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/20/25.
//

import SwiftUI

struct PostCardView: View {
    @AppStorage("accessToken") private var accessToken: String?
    @State var isSelected: Bool
    let post: Post
    var savedUser: SavedUser
    
    var body: some View {
        ZStack {
            Color.parkFactorSecondary.ignoresSafeArea()
                .cornerRadius(15)
                .shadow(radius: 5)
            VStack {
                VStack(alignment: .leading) {
                    NavigationLink(destination: AccountFromPostView(author: post.author ?? "", userAccount: savedUser.user)) {
                        HStack {
                            if !post.authorProfilePicture!.isEmpty {
                                AsyncImage(url: URL(string: post.authorProfilePicture!)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
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
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(Color.parkFactorPrimary, lineWidth: 2)
                                    )
                            }
                        }
                        VStack(alignment: .leading) {
                            HStack {
                                Text("\(post.author ?? "Anonymous")")
                                    .font(.parkFactorFontTextNorwester)
                                    .foregroundStyle(Color.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                Image(systemName: "checkmark.diamond.fill")
                                    .foregroundStyle(Color.parkFactorPrimary)
                                    .opacity(1)
                                    .font(.system(size: 14))
                                    .padding(.horizontal, 3)
                            }
                        }
                        Spacer()
                    }
                    Text(post.content!)
                        .font(.parkFactorFontSmallText)
                        .foregroundStyle(Color.white)
                        .padding(.top, 5)
                    if let url = URL(string: post.postImage!) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 150)
                                .cornerRadius(10)
                                .padding(.top, 5)
                        } placeholder: {
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: 200)
                        }
                    }
                }
                VStack(alignment: .trailing) {
                    HStack {
                        Spacer()
                        Button(action: {
                            Task {
                                await updateUsersLikedPosts()
                            }
                        }) {
                            Image(systemName: "hand.thumbsup.fill")
                                .foregroundStyle(isSelected ? Color.parkFactorPrimary : Color.white)
                                .opacity(1)
                                .font(.system(size: 20))
                        }
                    }
                }
                .padding(.top, 10)
            }
            .padding(20)
        }
        .padding(10)
    }
    
    private func updateUsersLikedPosts() async {
        var usersLikedPosts = savedUser.user.userLikedPosts
        if let index = usersLikedPosts.firstIndex(where: { $0 == post.postId }) {
            usersLikedPosts.remove(at: index)
        } else {
            usersLikedPosts.append(post.postId)
        }
        var updateUserLikedPosts = UpdateUserLikedPosts()
        updateUserLikedPosts.likedPosts = usersLikedPosts
        
        // call the network request to update user liked posts
        let baseUrl = Env.expressBaseURL
        guard let encoded = try? JSONEncoder().encode(updateUserLikedPosts) else {
            print("Failed to encode New Email")
            return
        }
        
        //create the url
        let url = URL(string: "\(baseUrl)/users/update/userLikedPosts")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        
        do {
            let (data, res) = try await URLSession.shared.upload(for: request, from: encoded)
            
            // handle the result if bad
            if let httpResponse = res as? HTTPURLResponse {
                // If the result of the http response is a 400 then the message of what went wrong will be returned and placed in errorMessage
                if httpResponse.statusCode != 201 {
                    let decodedNodeError = try JSONDecoder().decode(NodeError.self, from: data)
                    print(decodedNodeError.message)
                    return
                }
                savedUser.user.userLikedPosts = updateUserLikedPosts.likedPosts
                isSelected.toggle()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    PostCardView(isSelected: false, post: Post(
        postId: "4d97f234-418b-4f98-aeab-d7d990f3fc9d",
        author: "jacobota",
        authorProfilePicture: "https://parkfactor-profilepictures.s3.us-west-1.amazonaws.com/jacobota-profilepic.jpg",
        createdAt: "2025-03-21T03:21:58.782Z",
        content: "I am testing",
        postImage: ""), savedUser: SavedUser())
}
