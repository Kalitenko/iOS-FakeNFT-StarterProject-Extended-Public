//
//  FavoritesNFTView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 01/03/2026.
//

import SwiftUI

struct FavoritesNFTView: View {
    
    @Environment(ServicesAssembly.self) private var services
    
    @State private var favorites: [NftDTOCart] = []
    @State private var currentLikes: [String] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    private enum Layout {
        static let horizontalPadding: CGFloat = 16
        static let topPadding: CGFloat = 16
        static let bottomPadding: CGFloat = 16
        
        static let columnsSpacing: CGFloat = 8
        static let rowsSpacing: CGFloat = 20
    }
    
    private var isEmpty: Bool { favorites.isEmpty && !isLoading }
    
    private var columns: [GridItem] {
        [
            GridItem(.flexible(), spacing: Layout.columnsSpacing),
            GridItem(.flexible(), spacing: Layout.columnsSpacing)
        ]
    }
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if isEmpty {
                FavoritesEmptyView()
            } else {
                ScrollView {
                    LazyVGrid(
                        columns: columns,
                        spacing: Layout.rowsSpacing
                    ) {
                        ForEach(favorites, id: \.id) { nft in
                            FavoriteNFTCell(nft: nft) {
                                Task {
                                    await removeLike(for: nft)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, Layout.horizontalPadding)
                    .padding(.top, Layout.topPadding)
                    .padding(.bottom, Layout.bottomPadding)
                }
            }
        }
        .background(Color(uiColor: .systemBackground))
        .toolbar(.hidden, for: .tabBar)
        .customNavigationBar(title: L10n.Profile.favoriteNFT)
        .task {
            await loadFavorites()
        }
        .alert(
            L10n.Alerts.somethingWentWrong,
            isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )
        ) {
            Button(L10n.Alerts.okay, role: .cancel) {
                errorMessage = nil
            }
        } message: {
            Text(errorMessage ?? "")
        }
    }
    
    @MainActor
    private func loadFavorites() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let profile = try await services.commonProfileService.fetchProfile()
            currentLikes = profile.likes
            
            let items = try await withThrowingTaskGroup(of: NftDTOCart.self) { group in
                for id in profile.likes {
                    group.addTask {
                        try await services.nftService.loadNft(id: id)
                    }
                }
                
                var loaded: [NftDTOCart] = []
                for try await item in group {
                    loaded.append(item)
                }
                return loaded
            }
            
            favorites = items
        } catch let error as URLError where error.code == .cancelled {
            return
        } catch {
            errorMessage = L10n.Alerts.dataLoadFailed
        }
    }
    
    @MainActor
    private func removeLike(for nft: NftDTOCart) async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        let updatedLikes = currentLikes.filter { $0 != nft.id }
        
        do {
            let updatedProfile = try await services.commonProfileService.updateLikes(likes: updatedLikes)
            currentLikes = updatedProfile.likes
            favorites.removeAll { $0.id == nft.id }
        } catch let error as URLError where error.code == .cancelled {
            return
        } catch {
            errorMessage = L10n.Alerts.somethingWentWrong
        }
    }
}
