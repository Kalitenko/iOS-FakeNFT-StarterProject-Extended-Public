//
//  FavoritesNFTView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 01/03/2026.
//
import SwiftUI

struct FavoritesNFTView: View {
    
    @State private var viewModel: FavoritesNFTViewModel
    
    private enum Layout {
        static let horizontalPadding: CGFloat = 16
        static let topPadding: CGFloat = 16
        static let bottomPadding: CGFloat = 16
        
        static let columnsSpacing: CGFloat = 8
        static let rowsSpacing: CGFloat = 20
    }
    
    private var columns: [GridItem] {
        [
            GridItem(.flexible(), spacing: Layout.columnsSpacing),
            GridItem(.flexible(), spacing: Layout.columnsSpacing)
        ]
    }
    
    init(viewModel: FavoritesNFTViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoaderTileView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.isEmpty {
                FavoritesEmptyView()
            } else {
                ScrollView {
                    LazyVGrid(
                        columns: columns,
                        spacing: Layout.rowsSpacing
                    ) {
                        ForEach(viewModel.favorites, id: \.id) { nft in
                            FavoriteNFTCell(
                                nft: nft,
                                isFavorite: viewModel.isLiked(nft.id)
                            ) {
                                Task {
                                    await viewModel.toggleLike(for: nft)
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
            await viewModel.loadFavorites()
        }
        .alert(
            L10n.Alerts.somethingWentWrong,
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )
        ) {
            Button(L10n.Alerts.okay, role: .cancel) {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}
