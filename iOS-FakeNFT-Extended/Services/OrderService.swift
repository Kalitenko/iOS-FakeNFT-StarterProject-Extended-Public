//
//  OrderService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 17.02.2026.
//

protocol OrderServiceProtocol {
    func loadOrder() async throws -> OrderDTO
    func updateOrder(nftIDs: [String]) async throws -> OrderDTO
}

actor OrderService: OrderServiceProtocol {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadOrder() async throws -> OrderDTO {
        let request = GetOrderRequest()
        let order: OrderDTO = try await networkClient.send(request: request)
        return order
    }

    func updateOrder(nftIDs: [String]) async throws -> OrderDTO {
        let request = UpdateOrderRequest(nftIDs: nftIDs)
        let order: OrderDTO = try await networkClient.send(request: request)
        return order
    }
}
