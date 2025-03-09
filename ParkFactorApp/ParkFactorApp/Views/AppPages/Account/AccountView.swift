//
//  AccountView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/6/25.
//

import SwiftUI

struct AccountView: View {
    @Binding var isLoggedIn: Bool
    @State private var selectedTab: String = "Account"
    
    let subTabs = ["Account", "Settings"]
    
    var savedUser: SavedUser
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.parkFactorSecondary.ignoresSafeArea()
                VStack {
                    ZStack {
                        Color.parkFactorSecondary
                        VStack {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(subTabs, id: \.self) { subTab in
                                        Button(action: {
                                            selectedTab = subTab
                                        }) {
                                            Text(subTab)
                                                .font(Font.parkFactorFontTextNorwester)
                                                .foregroundColor(selectedTab == subTab ? Color.parkFactorSecondary : Color.parkFactorPrimary)
                                                .padding()
                                                .background(selectedTab == subTab ? Color.parkFactorPrimary : Color.clear)
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.parkFactorSecondary)
                                .cornerRadius(8)
                            }
                            .defaultScrollAnchor(.center) 
                            .scrollDisabled(true)
                        }
                    }
                    .frame(width: .infinity, height: 75)
                    
                    Spacer()
                    
                    if selectedTab == "Account" {
                        AccountPageView()
                    } else if selectedTab == "Settings" {
                        AccountSettingsView(isLoggedIn: $isLoggedIn, savedUser: savedUser)
                    }
                    
                    Spacer()

                    .padding()
                
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.parkFactorAppPageBackground)
                .padding(.vertical)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Image("ParkFactorLogo")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Text("Account")
                            .font(Font.parkFactorFontTitle)
                            .foregroundColor(.parkFactorPrimary)
                    }
                }
            }
        }
    }
}

#Preview {
    AccountViewPreviewWrapper()
}

struct AccountViewPreviewWrapper: View {
    @State private var isLoggedIn = true
    
    var body: some View {
        AccountView(isLoggedIn: $isLoggedIn, savedUser: SavedUser())
    }
}
