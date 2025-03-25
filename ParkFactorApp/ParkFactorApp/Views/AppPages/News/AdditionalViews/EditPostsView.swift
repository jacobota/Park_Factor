//
//  EditPostsView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/23/25.
//

import SwiftUI
import PhotosUI

struct EditPostsView: View {
    @AppStorage("accessToken") private var accessToken: String?
    @State private var checkChangeContent: String = ""
    @State private var postContent: String = ""
    @State private var postImage: String = ""
    @State private var profilePicture: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var profilePicSaved = false
    @State private var resultMessage: String = ""
    @State private var resultShow: Bool = false
    @State private var successShow: Bool = false
    @State private var isPictureUpdated: Bool = false
    @FocusState private var focus: FocusedChangeEmailField?
    
    // enum to focus on change email fields
    enum FocusedChangeEmailField {
        case content
    }
    
    var post: Post
    
    var body: some View {
        ZStack {
            Color.parkFactorSecondary.ignoresSafeArea()
            ScrollView {
                Section {
                    VStack {
                        Text("Edit Post")
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
                                        } else if !postImage.isEmpty {
                                            AsyncImage(url: URL(string: postImage)) { image in
                                                image.resizable()
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 120, height: 120)
                                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                                    .padding()
                                            } placeholder: {
                                                ProgressView()
                                            }
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
                                                                isPictureUpdated = true
                                                            }
                                                        }
                                                    }
                                                }
                                            Spacer()
                                        }
                                        if !postImage.isEmpty || selectedImage != nil {
                                            HStack {
                                                Spacer()
                                                Button(action: {
                                                    postImage = ""
                                                    selectedImage = nil
                                                    isPictureUpdated = true
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
                            Text("Edit")
                                .font(.parkFactorFontBigTextArchivo)
                                .foregroundColor(postContent != checkChangeContent || isPictureUpdated ? Color.parkFactorSecondary : .gray)
                                .containerRelativeFrame(.horizontal) { size, axis in
                                    size * 0.5
                                }
                                .padding()
                                .background(postContent != checkChangeContent || isPictureUpdated ?  Color.parkFactorPrimary : Color.clear)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                        }
                        .disabled(postContent == checkChangeContent && !isPictureUpdated)
                        .padding(30)
                    }
                    .padding(20)
                    .background(Color.parkFactorSecondary)
                    .cornerRadius(20)
                }
                .padding()
            }
            .padding()
            .scrollIndicators(.hidden)
            .alert("Result", isPresented: $resultShow) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(resultMessage)
            }
        }
        .onAppear {
            checkChangeContent = post.content ?? ""
            postContent = post.content ?? ""
            postImage = post.postImage ?? ""
        }
    }
    
    private func uploadImageToS3(selectedImage: UIImage?, uuid: String) async -> String {
        if let image = selectedImage, let imageJpegData = image.jpegData(compressionQuality: 0.9) {
            let fileName = "\(uuid)-postimage.jpg"
            let s3Url = await s3UploadImage(s3BucketName: Env.s3BucketNamePostImages, s3BucketRegion: Env.s3BucketRegion, imageData: imageJpegData, fileName: fileName)

            return s3Url
        } else {
            resultMessage = "Failed to upload image"
            resultShow = true
            return ""
        }
    }
    
    private func postVerifiedUserPost() async {
        var verifiedUserPost = VerifiedUserPost()
        verifiedUserPost.content = postContent
        
        // Check if the image was updated and update the pic
        if isPictureUpdated && selectedImage != nil {
            verifiedUserPost.postImage = await uploadImageToS3(selectedImage: selectedImage, uuid: post.postId)
        } else {
            verifiedUserPost.postImage = ""
        }

        // call the network request to save verified user post
        let baseUrl = Env.expressBaseURL
        guard let encoded = try? JSONEncoder().encode(verifiedUserPost) else {
            resultMessage = "Failed to encode Post"
            resultShow = true
            return
        }
        
        //create the url
        let url = URL(string: "\(baseUrl)/verifiedPosts/update/\(post.postId)")!
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
            }

            resultMessage = "Successsfully Updated Post"
            resultShow = true
        } catch {
            resultMessage = error.localizedDescription
            resultShow = true
        }
    }
}

#Preview {
    EditPostsView(post: Post(postId: "6dcff1c8-f4ed-4199-9392-aac4ac814c37", author: "jacobota", authorProfilePicture: "https://parkfactor-profilepictures.s3.us-west-1.amazonaws.com/jacobota-profilepic.jpg", createdAt: "", content: "Testing without a picture.", postImage: "https://parkfactor-postimages.s3.us-west-1.amazonaws.com/aa38a961-45d9-4e76-b171-b78a23b352a2-postimage.jpg"))
}
