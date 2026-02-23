//
//  CartService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 17.02.2026.
//

import Foundation

protocol CartServiceProtocol {
    func loadCartItems() async throws -> [NFTModel]
    func updateCart(nftIDs: [String]) async throws -> OrderDTO
    func getCurrencies() async throws -> [CurrencyModel]
    func completeOrder(nftIDs: [String], currencyID: String) async throws -> Bool
}

actor CartService: CartServiceProtocol {
    private let orderService: OrderServiceProtocol
    private let currencyService: CurrencyServiceProtocol
    private let nftService: NftService
    private let paymentService: PaymentServiceProtocol

    init(
        orderService: OrderServiceProtocol,
        nftService: NftService,
        currencyService: CurrencyServiceProtocol,
        paymentService: PaymentServiceProtocol
    ) {
        self.orderService = orderService
        self.nftService = nftService
        self.currencyService = currencyService
        self.paymentService = paymentService
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

    func completeOrder(nftIDs: [String], currencyID: String) async throws -> Bool {
        guard !nftIDs.isEmpty else { return true }

        try await paymentService.completeOrder(nftIDs: nftIDs)

        let paymentResult = try await paymentService.makePayment(currencyID: currencyID)
        if paymentResult.success {
            _ = try await orderService.updateOrder(nftIDs: [])
            return true
        }

        return false
    }
}
