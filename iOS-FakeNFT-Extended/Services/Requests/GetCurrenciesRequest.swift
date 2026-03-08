//
//  GetCurrenciesRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 18.02.2026.
//

import Foundation

struct GetCurrenciesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
}
