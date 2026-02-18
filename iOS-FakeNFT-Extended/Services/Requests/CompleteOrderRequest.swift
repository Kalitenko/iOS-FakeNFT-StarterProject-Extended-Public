//
//  CompleteOrderRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 18.02.2026.
//

import Foundation

struct CompleteOrderRequest: NetworkRequest {
    let nftID: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }

    var httpMethod: HttpMethod { .post }

    var bodyData: Data? {
        let encodedID = nftID.formURLEncodedComponent()
        let query = "nfts=\(encodedID)"
        return query.data(using: .utf8)
    }
}

private extension String {
    func formURLEncodedComponent() -> String {
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "&+=?")
        return addingPercentEncoding(withAllowedCharacters: allowed) ?? self
    }
}
