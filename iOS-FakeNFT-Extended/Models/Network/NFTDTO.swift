//
//  NFTDTO.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 17.02.2026.
//

import Foundation

struct NFTDTO: Decodable, Hashable, Sendable {
    let id: String
    let name: String
    let images: [URL]
    let description: String
    let rating: Int
    let price: Decimal
    let author: String
    let website: String
    let createdAt: String
}

extension NFTDTO {
    func toDomain(
        isFavorite: Bool = false,
        isInCart: Bool = false
    ) -> CollectionItem {
        CollectionItem(
            id: id,
            name: name,
            imageURLs: images.map(ImageSource.remote),
            rating: rating,
            price: price,
            isFavorite: isFavorite,
            isInCart: isInCart
        )
    }
}
