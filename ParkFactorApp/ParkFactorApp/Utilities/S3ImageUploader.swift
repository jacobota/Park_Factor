//
//  S3ImageUploader.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/10/25.
//

import Foundation
import AWSS3
import AWSSDKIdentity
import Smithy

// Inspired by https://docs.aws.amazon.com/sdk-for-swift/latest/developer-guide/swift_s3_code_examples.html

func s3UploadImage(s3BucketName: String, s3BucketRegion: String, imageData: Data, fileName: String) async -> String {
    // Environment variables for the bucket
    let accessKey = Env.awsAccessKey
    let secretAccessKey = Env.awsSecretAccessKey
    let bucketName = s3BucketName
    let bucketRegion = s3BucketRegion
    
    do {
        // Configure AWS credentials (https://docs.aws.amazon.com/sdk-for-swift/latest/developer-guide/using-identity.html)
        let credentials = AWSCredentialIdentity(accessKey: accessKey, secret: secretAccessKey)
        let identityResolver = try StaticAWSCredentialIdentityResolver(credentials)
        let s3Config = try await S3Client.S3ClientConfiguration(awsCredentialIdentityResolver: identityResolver, region: bucketRegion)
        
        // Set up S3 client
        let s3Client = S3Client(config: s3Config)
        
        //Create the putObject request
        var putObjectRequest = AWSS3.PutObjectInput()
        putObjectRequest.bucket = bucketName
        putObjectRequest.key = fileName
        putObjectRequest.body = ByteStream.data(imageData)
        putObjectRequest.contentType = "image/jpeg"
        
        // Upload the image to S3
        let _ = try await s3Client.putObject(input: putObjectRequest)
        
        return "https://\(bucketName).s3.\(bucketRegion).amazonaws.com/\(fileName)"
    } catch {
        print("Error: \(error)")
    }
    return ""
}
