//
//  PurchaseRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 19.02.2026.
//

import Foundation

struct PurchaseRequest: NetworkRequest {

    let currencyID: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(currencyID)")
    }
}
