import Foundation
import Observation

@Observable
@MainActor
final class FavoritesNFTViewModel {
    
    var favorites: [NftDTOCart] = []
    var isLoading = false
    var errorMessage: String?
    
    private let nftService: NftService
    private let likesStore: LikesStore
    
    init(
        nftService: NftService,
        likesStore: LikesStore
    ) {
        self.nftService = nftService
        self.likesStore = likesStore
    }
    
    var isEmpty: Bool {
        favorites.isEmpty && !isLoading
    }
    
    func loadFavorites() async {
        isLoading = true
        defer { isLoading = false }
        
        await likesStore.loadLikes()
        
        if let storeError = likesStore.errorMessage {
            errorMessage = storeError
            favorites = []
            return
        }
        
        do {
            let items = try await withThrowingTaskGroup(of: NftDTOCart.self) { group in
                for id in likesStore.likes {
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
    
    func isLiked(_ id: String) -> Bool {
        likesStore.contains(id)
    }

    func toggleLike(for nft: NftDTOCart) async {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        await likesStore.toggleLike(id: nft.id)
        
        if let storeError = likesStore.errorMessage {
            errorMessage = storeError
            return
        }
        
        errorMessage = nil
    }
}
