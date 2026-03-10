//
//  UpdateOrderBody.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 17.02.2026.
//

import Foundation

struct UpdateOrderBody: Encodable, Sendable {
    let nfts: [String]
}
