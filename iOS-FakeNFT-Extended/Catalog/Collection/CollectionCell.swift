//
//  CollectionCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 10.02.2026.
//

import SwiftUI

struct CollectionCell: View {
    
    let item: CollectionItem
    let onLikeTap: () -> Void
    let onCartTap: () -> Void
    private let imageSize: CGFloat = 108
    
    init(
        item: CollectionItem,
        onLikeTap: @escaping () -> Void = { print("Like tapped.") },
        onCartTap: @escaping () -> Void = { print("Cart tapped.") }
    ) {
        self.item = item
        self.onLikeTap = onLikeTap
        self.onCartTap = onCartTap
    }
    
    var body: some View {
        VStack {
            image
            bottom
        }
    }
    
    var firstImage: ImageSource {
        item.imagesUrlsStrings.first ?? .empty
    }
    
    private var image: some View {
        ZStack(alignment: .topTrailing) {
            AppImageView(
                source: firstImage,
                size: CGSize(width: imageSize, height: imageSize)
            )
            .frame(width: imageSize, height: imageSize)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaledToFill()
            .frame(width: imageSize, height: imageSize)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            heart
        }
    }
    
    private var heart: some View {
        LikeButton(isFavorite: item.isFavorite,
                   action: { onLikeTap() }
        )
    }
    
    private var bottom: some View {
        VStack(alignment: .leading, spacing: 4) {
            StarRatingView(rating: item.rating)
            caption
        }
    }
    
    private var caption: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .font(.title)
                Text("\(item.price, format: .number) ETH")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .font(.description)
            }
            Spacer()
            cart
        }
        .frame(width: imageSize)
        .foregroundStyle(.appTextPrimary)
    }
    
    private var cart: some View {
        CartButton(isInCart: item.isInCart,
                   action: { onCartTap() }
        )
    }
}
