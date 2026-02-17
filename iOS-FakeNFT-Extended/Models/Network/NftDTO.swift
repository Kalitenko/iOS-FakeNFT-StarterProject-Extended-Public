//
//  NftDTO.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 17.02.2026.
//
import Foundation

struct NftDTO: Decodable, Sendable {
    let createdAt: String?
    let name: String
    let images: [URL]
    let rating: Int
    let description: String?
    let price: Double
    let author: String?
    let website: String?
    let id: String
}
