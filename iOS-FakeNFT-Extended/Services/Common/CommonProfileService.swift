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
    func updateProfile(profile: UpdateProfileDTO) async throws -> CommonProfileDTO
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

        let profile = UpdateProfileDTO(
            name: "",
            avatar: "",
            description: "",
            website: "",
            likes: likes
        )

        let request = CommonPutProfileRequest(profile: profile)

        return try await networkClient.send(request: request)
    }
    
    func updateProfile(profile: UpdateProfileDTO) async throws -> CommonProfileDTO {
        let request = CommonPutProfileRequest(profile: profile)
        return try await networkClient.send(request: request)
    }
}
