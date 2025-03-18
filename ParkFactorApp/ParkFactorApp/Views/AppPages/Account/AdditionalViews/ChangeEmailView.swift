//
//  ChangeEmailView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/9/25.
//

import SwiftUI

struct ChangeEmailView: View {
    @AppStorage("accessToken") private var accessToken: String?
    @State private var confirmEmail: String = ""
    @State private var resultMessage: String = ""
    @State private var resultShow: Bool = false
    @State private var successShow: Bool = false
    @State private var updateEmail = UpdateEmail()
    @FocusState private var focus: FocusedChangeEmailField?
    
    var savedUser: SavedUser
    
    // enum to focus on change email fields
    enum FocusedChangeEmailField {
        case newEmail, confirmEmail
    }
    
    var body: some View {
        ZStack {
            Color.parkFactorSecondary.ignoresSafeArea()
            VStack {
                Section {
                    Text("Change Email")
                        .font(.parkFactorFontTitle)
                        .foregroundStyle(Color.white)
                    
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
                            Text("New Email")
                                .foregroundColor(focus == .newEmail ? Color.parkFactorPrimary : Color.white)
                                .font(.parkFactorFontSubtitleArchivo)
                                .opacity(focus == .newEmail ? 1 : 0.6)
                            TextField("", text: $updateEmail.email)
                                .keyboardType(.default)
                                .padding()
                                .background(Color.parkFactorSecondary)
                                .foregroundColor(focus == .newEmail ? Color.parkFactorPrimary : Color.white)
                                .font(.parkFactorFontText)
                                .border(focus == .newEmail ? Color.parkFactorPrimary : Color.white, width: 2)
                                .cornerRadius(5)
                                .frame(height: 35)
                                .padding(.bottom)
                                .textInputAutocapitalization(.never)
                                .focused($focus, equals: .newEmail)
                        }
                        .padding(.top, 20)
                        
                        VStack(alignment: .leading) {
                            Text("Confirm Email")
                                .foregroundColor(focus == .confirmEmail ? Color.parkFactorPrimary : Color.white)
                                .font(.parkFactorFontSubtitleArchivo)
                                .opacity(focus == .confirmEmail ? 1 : 0.6)
                            TextField("", text: $confirmEmail)
                                .keyboardType(.default)
                                .padding()
                                .background(Color.parkFactorSecondary)
                                .foregroundColor(focus == .confirmEmail ? Color.parkFactorPrimary : Color.white)
                                .font(.parkFactorFontText)
                                .border(focus == .confirmEmail ? Color.parkFactorPrimary : Color.white, width: 2)
                                .cornerRadius(5)
                                .frame(height: 35)
                                .padding(.bottom)
                                .textInputAutocapitalization(.never)
                                .focused($focus, equals: .confirmEmail)
                        }
                        .padding(.top, 20)
                    }
                    .onSubmit {
                        if focus == .newEmail {
                            focus = .confirmEmail
                        }else {
                            focus = nil
                        }
                    }
                    
                    Button(action: {
                        Task {
                            await updateEmailFunc()
                        }
                    }) {
                        Text("Update Email")
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
    
    var isFormValid: Bool {
        !confirmEmail.isEmpty && !updateEmail.email.isEmpty && confirmEmail == updateEmail.email
    }
    
    func updateEmailFunc() async {
        // call the network request to update email
        let baseUrl = Env.expressBaseURL
        guard let encoded = try? JSONEncoder().encode(updateEmail) else {
            resultMessage = "Failed to encode New Email"
            resultShow = true
            return
        }
        
        //create the url
        let url = URL(string: "\(baseUrl)/users/update/email")!
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
                
                resultMessage = "Successsfully Changed Email"
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
    ChangeEmailView(savedUser: SavedUser())
}
