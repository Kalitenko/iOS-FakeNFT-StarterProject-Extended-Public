//
//  FavoritesNFTView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 01/03/2026.
//

import SwiftUI

struct FavoritesNFTView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(ServicesAssembly.self) private var services
    
    @State private var favorites: [NFTMock] = NFTMock.sampleFavoritesNFTs
    @State private var currentLikes: [String] = []
    @State private var isLoading = false
    
    private enum Layout {
        static let horizontalPadding: CGFloat = 16
        static let topPadding: CGFloat = 16
        static let bottomPadding: CGFloat = 16
        
        static let columnsSpacing: CGFloat = 8
        static let rowsSpacing: CGFloat = 20
        static let navBarLeadingInset: CGFloat = -7
    }
    
    private var isEmpty: Bool { favorites.isEmpty }
    
    private var columns: [GridItem] {
        [
            GridItem(.flexible(), spacing: Layout.columnsSpacing),
            GridItem(.flexible(), spacing: Layout.columnsSpacing)
        ]
    }
    
    var body: some View {
        Group {
            if isEmpty {
                FavoritesEmptyView()
            } else {
                ScrollView {
                    LazyVGrid(
                        columns: columns,
                        spacing: Layout.rowsSpacing
                    ) {
                        ForEach(favorites) { nft in
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
            await loadLikes()
        }
    }
    
    @MainActor
    private func loadLikes() async {
        do {
            let profileDTO = try await services.commonProfileService.fetchProfile()
            currentLikes = profileDTO.likes
        } catch {
            print("Failed to fetch likes:", error)
        }
    }
    
    @MainActor
    private func removeLike(for nft: NFTMock) async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        let updatedLikes = currentLikes.filter { $0 != nft.id.uuidString }
        
        do {
            let updatedProfile = try await services.commonProfileService.updateLikes(likes: updatedLikes)
            currentLikes = updatedProfile.likes
            favorites.removeAll { $0.id == nft.id }
        } catch {
            print("Failed to update likes:", error)
        }
    }
}
