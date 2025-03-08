//
//  LoginView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/1/25.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @AppStorage("accessToken") private var accessToken: String?
    @State private var userLoginFields = UserLoginFields()
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    @FocusState private var focus: FocusedField?
    
    var savedUser: SavedUser
    
    // enum to focus on username or password
    enum FocusedField {
        case username, password
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.parkFactorSecondary.ignoresSafeArea()
                VStack {
                    Section {
                        Text("Welcome to Park Factor")
                            .font(.parkFactorFontTitle)
                            .foregroundStyle(Color.white)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        Image("ParkFactorLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    }
                    
                    Section {
                        Text("\(errorMessage)")
                            .font(.parkFactorFontText)
                            .foregroundStyle(Color.red)
                            .multilineTextAlignment(.center)
                            .opacity(errorShow ? 1 : 0)
                        
                        VStack {
                            VStack(alignment: .leading) {
                                Text("Username")
                                    .foregroundColor(focus == .username ? Color.parkFactorPrimary : Color.white)
                                    .font(.parkFactorFontSubtitleArchivo)
                                    .opacity(focus == .username ? 1 : 0.6)
                                TextField("", text: $userLoginFields.username)
                                    .keyboardType(.default)
                                    .padding()
                                    .background(Color.parkFactorSecondary)
                                    .foregroundColor(focus == .username ? Color.parkFactorPrimary : Color.white)
                                    .font(.parkFactorFontText)
                                    .border(focus == .username ? Color.parkFactorPrimary : Color.white, width: 2)
                                    .cornerRadius(5)
                                    .frame(height: 35)
                                    .padding(.bottom)
                                    .textInputAutocapitalization(.never)
                                    .focused($focus, equals: .username)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Password")
                                    .foregroundColor(focus == .password ? Color.parkFactorPrimary : Color.white)
                                    .font(.parkFactorFontSubtitleArchivo)
                                    .opacity(focus == .password ? 1 : 0.6)
                                SecureField("", text: $userLoginFields.password)
                                    .keyboardType(.default)
                                    .padding()
                                    .background(Color.parkFactorSecondary)
                                    .foregroundColor(focus == .password ? Color.parkFactorPrimary : Color.white)
                                    .font(.parkFactorFontText)
                                    .border(focus == .password ? Color.parkFactorPrimary : Color.white, width: 2)
                                    .cornerRadius(5)
                                    .frame(height: 35)
                                    .padding(.bottom)
                                    .textInputAutocapitalization(.never)
                                    .focused($focus, equals: .password)
                            }
                            .padding(.top, 20)
                        }
                        .onSubmit {
                            if focus == .username {
                                focus = .password
                            } else {
                                focus = nil
                            }
                        }
                        
                        Button(action: {
                            Task {
                                await login()
                            }
                        }) {
                            Text("Login")
                                .font(.parkFactorFontSubtitleArchivo)
                                .foregroundColor(isFormValid ? Color.parkFactorSecondary : .gray)
                                .containerRelativeFrame(.horizontal) { size, axis in
                                    size * 0.4
                                }
                                .padding()
                                .background(isFormValid ? Color.parkFactorPrimary : Color.clear)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                        }
                        .disabled(!isFormValid)
                        .padding(.top, 30)
                    }
                    .containerRelativeFrame(.horizontal) { size, axis in
                        size * 0.8
                    }
                    
                    Section {
                        HStack {
                            Text("Don't have an account?")
                                .foregroundStyle(Color.white)
                            NavigationLink(destination: SignupView(isLoggedIn: $isLoggedIn, savedUser: savedUser)) {
                                Text("Sign up")
                                    .foregroundColor(Color.parkFactorPrimary)
                            }
                        }
                        .font(.parkFactorFontSmallText)
                    }
                    .padding(.top, 30)
                }
            }
            .navigationTitle("Login")
            .navigationBarHidden(true)
        }
    }
    
    var isFormValid: Bool {
        !userLoginFields.username.isEmpty && !userLoginFields.password.isEmpty
    }
    
    func login() async {
        // Network request to login a user
        let baseUrl = Env.expressBaseURL
        guard let encoded = try? JSONEncoder().encode(userLoginFields) else {
            print("Failed to encode userLoginFields")
            return
        }
        
        //create the url
        let url = URL(string: "\(baseUrl)/users/login")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, res) = try await URLSession.shared.upload(for: request, from: encoded)
            
            // handle the result
            if let httpResponse = res as? HTTPURLResponse {
                // If the result of the http response is a 400 then the message of what went wrong will be returned and placed in errorMessage
                if httpResponse.statusCode != 200 {
                    let decodedNodeError = try JSONDecoder().decode(NodeError.self, from: data)
                    errorMessage = decodedNodeError.message
                    errorShow = true
                    return
                }
            }
            
            // If the result of the http response goes through successfully, decode the response to a codable UserResponse
            let decodedUserLoginResponse = try JSONDecoder().decode(UserLoginResponse.self, from: data)
            savedUser.user = decodedUserLoginResponse.user
            let token = decodedUserLoginResponse.token
            accessToken = token
            isLoggedIn = true
        } catch {
            errorMessage = error.localizedDescription
            errorShow = true
        }
    }
}

#Preview {
    LoginViewPreviewWrapper()
}

struct LoginViewPreviewWrapper: View {
    @State private var isLoggedIn = false
    
    var body: some View {
        LoginView(isLoggedIn: $isLoggedIn, savedUser: SavedUser())
    }
}
