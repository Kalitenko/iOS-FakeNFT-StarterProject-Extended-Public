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
    let cover: URL
    let nfts: [String]
    let author: String
    let website: String
    let createdAt: String
}

extension NFTCollectionDTO {
    
    func toDomain() -> CatalogItem {
        let uniqueNFTs = nfts.uniquedPreservingOrder()
        
        return CatalogItem(
            id: id,
            name: name,
            description: description,
            count: uniqueNFTs.count,
            cover: .remote(cover),
            nftIDs: uniqueNFTs,
            author: author,
            website: website
        )
    }
}

extension Array where Element: Hashable {
    func uniquedPreservingOrder() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}
