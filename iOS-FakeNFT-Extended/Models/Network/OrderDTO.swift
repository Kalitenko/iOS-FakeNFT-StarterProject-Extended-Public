//
//  OrderDTO.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 17.02.2026.
//

struct OrderDTO: Decodable, Sendable {
    let nfts: [String]
    let id: String
}
