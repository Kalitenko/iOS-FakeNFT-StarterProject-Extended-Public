//
//  CatalogViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 17.02.2026.
//

import Combine
import SwiftUI

@MainActor
@Observable
final class CatalogViewModel {
    
    let catalogService: CatalogServiceProtocol
    
    var catalog: [CatalogItem] = []
    
    init(
        catalogService: CatalogServiceProtocol
    ) {
        self.catalogService = catalogService
    }
    
    func loadData() async {
        do {
            catalog = try await catalogService.fetchCatalog(page: 0, limit: 20)
        } catch {
            print(error)
        }
    }
}

extension CatalogViewModel {
    static func mock() -> CatalogViewModel {
        CatalogViewModel(catalogService: MockCatalogService())
    }
}
