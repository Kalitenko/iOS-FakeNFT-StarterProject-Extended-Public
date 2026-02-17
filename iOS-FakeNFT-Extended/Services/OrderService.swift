//
//  OrderService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 17.02.2026.
//

protocol OrderService {
    func loadOrder() async throws -> OrderDTO
}

actor OrderServiceImpl: OrderService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadOrder() async throws -> OrderDTO {
        let request = GetOrderRequest()
        let order: OrderDTO = try await networkClient.send(request: request)
        return order
    }
}
