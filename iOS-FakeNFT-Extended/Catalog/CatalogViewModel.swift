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
    
    enum CatalogViewModelState {
        case loading
        case loaded([CatalogItem])
        case error(String)
    }
    
    let catalogService: CatalogServiceProtocol
    
    var state: CatalogViewModelState = .loading
        
    init(
        catalogService: CatalogServiceProtocol
    ) {
        self.catalogService = catalogService
    }
    
    func loadData() async {
        state = .loading
        do {
            let catalog = try await catalogService.fetchCatalog(page: 0, limit: 20)
            state = .loaded(catalog)
        } catch {
            print(error)
            state = .error(error.localizedDescription)
        }
    }
}

extension CatalogViewModel {
    static func mock() -> CatalogViewModel {
        CatalogViewModel(catalogService: MockCatalogService())
    }
}
