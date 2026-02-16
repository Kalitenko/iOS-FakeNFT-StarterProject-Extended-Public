//
//  CollectionItem.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 10.02.2026.
//

import Foundation

struct CollectionItem: Hashable {
    let id: String
    let name: String
    let imagesUrlsStrings: [String]
    let rating: Int
    let price: Decimal
    let isFavorite: Bool
    let isInCart: Bool
    
    init(id: String, name: String, imageURLs: [String], rating: Int, price: Decimal, isFavorite: Bool, isInCart: Bool = false) {
        self.id = id
        self.name = name
        self.imagesUrlsStrings = imageURLs
        self.rating = rating
        self.price = price
        self.isFavorite = isFavorite
        self.isInCart = isInCart
    }
}
