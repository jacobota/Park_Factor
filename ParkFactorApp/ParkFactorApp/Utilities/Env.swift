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
        return getValue(forKey: "EXPRESS_BASE_URL")
    }
    
    // Search the Env.plist file for the key and return the value
    private static func getValue(forKey key: String) -> String {
        guard let filePath = Bundle.main.path(forResource: "Env", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let value = plist[key] as? String else {
            fatalError("Could not find value for key '\(key)' in Env.plist")
        }
        return value
    }
}
