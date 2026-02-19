//
//  CollectionCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 10.02.2026.
//

import SwiftUI

struct CollectionCell: View {
    
    let item: CollectionItem
    private let imageSize: CGFloat = 108
    
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
                   action: { print("Like tapped. Item.name: \(item.name)") }
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
                   action: { print("Add to cart tapped. Item.name: \(item.name)") }
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        CollectionCell(item: MockData.Collections.mockItems[6])
            .padding(16)
            .border(.red)
        HStack(spacing: 4) {
            CollectionCell(item: MockData.Collections.mockIsLikedAndInCart)
                .background(.green)
                .padding(8)
                .background(.yellow)
            CollectionCell(item: MockData.Collections.mockIsNotLikedAndInCart)
                .border(.orange)
                .padding(8)
                .border(.red)
            CollectionCell(item: MockData.Collections.mockWithoutImages)
                .border(.orange)
                .padding(8)
                .border(.red)
        }
    }
}
