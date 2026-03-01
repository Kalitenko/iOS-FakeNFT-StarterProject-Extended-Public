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
    }
    
    enum CollectionError {
        case loadFailed
        case likeFailed
        case cartFailed
    }
    
    var state: CollectionViewModelState = .loading
    var screenError: CollectionError?
    
    private let catalogService: CatalogServiceProtocol
    private let profileService: CommonProfileServiceProtocol
    private let orderService: CommonOrderServiceProtocol
    
    let collectionInfo: CatalogItem
    var authorURL: URL? {
        makeURL(from: collectionInfo.website)
    }
    
    private var items: [CollectionItem] = []
    private var cartItems: [String] = []
    private var likes: [String] = []
    
    init(
        catalogService: CatalogServiceProtocol,
        profileService: CommonProfileServiceProtocol,
        orderService: CommonOrderServiceProtocol,
        collectionInfo: CatalogItem
    ) {
        self.catalogService = catalogService
        self.profileService = profileService
        self.orderService = orderService
        self.collectionInfo = collectionInfo
    }
    
    func loadData() async {
        state = .loading
        do {
            try await loadCartAndLikes()
            try await loadNFTs()
            state = .loaded(items)
        } catch {
            state = .loaded([])
            screenError = .loadFailed
        }
    }
    
    private func loadCartAndLikes() async throws {
        cartItems = try await orderService.getOrder().nfts
        likes = try await profileService.fetchProfile().likes
    }
    
    private func loadNFTs() async throws {
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
            
            let loadedItems = result.compactMap { $0 }
            
            self.items = loadedItems.map {
                $0.enriched(
                    isFavorite: likes.contains($0.id),
                    isInCart: cartItems.contains($0.id)
                )
            }
        }
    }
    
    func toggleLike(for itemID: String) {
        guard case .loaded = state else { return }
        
        let wasLiked = likes.contains(itemID)
        
        if wasLiked {
            likes.removeAll { $0 == itemID }
        } else {
            likes.append(itemID)
        }
        
        updateItem(itemID) { item in
            item.enriched(
                isFavorite: !wasLiked,
                isInCart: item.isInCart
            )
        }
        
        Task {
            do {
                _ = try await profileService.updateLikes(likes: likes)
            } catch {
                if wasLiked {
                    likes.append(itemID)
                } else {
                    likes.removeAll { $0 == itemID }
                }
                
                updateItem(itemID) { item in
                    item.enriched(
                        isFavorite: wasLiked,
                        isInCart: item.isInCart
                    )
                }
                screenError = .likeFailed
            }
        }
    }
    
    func toggleCart(for itemID: String) {
        guard case .loaded = state else { return }
        
        let wasInCart = cartItems.contains(itemID)
        
        if wasInCart {
            cartItems.removeAll { $0 == itemID }
        } else {
            cartItems.append(itemID)
        }
        
        updateItem(itemID) { item in
            item.enriched(
                isFavorite: item.isFavorite,
                isInCart: !wasInCart
            )
        }
        
        Task {
            do {
                _ = try await orderService.updateOrder(nftIDs: cartItems)
            } catch {
                if wasInCart {
                    cartItems.append(itemID)
                } else {
                    cartItems.removeAll { $0 == itemID }
                }
                
                updateItem(itemID) { item in
                    item.enriched(
                        isFavorite: item.isFavorite,
                        isInCart: wasInCart
                    )
                }
                screenError = .cartFailed
            }
        }
    }
    
    private func updateItem(
        _ id: String,
        transform: (CollectionItem) -> CollectionItem
    ) {
        guard case .loaded(var currentItems) = state else { return }
        
        if let index = currentItems.firstIndex(where: { $0.id == id }) {
            currentItems[index] = transform(currentItems[index])
            items = currentItems
            state = .loaded(currentItems)
        }
    }
    
    private func enrich(_ item: CollectionItem) -> CollectionItem {
        CollectionItem(
            id: item.id,
            name: item.name,
            imageURLs: item.imagesUrlsStrings,
            rating: item.rating,
            price: item.price,
            isFavorite: likes.contains(item.id),
            isInCart: cartItems.contains(item.id)
        )
    }
    
    private func makeURL(from string: String) -> URL? {
        if string.hasPrefix("http://") || string.hasPrefix("https://") {
            return URL(string: string)
        } else {
            return URL(string: "https://\(string)")
        }
    }
}

extension CollectionViewModel {
    static func mock() -> CollectionViewModel {
        CollectionViewModel(catalogService: MockCatalogService(),
                            profileService: MockProfileService(),
                            orderService: MockOrderService(),
                            collectionInfo: MockData.Catalog.mock)
    }
}
