//
//  UpdateProfileDTO.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 15/03/2026.
//

import Foundation

struct UpdateProfileDTO: Sendable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let likes: [String]
}
