//
//  ChangeUserTagView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/16/25.
//

import SwiftUI

struct ChangeUserTagView: View {
    @AppStorage("accessToken") private var accessToken: String?
    @State private var resultMessage: String = ""
    @State private var resultShow: Bool = false
    @State private var successShow: Bool = false
    @State private var selectedTag: String
    let tags = ["Rookie", "Veteran", "All-Star", "Ace", "Wall Scraper", "Silver Slugger", "MVP", "Cy Young", "Hall of Fame", "Legend"]
    
    var savedUser: SavedUser
    
    init(savedUser: SavedUser) {
        self.savedUser = savedUser
        _selectedTag = State(initialValue: savedUser.user.userTag)
    }
    
    var body: some View {
        ZStack {
            Color.parkFactorSecondary.ignoresSafeArea()
            VStack {
                Text("Select Your Tag")
                    .font(.parkFactorFontSubtitleNorwester)
                    .foregroundStyle(Color.white)
                    .padding(.bottom, 10)
                
                List {
                    ForEach(tags, id: \.self) { tag in
                        Button(action: {
                            Task {
                                //Update tag in the database
                                await updateUserTagFunc(tag)
                            }
                        }) {
                            Text(tag)
                                .font(.parkFactorFontSubtitleNorwester)
                                .foregroundStyle(selectedTag == tag ? Color.parkFactorSecondary : Color.parkFactorPrimary)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .background(selectedTag == tag ? Color.parkFactorPrimary : Color.clear)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.parkFactorPrimary, lineWidth: selectedTag == tag ? 0 : 2)
                                )
                        }
                        .padding(5)
                        .listRowSeparator(.hidden)
                        .listRowBackground(
                            Capsule()
                                .fill(Color.parkFactorSecondary)
                                .padding(5))
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
            .padding()
            .background(Color.parkFactorSecondary)
            .cornerRadius(20)
            .padding()
        }
    }
    
    private func updateUserTagFunc(_ tag: String) async {
        // call the network request to update user tag
        let baseUrl = Env.expressBaseURL
        var updateUserTagRequest = UpdateUserTag()
        updateUserTagRequest.userTag = tag
        guard let encoded = try? JSONEncoder().encode(updateUserTagRequest) else {
            resultMessage = "Failed to encode New Tag"
            resultShow = true
            return
        }
        
        //create the url
        let url = URL(string: "\(baseUrl)/users/update/userTag")!
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
                
                // Update the tag in the savedUser for UserDefaults and selectedTag
                savedUser.user.userTag = tag
                selectedTag = tag
            }
        } catch {
            resultMessage = error.localizedDescription
            resultShow = true
        }
    }
}

#Preview {
    ChangeUserTagView(savedUser: SavedUser())
}
