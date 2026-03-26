//
//  MyNFTsViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 24/03/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class MyNFTsViewModel {
    
    enum NFTSortType: String {
        case price
        case rating
        case name
    }
    
    var isLoading = false
    var errorMessage: String?
    var nfts: [NftDTOCart] = []
    
    var sort: NFTSortType {
        didSet {
            sortSettingsService.save(sort: sort)
        }
    }
    
    private let commonProfileService: CommonProfileServiceProtocol
    private let nftService: NftService
    private let likesStore: LikesStore
    private let sortSettingsService: SortSettingsService
    
    init(
        commonProfileService: CommonProfileServiceProtocol,
        nftService: NftService,
        likesStore: LikesStore,
        sortSettingsService: SortSettingsService
    ) {
        self.commonProfileService = commonProfileService
        self.nftService = nftService
        self.likesStore = likesStore
        self.sortSettingsService = sortSettingsService
        self.sort = sortSettingsService.load()
    }
    
    var sortedNfts: [NftDTOCart] {
        switch sort {
        case .price:
            nfts.sorted { $0.price < $1.price }
        case .rating:
            nfts.sorted { $0.rating > $1.rating }
        case .name:
            nfts.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        }
    }
    
    var isEmpty: Bool {
        !isLoading && sortedNfts.isEmpty
    }
    
    func isLiked(_ id: String) -> Bool {
        likesStore.contains(id)
    }
    
    func loadMyNFTs() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let profile = try await commonProfileService.fetchProfile()
            await likesStore.loadLikes()
            
            let items = try await withThrowingTaskGroup(of: NftDTOCart.self) { group in
                for id in profile.nfts {
                    group.addTask {
                        try await self.nftService.loadNft(id: id)
                    }
                }
                
                var loaded: [NftDTOCart] = []
                for try await item in group {
                    loaded.append(item)
                }
                return loaded
            }
            
            nfts = items
            errorMessage = likesStore.errorMessage
        } catch let error where error.isCancelled {
            return
        } catch {
            errorMessage = L10n.Alerts.dataLoadFailed
        }
    }
}
