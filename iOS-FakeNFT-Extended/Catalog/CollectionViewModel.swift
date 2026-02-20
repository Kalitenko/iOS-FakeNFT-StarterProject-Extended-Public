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
    
    enum CollectionViewModelState {
        case loading
        case loaded([CollectionItem])
        case error(String)
    }
    
    var state: CollectionViewModelState = .loading
    
    private let catalogService: CatalogServiceProtocol
    
    let collectionInfo: CatalogItem
    
    private var items: [CollectionItem] = []
    
    init(
        catalogService: CatalogServiceProtocol,
        collectionInfo: CatalogItem
    ) {
        self.catalogService = catalogService
        self.collectionInfo = collectionInfo
    }
    
    func loadData() async {
        state = .loading
        do {
            try await loadNFTs()
            state = .loaded(items)
        } catch {
            print(error)
            state = .error(error.localizedDescription)
        }
    }

    func loadNFTs() async throws {
        try await withThrowingTaskGroup(of: CollectionItem.self) { group in
            
            for id in collectionInfo.nftIDs {
                group.addTask {
                    try await self.catalogService.fetchNFTById(id)
                }
            }
            
            var result: [CollectionItem] = []

            for try await item in group {
                result.append(item)
            }
            self.items = result
        }
    }
}

extension CollectionViewModel {
    static func mock() -> CollectionViewModel {
        CollectionViewModel(catalogService: MockCatalogService(), collectionInfo: MockData.Catalog.mock)
    }
}
