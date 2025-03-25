//
//  ConcourseView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/8/25.
//

import SwiftUI

struct ConcourseView: View {
    @AppStorage("accessToken") private var accessToken: String?
    @State private var resultMessage: String = ""
    @State private var resultShow: Bool = false
    @State var posts: [Post] = []
    
    var savedUser: SavedUser
    
    var body: some View {
        ZStack {
            ScrollView {
                Text("\(resultMessage)")
                    .font(.parkFactorFontText)
                    .foregroundStyle(resultShow ? Color.red : Color.parkFactorPrimary)
                    .multilineTextAlignment(.center)
                    .opacity(resultShow ? 1 : 0)
                LazyVStack(spacing: 0) {
                    ForEach(posts) { post in
                        let isSelected = savedUser.user.userLikedPosts.contains(where: { $0 == post.postId })
                        PostCardView(
                            isSelected: isSelected,
                            post: post,
                            savedUser: savedUser,
                            isNavOn: true,
                            onDelete: {
                                deletePost(post)
                            }
                        )
                        Rectangle()
                            .fill(Color.parkFactorPrimary)
                            .frame(height: 2)
                            .padding(.vertical, 5)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await retrievePosts()
            }
        }
    }
    
    private func deletePost(_ post: Post) {
        if let index = posts.firstIndex(where: { $0.postId == post.postId }) {
          posts.remove(at: index)
        }
    }
    
    private func retrievePosts() async {
        let baseUrl = Env.expressBaseURL
        guard let url = URL(string: "\(baseUrl)/verifiedPosts/") else {
            // Consider fatalError here if server is not active
            DispatchQueue.main.async {
                resultMessage = "Incorrect URL"
                resultShow = true
            }
            return
        }
        
        var request = URLRequest(url: url)        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken ?? "")", forHTTPHeaderField: "Authorization")
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
                let decodedPosts = try JSONDecoder().decode([Post].self, from: data)
                DispatchQueue.main.async {
                    posts = decodedPosts
                    resultShow = false
                }
            } catch {
                DispatchQueue.main.async {
                    resultMessage = error.localizedDescription
                    resultShow = true
                }
                return
            }
        }
        
        dataTask.resume()
    }
}

#Preview {
    ConcourseView(savedUser: SavedUser())
}
