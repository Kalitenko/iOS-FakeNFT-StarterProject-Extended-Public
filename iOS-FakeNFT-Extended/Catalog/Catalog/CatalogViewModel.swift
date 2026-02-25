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

    let catalogService: CatalogServiceProtocol

    private var currentPage = 0
    private let limit = 20
    private var canLoadMore = true

    var state: State = .loading

    init(catalogService: CatalogServiceProtocol) {
        self.catalogService = catalogService
    }

    func loadInitial() async {
        state = .loading
        currentPage = 0
        canLoadMore = true

        do {
            let items = try await catalogService.fetchCatalog(page: 0, limit: limit)
            currentPage += 1
            state = .loaded(items)
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
                state = .loaded(currentItems)
            } else {
                currentPage += 1
                state = .loaded(currentItems + newItems)
            }

        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

extension CatalogViewModel {
    static func mock() -> CatalogViewModel {
        CatalogViewModel(catalogService: MockCatalogService())
    }
}
