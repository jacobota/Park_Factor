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
    @State private var confirmEmail: String = ""
    @State private var resultMessage: String = ""
    @State private var resultShow: Bool = false
    @State private var successShow: Bool = false
    @State private var hideSaveImageButton = false
    @State private var profilePicture: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var uploadStatus: String?
    
    var savedUser: SavedUser
    
    var body: some View {
        ZStack {
            Color.parkFactorSecondary.ignoresSafeArea()
            VStack {
                Section {
                    Text("Change Profile Picture")
                        .font(.parkFactorFontTitle)
                        .foregroundStyle(Color.white)
                        .foregroundStyle(.white)
                    
                }
                .padding(.bottom, 20)
                
                Section {
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
                        

                        if let uploadStatus = uploadStatus {
                            Text(uploadStatus)
                                .foregroundStyle(Color.parkFactorPrimary)
                                .font(.parkFactorFontSubtitleArchivo)
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
            let s3Url = await s3UploadImage(imageData: imageJpegData, fileName: fileName)
            
            updateUserProfilePicture(s3Url)
            uploadStatus = "Profile Picture Updated Successfully!"
            hideSaveImageButton.toggle()
        } else {
            uploadStatus = "Failed to upload image"
        }
    }
    
    private func updateUserProfilePicture(_ url: String) {
        savedUser.user.profilePicture = url
    }
}

#Preview {
    ChangeProfilePictureView(savedUser: SavedUser())
}
