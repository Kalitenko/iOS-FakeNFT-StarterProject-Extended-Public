//
//  FavoriteNFTCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 01/03/2026.
//

import SwiftUI

struct FavoriteNFTCell: View {
    
    let nft: NftDTOCart
    let onRemove: () -> Void
    
    private enum Layout {
        static let imageSize: CGFloat = 80
        static let imageCornerRadius: CGFloat = 12
        static let heartContainerSize: CGFloat = 42
        static let heartOuterInset: CGFloat = -5
        static let horizontalSpacing: CGFloat = 12
        static let verticalSpacing: CGFloat = 6
        static let rightBlockTopPadding: CGFloat = 7
        static let titleFontSize: CGFloat = 17
        static let titleLineHeight: CGFloat = 22
        static let priceFontSize: CGFloat = 15
        static let priceLineHeight: CGFloat = 20
        static let priceKerning: CGFloat = -0.24
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: Layout.horizontalSpacing) {
            
            ZStack(alignment: .topTrailing) {
                nftImage
                
                Button(action: onRemove) {
                    Image(.favoritesActive)
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: Layout.heartContainerSize, height: Layout.heartContainerSize)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(.top, Layout.heartOuterInset)
                .padding(.trailing, Layout.heartOuterInset)
            }
            
            VStack(alignment: .leading, spacing: Layout.verticalSpacing) {
                Text(nft.name)
                    .font(.system(size: Layout.titleFontSize, weight: .bold))
                    .foregroundStyle(Color(uiColor: .appTextPrimary))
                    .frame(height: Layout.titleLineHeight, alignment: .top)
                
                StarRatingView(rating: nft.rating)
                
                Text("\(nft.price.formattedETH) ETH")
                    .font(.system(size: Layout.priceFontSize, weight: .regular))
                    .kerning(Layout.priceKerning)
                    .foregroundStyle(Color(uiColor: .appTextPrimary))
                    .frame(height: Layout.priceLineHeight, alignment: .top)
            }
            .frame(height: Layout.imageSize, alignment: .top)
            .padding(.top, Layout.rightBlockTopPadding)
            
            Spacer(minLength: 0)
        }
    }
    
    @ViewBuilder
    private var nftImage: some View {
        if let imageURL = nft.images.first {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: Layout.imageSize, height: Layout.imageSize)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: Layout.imageSize, height: Layout.imageSize)
                case .failure:
                    Color.gray.opacity(0.2)
                        .frame(width: Layout.imageSize, height: Layout.imageSize)
                @unknown default:
                    Color.gray.opacity(0.2)
                        .frame(width: Layout.imageSize, height: Layout.imageSize)
                }
            }
            .clipShape(
                RoundedRectangle(cornerRadius: Layout.imageCornerRadius, style: .continuous)
            )
        } else {
            Color.gray.opacity(0.2)
                .frame(width: Layout.imageSize, height: Layout.imageSize)
                .clipShape(
                    RoundedRectangle(cornerRadius: Layout.imageCornerRadius, style: .continuous)
                )
        }
    }
}

extension Double {
    var formattedETH: String {
        self.formatted(
            .number
                .precision(.fractionLength(2))
                .locale(Locale(identifier: "ru_RU"))
        )
    }
}
