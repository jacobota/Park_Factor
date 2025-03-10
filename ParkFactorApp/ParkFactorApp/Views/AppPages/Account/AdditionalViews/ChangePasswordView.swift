//
//  ChangePasswordView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/9/25.
//

import SwiftUI

struct ChangePasswordView: View {
    @AppStorage("accessToken") private var accessToken: String?
    @State private var confirmPassword: String = ""
    @State private var resultMessage: String = ""
    @State private var resultShow: Bool = false
    @State private var successShow: Bool = false
    @State private var updatePassword = UpdatePassword()
    @FocusState private var focus: FocusedChangePasswordField?
    
    var savedUser: SavedUser
    
    // enum to focus on username or password
    enum FocusedChangePasswordField {
        case newPassword, confirmPassword
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.parkFactorSecondary.ignoresSafeArea()
                VStack {
                    Section {
                        Text("Change Password")
                            .font(.parkFactorFontTitle)
                            .foregroundStyle(Color.white)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                    }
                    .padding(.bottom, 20)
                    
                    Section {
                        Text("\(resultMessage)")
                            .font(.parkFactorFontText)
                            .foregroundStyle(resultShow ? Color.red : Color.parkFactorPrimary)
                            .multilineTextAlignment(.center)
                            .opacity(resultShow || successShow ? 1 : 0)
                        
                        VStack {
                            VStack(alignment: .leading) {
                                Text("New Password")
                                    .foregroundColor(focus == .newPassword ? Color.parkFactorPrimary : Color.white)
                                    .font(.parkFactorFontSubtitleArchivo)
                                    .opacity(focus == .newPassword ? 1 : 0.6)
                                SecureField("", text: $updatePassword.password)
                                    .keyboardType(.default)
                                    .padding()
                                    .background(Color.parkFactorSecondary)
                                    .foregroundColor(focus == .newPassword ? Color.parkFactorPrimary : Color.white)
                                    .font(.parkFactorFontText)
                                    .border(focus == .newPassword ? Color.parkFactorPrimary : Color.white, width: 2)
                                    .cornerRadius(5)
                                    .frame(height: 35)
                                    .padding(.bottom)
                                    .textInputAutocapitalization(.never)
                                    .focused($focus, equals: .newPassword)
                            }
                            .padding(.top, 20)
                            
                            VStack(alignment: .leading) {
                                Text("Confirm Password")
                                    .foregroundColor(focus == .confirmPassword ? Color.parkFactorPrimary : Color.white)
                                    .font(.parkFactorFontSubtitleArchivo)
                                    .opacity(focus == .confirmPassword ? 1 : 0.6)
                                SecureField("", text: $confirmPassword)
                                    .keyboardType(.default)
                                    .padding()
                                    .background(Color.parkFactorSecondary)
                                    .foregroundColor(focus == .confirmPassword ? Color.parkFactorPrimary : Color.white)
                                    .font(.parkFactorFontText)
                                    .border(focus == .confirmPassword ? Color.parkFactorPrimary : Color.white, width: 2)
                                    .cornerRadius(5)
                                    .frame(height: 35)
                                    .padding(.bottom)
                                    .textInputAutocapitalization(.never)
                                    .focused($focus, equals: .confirmPassword)
                            }
                            .padding(.top, 20)
                        }
                        .onSubmit {
                            if focus == .newPassword {
                                focus = .confirmPassword
                            }else {
                                focus = nil
                            }
                        }
                        
                        Button(action: {
                            Task {
                                await updatePasswordFunc()
                            }
                        }) {
                            Text("Update Password")
                                .font(.parkFactorFontSubtitleArchivo)
                                .foregroundColor(isFormValid ? Color.parkFactorSecondary : .gray)
                                .containerRelativeFrame(.horizontal) { size, axis in
                                    size * 0.6
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
                }
                .containerRelativeFrame(.horizontal) { size, axis in
                    size * 0.8
                }
            }
        }
    }
    
    var isFormValid: Bool {
        !confirmPassword.isEmpty && !updatePassword.password.isEmpty && confirmPassword == updatePassword.password
    }
    
    func updatePasswordFunc() async {
        // call the network request to save new password
        let baseUrl = Env.expressBaseURL
        guard let encoded = try? JSONEncoder().encode(updatePassword) else {
            resultMessage = "Failed to encode New Password"
            resultShow = true
            return
        }
        
        //create the url
        let url = URL(string: "\(baseUrl)/users/update/password")!
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
                    resultMessage = decodedNodeError.message
                    resultShow = true
                    return
                }
                
                resultMessage = "Successsfully Changed Password"
                resultShow = false
                successShow = true
            }
        } catch {
            resultMessage = error.localizedDescription
            resultShow = true
        }
    }
}

#Preview {
    ChangePasswordView(savedUser: SavedUser())
}
