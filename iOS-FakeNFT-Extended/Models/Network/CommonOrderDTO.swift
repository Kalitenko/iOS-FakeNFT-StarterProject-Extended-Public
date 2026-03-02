//
//  CommonOrderDTO.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 26.02.2026.
//

import Foundation

struct CommonOrderDTO: Decodable, Sendable {
    let nfts: [String]
}
