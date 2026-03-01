//
//  CatalogService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 17.02.2026.
//

import Foundation

protocol CatalogServiceProtocol: Sendable {
    func fetchCatalog(page: Int, limit: Int) async throws -> [CatalogItem]
    func fetchCollectionById(_ id: String) async throws -> CatalogItem
    func fetchNFTs(page: Int, limit: Int) async throws -> [CollectionItem]
    func fetchNFTById(_ id: String) async throws -> CollectionItem
}

actor CatalogService: CatalogServiceProtocol {
    
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchCatalog(page: Int, limit: Int) async throws -> [CatalogItem] {
        let request = CatalogRequest(pageNumber: page, pageSize: limit)
        let dto: [NFTCollectionDTO] = try await networkClient.send(request: request)
        return dto.map { $0.toDomain() }
    }
    
    func fetchCollectionById(_ id: String) async throws -> CatalogItem {
        let request = CollectionByIdRequest(id: id)
        let dto: NFTCollectionDTO = try await networkClient.send(request: request)
        return dto.toDomain()
    }
    
    func fetchNFTs(page: Int, limit: Int) async throws -> [CollectionItem] {
        let request = NFTSRequest(pageNumber: page, pageSize: limit)
        let dto: [NFTDTO] = try await networkClient.send(request: request)
        return dto.map { $0.toDomain() }
    }
    
    func fetchNFTById(_ id: String) async throws -> CollectionItem {
        let request = NFTByIdRequest(id: id)
        let dto: NFTDTO = try await networkClient.send(request: request)
        return dto.toDomain()
    }
}

final class MockCatalogService: CatalogServiceProtocol {
    
    func fetchCatalog(page: Int, limit: Int) async throws -> [CatalogItem] {
        MockData.Catalog.mockItems
    }
    
    func fetchCollectionById(_ id: String) async throws -> CatalogItem {
        MockData.Catalog.mock
    }
    
    func fetchNFTs(page: Int, limit: Int) async throws -> [CollectionItem] {
        MockData.Collections.mockItems
    }
    
    func fetchNFTById(_ id: String) async throws -> CollectionItem {
        MockData.Collections.mockIsNotLikedAndInCart
    }
}
