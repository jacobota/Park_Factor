//
//  PlayerStatProtocol.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 4/7/25.
//

import Foundation

protocol PlayerStatDoubleProtocol {
    var name: String { get }
    var value: Double { get }
    var team: String { get }
}

protocol PlayerStatIntProtocol {
    var name: String { get }
    var value: Int { get }
    var team: String { get }
}
