//
//  Bundle-Decodable.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/21/25.
//  Credit to 100 Days of Swift Tutorial

import Foundation

extension Bundle {
    func decode(_ file: String) -> [String: StatCategory] {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode([String: StatCategory].self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
}
