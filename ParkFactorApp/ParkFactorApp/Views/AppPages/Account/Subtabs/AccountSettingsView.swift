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
                Section {
                    NavigationLink(destination: ChangeEmailView(savedUser: savedUser)) {
                        Text("Change Email")
                            .font(Font.parkFactorFontSubtitleNorwester)
                            .foregroundStyle(Color.parkFactorPrimary)
                            .frame(maxWidth: .infinity, alignment: .center)
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
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        Capsule()
                            .fill(Color.parkFactorSecondary)
                            .padding(5))
                    
                    NavigationLink(destination: ChangeProfilePictureView()) {
                        Text("Change Profile Picture")
                            .font(Font.parkFactorFontSubtitleNorwester)
                            .foregroundStyle(Color.parkFactorPrimary)
                            .frame(maxWidth: .infinity, alignment: .center)
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
                                // Handle the delete account action
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
            .environment(\.defaultMinListRowHeight, 60)
            .listStyle(GroupedListStyle())
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
