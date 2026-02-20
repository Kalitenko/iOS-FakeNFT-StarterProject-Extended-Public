//
//  CollectionViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 18.02.2026.
//

import Combine
import SwiftUI

@MainActor
@Observable
final class CollectionViewModel {
    
    private let catalogService: CatalogServiceProtocol
    
    let collectionInfo: CatalogItem
    
    var items: [CollectionItem] = []
    
    init(
        catalogService: CatalogServiceProtocol,
        collectionInfo: CatalogItem
    ) {
        self.catalogService = catalogService
        self.collectionInfo = collectionInfo
    }
    
    func loadData() async {
        do {
            items = try await catalogService.fetchNFTs(page: 0, limit: 20)
        } catch {
            print(error)
        }
    }
}

extension CollectionViewModel {
    static func mock() -> CollectionViewModel {
        CollectionViewModel(catalogService: MockCatalogService(), collectionInfo: MockData.Catalog.mock)
    }
}
