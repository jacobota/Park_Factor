//
//  AccountSettingsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/8/25.
//

import SwiftUI

struct AccountSettingsView: View {
    @Binding var isLoggedIn: Bool
    @AppStorage("accessToken") private var accessToken: String?
    @State private var showLogoutAlert: Bool = false
    @State private var showDeleteAlert: Bool = false
    
    var savedUser: SavedUser
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Update Profile Overview")
                    .font(Font.parkFactorFontTextNorwester)
                    .foregroundStyle(Color.parkFactorPrimary)
                    .padding(.bottom, 10)
                ){
                    NavigationLink(destination: ChangeProfilePictureView(savedUser: savedUser)) {
                        Text("Change Profile Picture")
                            .font(Font.parkFactorFontSubtitleNorwester)
                            .foregroundStyle(Color.parkFactorPrimary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(15)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        Capsule()
                            .fill(Color.parkFactorSecondary)
                            .padding(5))
                    
                    NavigationLink(destination: ChangeUserTagView(savedUser: savedUser)) {
                        Text("User Tag")
                            .font(Font.parkFactorFontSubtitleNorwester)
                            .foregroundStyle(Color.parkFactorPrimary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(15)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        Capsule()
                            .fill(Color.parkFactorSecondary)
                            .padding(5))
                    
                    NavigationLink(destination: ChangeFavoriteTeamView(savedUser: savedUser)) {
                        Text("Favorite Team")
                            .font(Font.parkFactorFontSubtitleNorwester)
                            .foregroundStyle(Color.parkFactorPrimary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(15)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        Capsule()
                            .fill(Color.parkFactorSecondary)
                            .padding(5))
                    
                    NavigationLink(destination: ChangeFavoritePlayerView(savedUser: savedUser)) {
                        Text("Favorite Player")
                            .font(Font.parkFactorFontSubtitleNorwester)
                            .foregroundStyle(Color.parkFactorPrimary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(15)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        Capsule()
                            .fill(Color.parkFactorSecondary)
                            .padding(5))
                }
                
                Section(header: Text("Update Account Information")
                    .font(Font.parkFactorFontTextNorwester)
                    .foregroundStyle(Color.parkFactorPrimary)
                    .padding(.bottom, 10)
                ){
                    NavigationLink(destination: ChangeEmailView(savedUser: savedUser)) {
                        Text("Change Email")
                            .font(Font.parkFactorFontSubtitleNorwester)
                            .foregroundStyle(Color.parkFactorPrimary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(15)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        Capsule()
                            .fill(Color.parkFactorSecondary)
                            .padding(5))
                    
                    NavigationLink(destination: ChangePasswordView(savedUser: savedUser)) {
                        Text("Change Password")
                            .font(Font.parkFactorFontSubtitleNorwester)
                            .foregroundStyle(Color.parkFactorPrimary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(15)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        Capsule()
                            .fill(Color.parkFactorSecondary)
                            .padding(5))
                }
                
                Section {
                    Button(action: {
                        showLogoutAlert = true
                    }) {
                        Text("Logout")
                            .font(Font.parkFactorFontSubtitleNorwester)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(15)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        Capsule()
                            .fill(Color.red)
                            .padding(5))
                    .alert(isPresented: $showLogoutAlert) {
                        Alert(
                            title: Text("Confirm Logout"),
                            message: Text("Are you sure you want to logout?"),
                            primaryButton: .destructive(Text("Logout")) {
                                // logout and clear token
                                accessToken = nil
                                isLoggedIn = false
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    
                    Button(action: {
                        showDeleteAlert = true
                    }) {
                        Text("Delete Account")
                            .font(Font.parkFactorFontSubtitleNorwester)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(15)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        Capsule()
                            .fill(Color.red)
                            .padding(5))
                    .alert(isPresented: $showDeleteAlert) {
                        Alert(
                            title: Text("Delete Account"),
                            message: Text("Are you sure you want to delete your ParkFactor account? \n\nThis action cannot is permanent."),
                            primaryButton: .destructive(Text("Delete")) {
                                Task {
                                    await deleteAccount()
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
            .environment(\.defaultMinListRowHeight, 60)
            .listStyle(GroupedListStyle())
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .containerRelativeFrame(.horizontal) { size, axis in
                size * 0.9
            }
        }
    }
    
    func deleteAccount() async {
        // call the network request to delete the user
        let baseUrl = Env.expressBaseURL
        
        //create the url
        let url = URL(string: "\(baseUrl)/users/delete")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        
        do {
            let (_, res) = try await URLSession.shared.data(for: request)
            
            // handle the result if bad
            if let httpResponse = res as? HTTPURLResponse {
                // If the result of the http response is a 400 then the message of what went wrong will be returned and placed in errorMessage
                if httpResponse.statusCode != 200 {
                     return
                }
                
                accessToken = nil
                isLoggedIn = false
            }
        } catch {
            return
        }
    }
}
    
#Preview {
    AccountSettingsViewPreviewWrapper()
}

struct AccountSettingsViewPreviewWrapper: View {
    @State private var isLoggedIn = true
    
    var body: some View {
        AccountSettingsView(isLoggedIn: $isLoggedIn, savedUser: SavedUser())
    }
}
