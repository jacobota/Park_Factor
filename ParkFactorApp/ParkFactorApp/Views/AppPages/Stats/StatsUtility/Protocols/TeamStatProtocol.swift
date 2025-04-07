//
//  TeamStatProtocol.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/7/25.
//

import Foundation

protocol TeamStatDoubleProtocol {
    var team: String { get }
    var value: Double { get }
}

protocol TeamStatIntProtocol {
    var team: String { get }
    var value: Int { get }
}
