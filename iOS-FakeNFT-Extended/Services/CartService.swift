//
//  CartService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 17.02.2026.
//

import Foundation

protocol CartService {
    func loadCartItems() async throws -> [NFTModel]
    func updateCart(nftIDs: [String]) async throws -> OrderDTO
    func getCurrencies() async throws -> [CurrencyModel]
}

actor CartServiceImpl: CartService {
    private let orderService: OrderService
    private let currencyService: CurrencyService
    private let nftService: NftService

    init(orderService: OrderService, nftService: NftService, currencyService: CurrencyService) {
        self.orderService = orderService
        self.nftService = nftService
        self.currencyService = currencyService
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

    func updateCart(nftIDs: [String]) async throws -> OrderDTO {
        try await orderService.updateOrder(nftIDs: nftIDs)
    }

    func getCurrencies() async throws -> [CurrencyModel] {
        let items = try await currencyService.getCurrencies()
        var models = [CurrencyModel]()

        for item in items {
             if let model = CurrencyModel(
                id: item.id,
                title: item.title,
                name: item.name,
                imageURLString: item.image
             ) { models.append(model) }
        }

        return models
    }
}
