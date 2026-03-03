//
//  NFTModelMapper.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 17.02.2026.
//
import Foundation

enum NFTModelMapper {
    static func map(_ nft: NftDTOCart) -> NFTModel? {
        guard let firstImage = nft.images.first else { return nil }

        return NFTModel(
            id: nft.id,
            name: nft.name,
            price: formatETH(nft.price),
            rating: nft.rating,
            imageURL: firstImage
        )
    }

    private static func formatETH(_ value: Double) -> String {
        let formatter = NumberFormatterManager.formatter
        let number = formatter.string(from: NSNumber(value: value)) ?? "\(value)"
        return "\(number) ETH"
    }
}
