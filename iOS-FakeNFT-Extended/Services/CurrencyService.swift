//
//  CurrencyService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 18.02.2026.
//

import Foundation

protocol CurrencyService {
    func getCurrencies() async throws -> [CurrencyDTO]
}

actor CurrencyServiceImpl: CurrencyService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getCurrencies() async throws -> [CurrencyDTO] {
        let request = GetCurrenciesRequest()
        let currencies: [CurrencyDTO] = try await networkClient.send(request: request)
        return currencies
    }
}
