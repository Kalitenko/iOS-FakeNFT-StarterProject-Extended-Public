//
//  CatalogItem.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 10.02.2026.
//

import Foundation

struct CatalogItem: Hashable {
    let id: String
    let name: String
    let description: String
    let count: Int
    let cover: ImageSource
    let nftIDs: [String]
    let author: String
    let website: String
}
