//
//  CommonOrderService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 27.02.2026.
//

import Foundation

protocol CommonOrderServiceProtocol: Sendable {
    func getOrder() async throws -> CommonOrderDTO
    func updateOrder(nftIDs: [String]) async throws -> CommonOrderDTO
}

actor CommonOrderService: CommonOrderServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getOrder() async throws -> CommonOrderDTO {
        let request = CommonGetOrderRequest()
        return try await networkClient.send(request: request)
    }
    
    func updateOrder(nftIDs: [String]) async throws -> CommonOrderDTO {
        let request = CommonPutOrderRequest(nftIDs: nftIDs)
        return try await networkClient.send(request: request)
    }
}

final class MockOrderService: CommonOrderServiceProtocol {
    func getOrder() async throws -> CommonOrderDTO {
        CommonOrderDTO(nfts: [])
    }
    
    func updateOrder(nftIDs: [String]) async throws -> CommonOrderDTO {
        CommonOrderDTO(nfts: [])
    }
}
