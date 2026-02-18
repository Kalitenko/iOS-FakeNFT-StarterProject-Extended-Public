//
//  NFTModelMapper.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 17.02.2026.
//
import Foundation

enum NFTModelMapper {
    static func map(_ nft: NftDTO) -> NFTModel? {
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
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.decimalSeparator = ","
        let number = formatter.string(from: NSNumber(value: value)) ?? "\(value)"
        return "\(number) ETH"
    }
}
