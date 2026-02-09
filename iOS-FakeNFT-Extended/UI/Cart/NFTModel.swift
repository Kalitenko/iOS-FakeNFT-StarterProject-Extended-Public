//
//  NFTModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 09.02.2026.
//
import SwiftUI

struct NFTModel: Identifiable {
    let id = UUID()
    let name: String
    let price: String
    let rating: Int
    let image: Image
}
