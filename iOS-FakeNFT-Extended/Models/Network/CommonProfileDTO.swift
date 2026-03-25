//
//  CommonProfileDTO.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 26.02.2026.
//

import Foundation

struct CommonProfileDTO: Decodable, Sendable {
    let id: String
    let nfts: [String]
    let likes: [String]
}
