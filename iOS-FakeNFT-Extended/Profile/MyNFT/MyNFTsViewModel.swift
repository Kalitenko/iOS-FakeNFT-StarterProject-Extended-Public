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
    
    enum Sort {
        case price
        case rating
        case name
    }
    
    var isLoading = false
    var errorMessage: String?
    var nfts: [NftDTOCart] = []
    var sort: Sort = .name
    
    private let commonProfileService: CommonProfileServiceProtocol
    private let nftService: NftService
    
    init(
        commonProfileService: CommonProfileServiceProtocol,
        nftService: NftService
    ) {
        self.commonProfileService = commonProfileService
        self.nftService = nftService
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
    
    func loadMyNFTs() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let profile = try await commonProfileService.fetchProfile()
            
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
            errorMessage = nil
        } catch let error as URLError where error.code == .cancelled {
            return
        } catch {
            errorMessage = L10n.Alerts.dataLoadFailed
        }
    }
}
