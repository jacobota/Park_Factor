//
//  DropDownMenuView.swift
//  ParkFactorApp
//
//  Gained inspiration for this Drop Down menu component from this site: https://stackademic.com/blog/swiftui-dropdown-menu-3-ways-picker-menu-and-custom-from-scratch
//  Regular Picker or Menu SwiftUI components were not useful so custom one was created
//
//  Created by Jacob Ota on 4/6/25.
//

import SwiftUI

struct DropDownMenuView: View {
    let options: [String]
    
    @Binding  var selectedOption: String
    @Binding  var showDropdown: Bool
    
    var body: some  View {
        VStack {
            VStack {
                Button(action: {
                    showDropdown.toggle()
                }, label: {
                    HStack {
                        Text(selectedOption)
                            .font(.parkFactorFontBigTextNorwester)
                            .foregroundStyle(Color.parkFactorPrimary)
                            .padding(10)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees((showDropdown ?  -180 : 0)))
                            .foregroundStyle(Color.parkFactorPrimary)
                    }
                })
                .padding(.horizontal, 20)
                .frame(width: .infinity, height: 65)
                
                
                // display selection menu if true
                if (showDropdown) {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(options, id: \.self) { option in
                                Button(action: {
                                    selectedOption = option
                                    showDropdown.toggle()
                                }, label: {
                                    HStack {
                                        if (option != selectedOption) {
                                            Text(option)
                                                .font(.parkFactorFontBigTextNorwester)
                                                .foregroundStyle(Color.white)
                                        } else {
                                            Text(option)
                                                .font(.parkFactorFontBigTextNorwester)
                                                .foregroundStyle(Color.parkFactorPrimary)
                                        }
                                    }
                                })
                                .padding(20)
                                .frame(width: .infinity, height: 50)
                            }
                        }
                    }
                    .frame(height: 55*CGFloat(options.count))
                }
            }
            .foregroundStyle(Color.white)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.black))
        }
        .padding()
        .frame(width: .infinity, height: 75, alignment: .top)
        .zIndex(100)
    }
}

#Preview {
    DropDownPreviewWrapper()
}

struct DropDownPreviewWrapper: View {
    @State private var selectedOption = "Hitter Leaderboard"
    @State private var showDropdown = false
    
    var body: some View {
        DropDownMenuView(options: ["Hitter Leaderboard", "Following Players", "Player Lookup"], selectedOption: $selectedOption, showDropdown: $showDropdown)
    }
}
