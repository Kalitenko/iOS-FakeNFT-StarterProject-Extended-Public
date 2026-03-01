//
//  CommonProfileService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 27.02.2026.
//

import Foundation

protocol CommonProfileServiceProtocol: Sendable {
    func fetchProfile() async throws -> CommonProfileDTO
    func updateLikes(likes: [String]) async throws -> CommonProfileDTO
}

actor CommonProfileService: CommonProfileServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchProfile() async throws -> CommonProfileDTO {
        let request = CommonGetProfileRequest()
        return try await networkClient.send(request: request)
    }
    
    func updateLikes(likes: [String]) async throws -> CommonProfileDTO {
        let request = CommonPutProfileRequest(likes: likes)
        return try await networkClient.send(request: request)
    }
}

final class MockProfileService: CommonProfileServiceProtocol {
    func fetchProfile() async throws -> CommonProfileDTO {
        CommonProfileDTO(likes: [])
    }
    
    func updateLikes(likes: [String]) async throws -> CommonProfileDTO {
        CommonProfileDTO(likes: [])
    }
}
