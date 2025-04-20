//
//  Env.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 3/2/25.
//

import Foundation

struct Env {
    // Get the Express Base URL to be used for networking calls
    static var expressBaseURL: String {
        return getValue("EXPRESS_BASE_URL")
    }
    
    static var awsAccessKey: String {
        return getValue("AWS_ACCESS_KEY")
    }
    
    static var awsSecretAccessKey: String {
        return getValue("AWS_SECRET_ACCESS_KEY")
    }
    
    static var s3BucketNameProfilePic: String {
        return getValue("S3_BUCKET_NAME_PROFILE_PIC")
    }
    
    static var s3BucketNamePostImages: String {
        return getValue("S3_BUCKET_NAME_POST_IMAGE")
    }
    
    static var s3BucketRegion: String {
        return getValue("S3_BUCKET_REGION")
    }
    
    static var flaskBaseUrl: String {
        return getValue("FLASK_URL")
    }
    
    // Search the Env.plist file for the key and return the value
    private static func getValue(_ key: String) -> String {
        guard let filePath = Bundle.main.path(forResource: "Env", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let value = plist[key] as? String else {
            fatalError("Could not find value for key '\(key)' in Env.plist")
        }
        return value
    }
}
