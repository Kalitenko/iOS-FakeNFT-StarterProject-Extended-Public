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
    
    private var image: some View {
        ZStack(alignment: .topTrailing) {
            rawImage
                .resizable()
                .scaledToFill()
                .frame(width: imageSize, height: imageSize)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(.appGrey)
            heart
        }
    }
    
    private var rawImage: Image {
        if let imageName = item.imageURLs.first {
            Image(imageName)
        } else {
            Image(systemName: "photo.fill")
        }
    }
    
    private var heart: some View {
        LikeButton(isFavorite: item.isFavorite,
                   action: { print("Like tapped. Item.name: \(self.item.name)") }
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
                    .font(.title)
                Text("\(item.price, format: .number) ETH")
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
                   action: { print("Add to cart tapped. Item.name: \(self.item.name)") }
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        CollectionCell(item: CollectionItem.mockItems[6])
            .padding(16)
            .border(.red)
        HStack(spacing: 4) {
            CollectionCell(item: CollectionItem.mockIsLikedAndInCart)
                .background(.green)
                .padding(8)
                .background(.yellow)
            CollectionCell(item: CollectionItem.mockIsNotLikedAndInCart)
                .border(.orange)
                .padding(8)
                .border(.red)
            CollectionCell(item: CollectionItem.mockWithoutImages)
                .border(.orange)
                .padding(8)
                .border(.red)
        }
    }
}
