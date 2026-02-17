//
//  CartService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 17.02.2026.
//

import Foundation

protocol CartService {
    func loadCartItems() async throws -> [NFTModel]
}

actor CartServiceImpl: CartService {
    private let orderService: OrderService
    private let nftService: NftService

    init(orderService: OrderService, nftService: NftService) {
        self.orderService = orderService
        self.nftService = nftService
    }

    func loadCartItems() async throws -> [NFTModel] {
        let order = try await orderService.loadOrder()

        return try await withThrowingTaskGroup(of: NFTModel?.self) { group in
            for id in order.nfts {
                group.addTask { [nftService] in
                    let nft = try await nftService.loadNft(id: id)
                    return NFTModelMapper.map(nft)
                }
            }

            var items: [NFTModel] = []
            for try await item in group {
                if let item { items.append(item) }
            }

            items.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            return items
        }
    }
}
