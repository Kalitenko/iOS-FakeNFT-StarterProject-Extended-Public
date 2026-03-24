//
//  FavoritesNFTViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 24/03/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class FavoritesNFTViewModel {
    
    var favorites: [NftDTOCart] = []
    var currentLikes: [String] = []
    var isLoading = false
    var errorMessage: String?
    
    private let commonProfileService: CommonProfileServiceProtocol
    private let nftService: NftService
    
    init(
        commonProfileService: CommonProfileServiceProtocol,
        nftService: NftService
    ) {
        self.commonProfileService = commonProfileService
        self.nftService = nftService
    }
    
    var isEmpty: Bool {
        favorites.isEmpty && !isLoading
    }
    
    func loadFavorites() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let profile = try await commonProfileService.fetchProfile()
            currentLikes = profile.likes
            
            let items = try await withThrowingTaskGroup(of: NftDTOCart.self) { group in
                for id in profile.likes {
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
            
            favorites = items
            errorMessage = nil
        } catch let error as URLError where error.code == .cancelled {
            return
        } catch {
            errorMessage = L10n.Alerts.dataLoadFailed
        }
    }
    
    func removeLike(for nft: NftDTOCart) async {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        let updatedLikes = currentLikes.filter { $0 != nft.id }
        
        do {
            let updatedProfile = try await commonProfileService.updateLikes(likes: updatedLikes)
            currentLikes = updatedProfile.likes
            favorites.removeAll { $0.id == nft.id }
            errorMessage = nil
        } catch let error as URLError where error.code == .cancelled {
            return
        } catch {
            errorMessage = L10n.Alerts.somethingWentWrong
        }
    }
}
