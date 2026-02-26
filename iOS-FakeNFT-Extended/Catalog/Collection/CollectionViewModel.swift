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
        try await withThrowingTaskGroup(of: (Int, CollectionItem).self) { group in
            
            for (index, id) in collectionInfo.nftIDs.enumerated() {
                group.addTask {
                    let item = try await self.catalogService.fetchNFTById(id)
                    return (index, item)
                }
            }
            
            var result = [CollectionItem?](
                repeating: nil,
                count: collectionInfo.nftIDs.count
            )
            
            for try await (index, item) in group {
                result[index] = item
            }
            
            self.items = result.compactMap { $0 }
        }
    }
}

extension CollectionViewModel {
    static func mock() -> CollectionViewModel {
        CollectionViewModel(catalogService: MockCatalogService(), collectionInfo: MockData.Catalog.mock)
    }
}
