//
//  CommonProfileDTO.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 26.02.2026.
//

import Foundation

struct CommonProfileDTO: Decodable, Sendable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let likes: [String]
}
