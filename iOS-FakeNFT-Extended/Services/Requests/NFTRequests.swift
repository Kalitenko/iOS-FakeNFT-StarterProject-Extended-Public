//
//  NFTRequests.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 16.02.2026.
//

import Foundation

struct NFTSRequest: NetworkRequest, Sendable {
    
    let pageNumber: Int
    let pageSize: Int
    
    init(pageNumber: Int = .zero, pageSize: Int = 15) {
        self.pageNumber = pageNumber
        self.pageSize = pageSize
    }
    
    var endpoint: URL? {
        var components = URLComponents(string: "\(RequestConstants.apiURL)/nft")
        components?.queryItems = [
            URLQueryItem(name: "\(RequestConstants.page)", value: "\(pageNumber)"),
            URLQueryItem(name: "\(RequestConstants.size)", value: "\(pageSize)")
        ]
        return components?.url
    }
}

struct NFTByIdRequest: NetworkRequest, Sendable {
    
    let id: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.apiURL)/nft/\(id)")
    }
}
