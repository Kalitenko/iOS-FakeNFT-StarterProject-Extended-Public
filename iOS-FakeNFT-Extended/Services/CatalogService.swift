//
//  CatalogService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 17.02.2026.
//

import Foundation

protocol CatalogServiceProtocol: Sendable {
    func fetchCatalog(page: Int, limit: Int) async throws -> [NFTCollectionDTO]
    func fetchCollectionById(_ id: String) async throws -> NFTCollectionDTO
    func fetchNFTs(page: Int, limit: Int) async throws -> [NFTDTO]
    func fetchNFTById(_ id: String) async throws -> NFTDTO
}

@MainActor
final class CatalogService: CatalogServiceProtocol {
    
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchCatalog(page: Int, limit: Int) async throws -> [NFTCollectionDTO] {
        let request = CatalogRequest(pageNumber: page, pageSize: limit)
        return try await networkClient.send(request: request)
    }
    
    func fetchCollectionById(_ id: String) async throws -> NFTCollectionDTO {
        let request = CollectionByIdRequest(id: id)
        return try await networkClient.send(request: request)
    }
    
    func fetchNFTs(page: Int, limit: Int) async throws -> [NFTDTO] {
        let request = NFTSRequest(pageNumber: page, pageSize: limit)
        return try await networkClient.send(request: request)
    }
    
    func fetchNFTById(_ id: String) async throws -> NFTDTO {
        let request = NFTByIdRequest(id: id)
        return try await networkClient.send(request: request)
    }
}
