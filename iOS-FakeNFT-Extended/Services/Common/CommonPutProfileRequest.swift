//
//  CommonPutProfileRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 15/03/2026.
//

import Foundation

struct CommonPutProfileRequest: NetworkRequest, Sendable {
    
    let profile: UpdateProfileDTO
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.apiURL)/profile/1")
    }
    
    var httpMethod: HttpMethod { .put }
    
    var body: Data? {
        let likesValue = profile.likes.isEmpty
            ? RequestConstants.null
            : profile.likes.joined(separator: ",")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "name", value: profile.name),
            URLQueryItem(name: "avatar", value: profile.avatar),
            URLQueryItem(name: "description", value: profile.description),
            URLQueryItem(name: "website", value: profile.website),
            URLQueryItem(name: "likes", value: likesValue)
        ]
        
        return components.percentEncodedQuery?.data(using: .utf8)
    }
    
    var headers: [String: String]? {
        [RequestConstants.contentType: RequestConstants.urlencoded]
    }
}
