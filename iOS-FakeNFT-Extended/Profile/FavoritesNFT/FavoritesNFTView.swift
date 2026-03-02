//
//  FavoritesNFTView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 01/03/2026.
//

import SwiftUI

struct FavoritesNFTView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var favorites: [NFTMock] = NFTMock.sampleFavoritesNFTs
/*    @State private var favorites: [NFTMock] = []*/   //  для проверки empty

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
                        LazyVGrid(columns: columns, alignment: .center, spacing: Layout.rowsSpacing) {
                            ForEach(favorites) { nft in
                                // временно заглушка, чтобы проверить сетку
                                FavoriteNFTCell(nft: nft) {
                                    favorites.removeAll { $0.id == nft.id }
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
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: {
                        Image("back.chevron")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .foregroundStyle(Color(uiColor: .appTextPrimary))
                            .frame(width: 44, height: 44, alignment: .leading)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .padding(.leading, Layout.navBarLeadingInset) 
                }

                ToolbarItem(placement: .principal) {
                    Text("Избранные NFT")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color(uiColor: .appTextPrimary))
                }
            }
        }
    }

    // MARK: - временная заглушка ячейки (чтобы проверить сетку)
    private struct FavoriteNFTCellStub: View {
        let nft: NFTMock

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Image(nft.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                Text(nft.name)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color(uiColor: .appTextPrimary))

                Text("\(nft.priceFormattedRu) ETH")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Color(uiColor: .appTextPrimary))
            }
        }
    }

    #Preview("Favorites Grid") {
        NavigationStack {
            FavoritesNFTView()
        }
    }
