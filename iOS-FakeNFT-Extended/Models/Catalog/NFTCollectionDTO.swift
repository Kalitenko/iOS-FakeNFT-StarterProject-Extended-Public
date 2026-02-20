//
//  NFTCollectionDTO.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 17.02.2026.
//

import Foundation

struct NFTCollectionDTO: Decodable, Hashable, Sendable {
    let id: String
    let name: String
    let description: String
    let cover: String
    let nfts: [String]
    let author: String
    let website: String
    let createdAt: String
}

extension NFTCollectionDTO {
    func toDomain() -> CatalogItem {
        CatalogItem(
            id: id,
            name: name,
            description: description,
            count: nfts.count,
            cover: cover,
            nftIDs: nfts,
            author: author,
            website: website
        )
    }
}
