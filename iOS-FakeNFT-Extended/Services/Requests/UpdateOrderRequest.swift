//
//  UpdateOrderRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 17.02.2026.
//

import Foundation

struct UpdateOrderRequest: NetworkRequest {
    let nftIDs: [String]

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }

    var httpMethod: HttpMethod { .put }

    var bodyData: Data? {
        guard !nftIDs.isEmpty else { return nil }
        let value = nftIDs.joined(separator: ",")
        let query = "nfts=\(value)"
        return query.data(using: .utf8)
    }

    var contentType: String? {
        return "application/x-www-form-urlencoded"
    }
}
