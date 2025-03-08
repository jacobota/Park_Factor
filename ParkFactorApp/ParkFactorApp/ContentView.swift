//
//  ContentView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 2/28/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("accessToken") private var accessToken: String?
    @State private var savedUser = SavedUser()
    @State private var isLoading = true
    @State private var isLoggedIn = false
    
    var body: some View {
        ZStack {
            Color.parkFactorSecondary.ignoresSafeArea()
            if isLoading {
                LoadingScreenView()
                    .onAppear {
                        checkLoginStatus()
                    }
            } else {
                if !isLoggedIn {
                    LoginView(isLoggedIn: $isLoggedIn, savedUser: savedUser)
                } else {
                    TabBarView(isLoggedIn: $isLoggedIn, savedUser: savedUser)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
    
    private func checkLoginStatus() {
        // Checks if the value in accessToken is not nil with a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // check if there is a token available to use
            guard accessToken != nil else {
                DispatchQueue.main.async {
                    isLoggedIn = false
                    isLoading = false
                }
                return
            }
            
            // call the network request to retrieve user
            let baseUrl = Env.expressBaseURL
            guard let url = URL(string: "\(baseUrl)/users/profile") else {
                // Consider fatalError here if server is not active
                DispatchQueue.main.async {
                    isLoggedIn = false
                    isLoading = false
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
                        accessToken = nil
                        isLoggedIn = false
                        isLoading = false
                    }
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        accessToken = nil
                        isLoggedIn = false
                        isLoading = false
                    }
                    return
                }
                
                if response.statusCode != 200 {
                    DispatchQueue.main.async {
                        accessToken = nil
                        isLoggedIn = false
                        isLoading = false
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        accessToken = nil
                        isLoggedIn = false
                        isLoading = false
                    }
                    return
                }
                
                do {
                    let decodedUser = try JSONDecoder().decode(User.self, from: data)
                    DispatchQueue.main.async {
                        savedUser.user = decodedUser
                        isLoggedIn = true
                        isLoading = false
                    }
                } catch _ {
                    DispatchQueue.main.async {
                        accessToken = nil
                        isLoggedIn = false
                        isLoading = false
                    }
                    return
                }
            }
            
            dataTask.resume()
        }
    }
}

#Preview {
    ContentView()
}
