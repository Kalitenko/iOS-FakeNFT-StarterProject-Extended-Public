//
//  NFTModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 09.02.2026.
//
import Foundation

struct NFTModel: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let price: String
    let rating: Int
    let imageURL: URL
}
