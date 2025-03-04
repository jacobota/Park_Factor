//
//  SignupView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/1/25.
//

import SwiftUI

struct SignupView: View {
    @Binding var isLoggedIn: Bool
    @AppStorage("accessToken") private var accessToken: String?
    @State private var userLoginFields = UserLoginFields()
    @State private var userSignupFields = UserSignupFields()
    @State private var errorMessage: String = ""
    @State private var errorShow: Bool = false
    @State private var confirmPassword: String = ""
    @State private var isRegistered: Bool = false
    @FocusState private var focus: FocusedField?
    
    var savedUser: SavedUser
    
    // enum to focus on username or password
    enum FocusedField {
        case username, email, password, confirmPassword
    }
    
    var body: some View {
        if isRegistered {
            FavoriteTeamsView(isLoggedIn: $isLoggedIn, savedUser: savedUser)
                .navigationBarBackButtonHidden(true)
                .transition(.opacity)
                .animation(.linear(duration: 1), value: isRegistered)
        } else {
            ZStack {
                Color.parkFactorSecondary.ignoresSafeArea()
                VStack {
                    Section {
                        Text("Sign up to Park Factor")
                            .font(.parkFactorFontTitle)
                            .foregroundStyle(Color.white)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    .padding(.bottom, 20)
                    
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
                                    .font(.parkFactorFontSubtitle)
                                    .opacity(focus == .username ? 1 : 0.6)
                                TextField("", text: $userSignupFields.username)
                                    .keyboardType(.default)
                                    .padding()
                                    .background(Color.black)
                                    .foregroundColor(focus == .username ? Color.parkFactorPrimary : Color.white)
                                    .font(.parkFactorFontText)
                                    .border(focus == .username ? Color.parkFactorPrimary : Color.white, width: 2)
                                    .cornerRadius(5)
                                    .frame(height: 35)
                                    .padding(.bottom)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .focused($focus, equals: .username)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Email")
                                    .foregroundColor(focus == .email ? Color.parkFactorPrimary : Color.white)
                                    .font(.parkFactorFontSubtitle)
                                    .opacity(focus == .email ? 1 : 0.6)
                                TextField("", text: $userSignupFields.email)
                                    .keyboardType(.default)
                                    .padding()
                                    .background(Color.black)
                                    .foregroundColor(focus == .email ? Color.parkFactorPrimary : Color.white)
                                    .font(.parkFactorFontText)
                                    .border(focus == .email ? Color.parkFactorPrimary : Color.white, width: 2)
                                    .cornerRadius(5)
                                    .frame(height: 35)
                                    .padding(.bottom)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .focused($focus, equals: .email)
                            }
                            .padding(.top, 10)
                            
                            VStack(alignment: .leading) {
                                Text("Password")
                                    .foregroundColor(focus == .password ? Color.parkFactorPrimary : Color.white)
                                    .font(.parkFactorFontSubtitle)
                                    .opacity(focus == .password ? 1 : 0.6)
                                SecureField("", text: $userSignupFields.password)
                                    .keyboardType(.default)
                                    .padding()
                                    .background(Color.black)
                                    .foregroundColor(focus == .password ? Color.parkFactorPrimary : Color.white)
                                    .font(.parkFactorFontText)
                                    .border(focus == .password ? Color.parkFactorPrimary : Color.white, width: 2)
                                    .cornerRadius(5)
                                    .frame(height: 35)
                                    .padding(.bottom)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .focused($focus, equals: .password)
                            }
                            .padding(.top, 10)
                            
                            VStack(alignment: .leading) {
                                Text("Confirm Password")
                                    .foregroundColor(focus == .confirmPassword ? Color.parkFactorPrimary : Color.white)
                                    .font(.parkFactorFontSubtitle)
                                    .opacity(focus == .confirmPassword ? 1 : 0.6)
                                SecureField("", text: $confirmPassword)
                                    .keyboardType(.default)
                                    .padding()
                                    .background(Color.black)
                                    .foregroundColor(focus == .confirmPassword ? Color.parkFactorPrimary : Color.white)
                                    .font(.parkFactorFontText)
                                    .border(focus == .confirmPassword ? Color.parkFactorPrimary : Color.white, width: 2)
                                    .cornerRadius(5)
                                    .frame(height: 35)
                                    .padding(.bottom)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .focused($focus, equals: .confirmPassword)
                            }
                            .padding(.top, 10)
                        }
                        .onSubmit {
                            if focus == .username {
                                focus = .email
                            } else if focus == .email {
                                focus = .password
                            } else if focus == .password {
                                focus = .confirmPassword
                            } else {
                                focus = nil
                            }
                        }
                        
                        Button(action: {
                            Task {
                                await register()
                            }
                        }) {
                            Text("Sign up")
                                .font(.parkFactorFontSubtitle)
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
                }
            }
        }
    }
    
    var isFormValid: Bool {
        return fieldsFilled() && passwordsMatch()
    }
    
    func fieldsFilled() -> Bool {
        !userSignupFields.username.isEmpty && !userSignupFields.email.isEmpty && !userSignupFields.password.isEmpty && !confirmPassword.isEmpty
    }
    
    func passwordsMatch() -> Bool {
        return userSignupFields.password == confirmPassword
    }
    
    func register() async {
        // Network request to register a user
        let baseUrl = Env.expressBaseURL
        guard let encoded = try? JSONEncoder().encode(userSignupFields) else {
            print("Failed to encode userLoginFields")
            return
        }
        
        //create the url
        let url = URL(string: "\(baseUrl)/users/registration")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, res) = try await URLSession.shared.upload(for: request, from: encoded)
            
            // handle the result
            if let httpResponse = res as? HTTPURLResponse {
                // If the result of the http response is a 400 then the message of what went wrong will be returned and placed in errorMessage
                if httpResponse.statusCode != 201 {
                    let decodedNodeError = try JSONDecoder().decode(NodeError.self, from: data)
                    errorMessage = decodedNodeError.message
                    errorShow = true
                    return
                }
            }
            
            // If the result of the http response goes through successfully, decode the response to a codable UserRegisterResponse
            let decodedUserRegisterResponse = try JSONDecoder().decode(UserRegisterResponse.self, from: data)
           
            userLoginFields.username = decodedUserRegisterResponse.user.username
            userLoginFields.password = confirmPassword
            
            // Now login the user so they have permissions to add favorite teams and players
            guard let encoded = try? JSONEncoder().encode(userLoginFields) else {
                print("Failed to encode userLoginFields")
                return
            }
            
            //create the url
            let loginUrl = URL(string: "\(baseUrl)/users/login")!
            request = URLRequest(url: loginUrl)
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
                isRegistered = true
            } catch {
                errorMessage = error.localizedDescription
                errorShow = true
            }
        } catch {
            errorMessage = error.localizedDescription
            errorShow = true
        }
    }
}

#Preview {
    SignupViewPreviewWrapper()
}

struct SignupViewPreviewWrapper: View {
    @State private var isLoggedIn = false
    
    var body: some View {
        SignupView(isLoggedIn: $isLoggedIn, savedUser: SavedUser())
    }
}

