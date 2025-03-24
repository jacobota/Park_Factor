//
//  ChangeProfilePictureView.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/9/25.
//

import SwiftUI
import PhotosUI

struct ChangeProfilePictureView: View {
    @AppStorage("accessToken") private var accessToken: String?
    @State private var hideSaveImageButton = false
    @State private var profilePicture: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var updateProfilePicture = UpdateProfilePicture()
    @State private var profilePicSaved = false
    @State private var resultMessage: String = ""
    @State private var resultShow: Bool = false
    @State private var successShow: Bool = false
    
    var savedUser: SavedUser
    
    var body: some View {
        ZStack {
            Color.parkFactorSecondary.ignoresSafeArea()
            VStack {
                Section {
                    Text("Change Profile Picture")
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
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 175, height: 175)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.parkFactorPrimary, lineWidth: 3)
                                )
                        } else if let profilePictureURL = savedUser.user.profilePicture, let url = URL(string: profilePictureURL) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .scaledToFill()
                                    .frame(width: 175, height: 175)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(Color.parkFactorPrimary, lineWidth: 3)
                                    )
                            } placeholder: {
                                ProgressView()
                            }
                        } else {
                            Image("ParkFactorLogo")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 175, height: 175)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.parkFactorPrimary, lineWidth: 3)
                                )
                        }
                        
                        PhotosPicker("Select image", selection: $profilePicture, matching: .images)
                            .font(.parkFactorFontSubtitleNorwester)
                            .foregroundStyle(Color.parkFactorPrimary)
                            .foregroundStyle(.white)
                            .padding(.top, 40)
                            .onChange(of: profilePicture) { _, newImage in
                                hideSaveImageButton.toggle()
                                Task {
                                    // Load the PhotoPickerItem to a UIImage and store as selectedImage
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
                        
                        if hideSaveImageButton && selectedImage != nil {
                            Button("Save Image") {
                                Task {
                                   await uploadImageToS3(selectedImage: selectedImage)
                                }
                            }
                            .font(.parkFactorFontSubtitleNorwester)
                            .foregroundStyle(Color.parkFactorPrimary)
                            .padding(.top, 20)
                        }
                    }
                }
                .padding(.top, 30)
            }
        }
    }
    
    private func uploadImageToS3(selectedImage: UIImage?) async {
        if let image = selectedImage, let imageJpegData = image.jpegData(compressionQuality: 0.9) {
            let fileName = "\(savedUser.user.username)-profilepic.jpg"
            let s3Url = await s3UploadImage(s3BucketName: Env.s3BucketNameProfilePic, s3BucketRegion: Env.s3BucketRegion, imageData: imageJpegData, fileName: fileName)
            
            await updateUserProfilePicture(s3Url)
        } else {
            resultMessage = "Failed to upload new profile picture"
            resultShow = true
        }
    }
    
    private func updateUserProfilePicture(_ profilePictureUrl: String) async {
        updateProfilePicture.profilePicture = profilePictureUrl
        
        // call the network request to save new password
        let baseUrl = Env.expressBaseURL
        guard let encoded = try? JSONEncoder().encode(updateProfilePicture) else {
            resultMessage = "Failed to encode New Profile Picture"
            resultShow = true
            return
        }
        
        //create the url
        let url = URL(string: "\(baseUrl)/users/update/profilePicture")!
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
                
                resultMessage = "Successsfully Changed Profile Picture"
                resultShow = false
                successShow = true
                hideSaveImageButton.toggle()
                savedUser.user.profilePicture = profilePictureUrl
            }
        } catch {
            resultMessage = error.localizedDescription
            resultShow = true
        }
    }
}

#Preview {
    ChangeProfilePictureView(savedUser: SavedUser())
}
