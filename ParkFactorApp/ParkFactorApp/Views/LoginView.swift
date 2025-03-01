//
//  LoginView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/1/25.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @FocusState private var focus: FocusedField?
    
    enum FocusedField {
        case username, password
    }
    
    var body: some View {
        NavigationStack {
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
                        VStack {
                            VStack(alignment: .leading) {
                                Text("Username")
                                    .foregroundColor(focus == .username ? Color.parkFactorPrimary : Color.white)
                                    .font(.parkFactorFontSubtitle)
                                    .opacity(focus == .username ? 1 : 0.6)
                                TextField("", text: $username)
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
                                    .focused($focus, equals: .username)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Password")
                                    .foregroundColor(focus == .password ? Color.parkFactorPrimary : Color.white)
                                    .font(.parkFactorFontSubtitle)
                                    .opacity(focus == .password ? 1 : 0.6)
                                SecureField("", text: $password)
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
                            print("\(username) with a password of \(password)")
                        }) {
                            Text("Login")
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
                    
                    Section {
                        HStack {
                            Text("Don't have an account?")
                                .foregroundStyle(Color.white)
                            NavigationLink(destination: SignupView()) {
                                Text("Sign up")
                                    .foregroundColor(Color.parkFactorPrimary)
                            }
                        }
                        .font(.parkFactorFontSmallText)
                    }
                    .padding(.top, 30)
                }
                .navigationTitle("Login")
                .navigationBarHidden(true)
            }
        }
    }
    
    var isFormValid: Bool {
        !username.isEmpty && !password.isEmpty
    }
    
    // TODO: Create a function for what happens when the button is pressed, try logging in user
}

#Preview {
    LoginView()
}
