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
    
    enum State {
        case loading
        case loaded([CatalogItem])
        case loadingMore([CatalogItem])
        case error(String)
    }
    
    enum SortType: String {
        case byTitle
        case byNFTCount
    }
    
    let catalogService: CatalogServiceProtocol
    
    private var currentPage = 0
    private let limit = 20
    private var canLoadMore = true
    
    var state: State = .loading
    
    private var allItems: [CatalogItem] = []
    private let storage: SettingsStorageProtocol
    private var sortType: SortType {
        didSet { storage.set(sortType.rawValue, forKey: .catalogSort) }
    }
    
    init(catalogService: CatalogServiceProtocol) {
        self.catalogService = catalogService
        self.storage = UserDefaultsStorage.shared
        
        if let saved = storage.get(forKey: .catalogSort),
           let type = SortType(rawValue: saved) {
            self.sortType = type
        } else {
            self.sortType = .byNFTCount
        }
    }
    
    func loadInitial() async {
        state = .loading
        currentPage = 0
        canLoadMore = true
        
        do {
            let items = try await catalogService.fetchCatalog(page: 0, limit: limit)
            allItems = items
            currentPage += 1
            state = .loaded(sort(allItems))
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func loadMore() async {
        guard canLoadMore else { return }
        
        guard case .loaded(let currentItems) = state else { return }
        
        state = .loadingMore(currentItems)
        
        do {
            let newItems = try await catalogService.fetchCatalog(
                page: currentPage,
                limit: limit
            )
            
            if newItems.isEmpty {
                canLoadMore = false
                state = .loaded(sort(allItems))
            } else {
                currentPage += 1
                allItems.append(contentsOf: newItems)
                state = .loaded(sort(allItems))
            }
            
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func changeSort(to newSort: SortType) {
        sortType = newSort
        state = .loaded(sort(allItems))
    }
    
    private func sort(_ items: [CatalogItem]) -> [CatalogItem] {
        switch sortType {
        case .byTitle:
            return items.sorted { $0.name < $1.name }
            
        case .byNFTCount:
            return items.sorted { $0.count > $1.count }
        }
    }
}

extension CatalogViewModel {
    static func mock() -> CatalogViewModel {
        CatalogViewModel(catalogService: MockCatalogService())
    }
}
