//
//  LeagueNewsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/8/25.
//

import SwiftUI

struct LeagueNewsView: View {
    @State private var filterText: String = "All"
    @State private var resultMessage: String = ""
    @State private var resultShow: Bool = false
    
    @State private var newsArticles: [NewsArticle] = []
    
    // TODO: Implement addition of favorite team and following teams
    // TODO: Implement a caching system to prevent unnecessary calls to the backend
    var savedUser: SavedUser
    
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            ScrollView {
                HStack {
                    if filterText != "All" {
                        Text("\(filterText) News")
                            .font(.parkFactorFontSubtitleNorwester)
                            .foregroundColor(.parkFactorPrimary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .padding(.horizontal, 10)
                    } else {
                        Text("Around the League")
                            .font(.parkFactorFontSubtitleNorwester)
                            .foregroundColor(.parkFactorPrimary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .padding(.horizontal, 10)
                    }
                    Text("\(resultMessage)")
                        .font(.parkFactorFontText)
                        .foregroundStyle(resultShow ? Color.red : Color.parkFactorPrimary)
                        .multilineTextAlignment(.center)
                        .opacity(resultShow ? 1 : 0)
                    Spacer()
                    NavigationLink(destination: FilterNewsView(filterText: $filterText)) {
                        HStack {
                            Image(systemName: "line.horizontal.3.decrease.circle")
                                .foregroundColor(.parkFactorPrimary)
                                .font(.system(size: 20))
                            Text("Filter")
                                .font(.parkFactorFontTextNorwester)
                                .foregroundColor(.parkFactorPrimary)
                        }
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 10)
                }
                LazyVStack(spacing: 0) {
                    ForEach(newsArticles) { newsArticle in
                        NavigationLink(destination: NewsArticleDetailedPageView(newsArticle: newsArticle)) {
                            NewsArticleCardView(newsArticle: newsArticle)
                        }
                        .buttonStyle(.plain)
                        Rectangle()
                            .fill(Color.parkFactorPrimary)
                            .frame(height: 2)
                            .padding(.vertical, 10)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await retrieveNewsArticles()
            }
        }
    }
    
    private func retrieveNewsArticles() async {
        let baseUrl = Env.expressBaseURL
        var request: URLRequest
        if filterText == "All" {
            guard let url = URL(string: "\(baseUrl)/news/") else {
                // Consider fatalError here if server is not active
                DispatchQueue.main.async {
                    resultMessage = "Incorrect URL"
                    resultShow = true
                }
                return
            }
            request = URLRequest(url: url)
        } else {
            let percentEncodedTeamName = filterText.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
            guard let url = URL(string: "\(baseUrl)/news/\(percentEncodedTeamName ?? "")") else {
                // Consider fatalError here if server is not active
                DispatchQueue.main.async {
                    resultMessage = "Incorrect URL"
                    resultShow = true
                }
                return
            }
            request = URLRequest(url: url)
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
                let decodedNewsArticles = try JSONDecoder().decode([NewsArticle].self, from: data)
                DispatchQueue.main.async {
                    newsArticles = decodedNewsArticles
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
   LeagueNewsView(savedUser: SavedUser())
}
