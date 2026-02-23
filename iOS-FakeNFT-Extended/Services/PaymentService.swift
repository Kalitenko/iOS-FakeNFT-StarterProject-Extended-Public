//
//  PaymentService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 18.02.2026.
//

import Foundation

protocol PaymentServiceProtocol {
    func completeOrder(nftID: String) async throws
    func completeOrder(nftIDs: [String]) async throws
    func makePayment(currencyID: String) async throws -> PaymentDTO
}

actor PaymentService: PaymentServiceProtocol {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func completeOrder(nftID: String) async throws {
        let request = CompleteOrderRequest(nftID: nftID)
        _ = try await networkClient.send(request: request)
    }
    
    func completeOrder(nftIDs: [String]) async throws {
        guard !nftIDs.isEmpty else { return }

        for id in nftIDs {
            try await completeOrder(nftID: id)
        }
    }

    func makePayment(currencyID: String) async throws -> PaymentDTO {
        let request = PurchaseRequest(currencyID: currencyID)
        let paymentResult: PaymentDTO = try await networkClient.send(request: request)
        return paymentResult
    }
}
