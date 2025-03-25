//
//  PostTemplateView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/23/25.
//

import SwiftUI
import PhotosUI

struct PostTemplateView: View {
    @AppStorage("accessToken") private var accessToken: String?
    @State private var postContent: String = ""
    @State private var postImage: String = ""
    @State private var profilePicture: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var profilePicSaved = false
    @State private var resultMessage: String = ""
    @State private var resultShow: Bool = false
    @State private var successShow: Bool = false
    @FocusState private var focus: FocusedChangeEmailField?
    
    // enum to focus on change email fields
    enum FocusedChangeEmailField {
        case content
    }
    
    var savedUser: SavedUser
    
    var body: some View {
        ZStack {
            Color.parkFactorAppPageBackground.ignoresSafeArea()
            ScrollView {
                Section {
                    VStack {
                        Text("Post to the Concourse")
                            .font(.parkFactorFontSubtitleNorwester)
                            .foregroundStyle(Color.white)
                            .padding(.top, 20)
                        VStack {
                            VStack(alignment: .leading) {
                                Text("Content")
                                    .foregroundColor(focus == .content ? Color.parkFactorPrimary : Color.white)
                                    .font(.parkFactorFontBigTextArchivo)
                                    .opacity(focus == .content ? 1 : 0.6)
                                TextEditor(text: $postContent)
                                    .keyboardType(.default)
                                    .padding()
                                    .scrollContentBackground(.hidden)
                                    .background(Color.parkFactorSecondary)
                                    .foregroundColor(focus == .content ? Color.parkFactorPrimary : Color.white)
                                    .font(.parkFactorFontText)
                                    .border(focus == .content ? Color.parkFactorPrimary : Color.white, width: 2)
                                    .cornerRadius(8)
                                    .frame(height: 150)
                                    .textInputAutocapitalization(.never)
                                    .focused($focus, equals: .content)
                                HStack {
                                    Spacer()
                                    
                                    Text("\(postContent.count)/255")
                                        .font(.parkFactorFontSmallTextNorwester)
                                        .foregroundStyle(focus == .content ? Color.parkFactorPrimary : Color.white)
                                        .padding(.horizontal, 20)
                                }
                            }
                            .padding(.top, 20)
                            
                            VStack(alignment: .leading) {
                                Text("Content Image (Optional)")
                                    .foregroundColor(Color.white)
                                    .font(.parkFactorFontBigTextArchivo)
                                    .opacity(1)
                                Section {
                                    VStack {
                                        if let selectedImage = selectedImage {
                                            Image(uiImage: selectedImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 120, height: 120)
                                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                                .padding()
                                        }
                                        HStack {
                                            Spacer()
                                            PhotosPicker("Select image", selection: $profilePicture, matching: .images)
                                                .font(.parkFactorFontSubtitleArchivo)
                                                .foregroundStyle(Color.parkFactorPrimary)
                                                .foregroundStyle(.white)
                                                .padding(.top, 20)
                                                .onChange(of: profilePicture) { _, newImage in
                                                    Task {
                                                        if let data = try? await newImage?.loadTransferable(type: Data.self) {
                                                            if let uiImage = UIImage(data: data) {
                                                                selectedImage = uiImage
                                                                resultMessage = ""
                                                                resultShow = false
                                                                successShow = false
                                                                profilePicSaved = false
                                                            }
                                                        }
                                                    }
                                                }
                                            Spacer()
                                        }
                                        if selectedImage != nil {
                                            HStack {
                                                Spacer()
                                                Button(action: {
                                                    postImage = ""
                                                    selectedImage = nil
                                                }) {
                                                    Text("Remove Image")
                                                        .font(.parkFactorFontSubtitleArchivo)
                                                        .foregroundStyle(Color.red)
                                                        .foregroundStyle(.white)
                                                        .padding(.top, 5)
                                                }
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                                .padding(.top, 30)
                            }
                            .padding(.top, 20)
                        }
                        
                        Button(action: {
                            Task {
                                await postVerifiedUserPost()
                            }
                        }) {
                            Text("Post")
                                .font(.parkFactorFontBigTextArchivo)
                                .foregroundColor(postContent.isEmpty ? .gray : Color.parkFactorSecondary)
                                .containerRelativeFrame(.horizontal) { size, axis in
                                    size * 0.5
                                }
                                .padding()
                                .background(postContent.isEmpty ? Color.clear : Color.parkFactorPrimary)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                        }
                        .disabled(postContent.isEmpty)
                        .padding(30)
                    }
                    .padding(20)
                    .background(Color.parkFactorSecondary)
                    .cornerRadius(20)
                }
                .padding()
            }
            .scrollIndicators(.hidden)
            .alert("Success", isPresented: $successShow) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(resultMessage)
            }
            .alert("Error", isPresented: $resultShow) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(resultMessage)
            }
        }
    }
    
    private func uploadImageToS3(selectedImage: UIImage?, uuid: String) async -> String {
        if let image = selectedImage, let imageJpegData = image.jpegData(compressionQuality: 0.9) {
            let fileName = "\(uuid)-postimage.jpg"
            let s3Url = await s3UploadImage(s3BucketName: Env.s3BucketNamePostImages, s3BucketRegion: Env.s3BucketRegion, imageData: imageJpegData, fileName: fileName)

            return s3Url
        } else {
            resultMessage = "Failed to upload new profile picture"
            resultShow = true
            return ""
        }
    }
    
    private func postVerifiedUserPost() async {
        var verifiedUserPost = VerifiedUserPost()
        verifiedUserPost.authorProfilePicture = savedUser.user.profilePicture ?? ""
        verifiedUserPost.content = postContent
        
        // call the network request to save verified user post
        let baseUrl = Env.expressBaseURL
        guard let encoded = try? JSONEncoder().encode(verifiedUserPost) else {
            resultMessage = "Failed to encode Post"
            resultShow = true
            return
        }
        
        //create the url
        let url = URL(string: "\(baseUrl)/verifiedPosts/create")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
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
                
                if selectedImage != nil {
                    // Decode response to get postId if there is an image to get UUID for image
                    let decodedResponse = try JSONDecoder().decode(VerifiedUserPostResponse.self, from: data)
                    let postId = decodedResponse.postId
                    
                    //call the method to store the image
                    let postImageUrl = await uploadImageToS3(selectedImage: selectedImage, uuid: postId)
                    
                    // call the network request to save image as well with UUID from post just created
                    verifiedUserPost.content = postContent
                    verifiedUserPost.postImage = postImageUrl
                    let baseUrl = Env.expressBaseURL
                    guard let encoded = try? JSONEncoder().encode(verifiedUserPost) else {
                        resultMessage = "Failed to encode Post"
                        resultShow = true
                        return
                    }
                    
                    //create the url
                    let url = URL(string: "\(baseUrl)/verifiedPosts/update/\(postId)")!
                    var request = URLRequest(url: url)
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
                    request.httpMethod = "PUT"
                    
                    do {
                        let (data, res) = try await URLSession.shared.upload(for: request, from: encoded)
                        
                        // handle the result if bad
                        if let httpResponse = res as? HTTPURLResponse {
                            // If the result of the http response is a 400 then the message of what went wrong will be returned and placed in errorMessage
                            if httpResponse.statusCode != 200 {
                                let decodedNodeError = try JSONDecoder().decode(NodeError.self, from: data)
                                resultMessage = decodedNodeError.message
                                resultShow = true
                                return
                            }
                        }
                    } catch {
                        resultMessage = error.localizedDescription
                        resultShow = true
                        return
                    }
                }
            }
            resultMessage = "Successsfully Created Post"
            postContent = ""
            selectedImage = nil
            postImage = ""
            resultShow = false
            successShow = true
        } catch {
            resultMessage = error.localizedDescription
            resultShow = true
        }
    }
}

#Preview {
    PostTemplateView(savedUser: SavedUser())
}
