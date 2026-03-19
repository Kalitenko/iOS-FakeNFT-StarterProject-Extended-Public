//
//  CommonRequests.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 26.02.2026.
//

import Foundation

struct CommonGetOrderRequest: NetworkRequest, Sendable {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.apiURL)/orders/1")
    }
}

struct CommonPutOrderRequest: NetworkRequest, Sendable {
    
    let nftIDs: [String]
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.apiURL)/orders/1")
    }
    
    var httpMethod: HttpMethod { .put }
    
    var body: Data? {
        guard !nftIDs.isEmpty else { return nil }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "nfts", value: nftIDs.joined(separator: ","))
        ]
        
        return components.percentEncodedQuery?.data(using: .utf8)
    }
    
    var headers: [String: String]? {
        [RequestConstants.contentType: RequestConstants.urlencoded]
    }
}

struct CommonGetProfileRequest: NetworkRequest, Sendable {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.apiURL)/profile/1")
    }
}

//struct CommonPutProfileRequest: NetworkRequest, Sendable {
//    
//    let name: String
//    let avatar: String
//    let description: String
//    let website: String
//    let likes: [String]
//    
//    var endpoint: URL? {
//        URL(string: "\(RequestConstants.apiURL)/profile/1")
//    }
//    
//    var httpMethod: HttpMethod { .put }
//    
//    var body: Data? {
//        let likesValue = likes.isEmpty
//            ? RequestConstants.null
//            : likes.joined(separator: ",")
//
//        var components = URLComponents()
//        components.queryItems = [
//            URLQueryItem(name: "likes", value: likesValue)
//        ]
//        
//        return components.percentEncodedQuery?.data(using: .utf8)
//    }
//    
//    var headers: [String: String]? {
//        [RequestConstants.contentType: RequestConstants.urlencoded]
//    }
//}
