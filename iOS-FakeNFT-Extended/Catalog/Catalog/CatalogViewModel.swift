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
    
    enum CatalogError {
        case loading
        case generic
    }
    
    enum SortType: String {
        case byTitle
        case byNFTCount
    }
    
    let catalogService: CatalogServiceProtocol
    
    private var currentPage = 0
    private let limit = 20
    private var canLoadMore = true
    
    var items: [CatalogItem] = []
    var isLoading = true
    var isLoadingMore = false
    var screenError: CatalogError?
    
    private var allItems: [CatalogItem] = []
    private let storage: SettingsStorageProtocol
    private var sortType: SortType
    
    init(catalogService: CatalogServiceProtocol) {
        self.catalogService = catalogService
        self.storage = UserDefaultsStorage.shared
        self.sortType = .byNFTCount
    }
    
    func prepare() async {
        await loadSortType()
        await loadInitial()
    }
    
    func loadInitial() async {
        isLoading = true
        currentPage = 0
        canLoadMore = true
        
        do {
            let fetchedItems = try await catalogService.fetchCatalog(page: 0, limit: limit)
            allItems = fetchedItems
            items = sort(allItems)
            currentPage += 1
            isLoading = false
        } catch let error as NetworkClientError {
            items = []
            isLoading = false
            screenError = map(error)
        } catch {
            items = []
            isLoading = false
            screenError = .generic
        }
    }
    
    func loadMore() async {
        guard canLoadMore, !isLoadingMore else { return }
        isLoadingMore = true
        
        do {
            let newItems = try await catalogService.fetchCatalog(page: currentPage, limit: limit)
            if newItems.isEmpty {
                canLoadMore = false
            } else {
                currentPage += 1
                allItems.append(contentsOf: newItems)
                let sortedNewItems = sort(newItems)
                items.append(contentsOf: sortedNewItems)
            }
        } catch let error as NetworkClientError {
            screenError = map(error)
        } catch {
            screenError = .generic
        }
        
        isLoadingMore = false
    }
    
    func changeSort(to newSort: SortType) async {
        sortType = newSort
        items = sort(allItems)
        await storage.set(sortType.rawValue, forKey: .catalogSort)
    }
    
    private func loadSortType() async {
        if let saved = await storage.get(forKey: .catalogSort),
           let type = SortType(rawValue: saved) {
            sortType = type
        }
    }
    
    private func sort(_ items: [CatalogItem]) -> [CatalogItem] {
        switch sortType {
        case .byTitle:
            return items.sorted { $0.name < $1.name }
        case .byNFTCount:
            return items.sorted { $0.count > $1.count }
        }
    }
    
    private func map(_ error: NetworkClientError) -> CatalogError {
        switch error {
        case .urlSessionError, .urlRequestError, .httpStatusCode:
            return .loading
        case .parsingError, .incorrectRequest:
            return .generic
        }
    }
}
