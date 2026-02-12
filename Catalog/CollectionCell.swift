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
    private let iconContainerSize: CGFloat = 40
    
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
        HStack {
            Image(item.isFavorite ? .favoritesActive : .favoritesInactive)
                .foregroundStyle(item.isFavorite ? .appRed : .appWhite)
        }
        .frame(width: iconContainerSize, height: iconContainerSize)
    }
    
    private var bottom: some View {
        VStack(alignment: .leading, spacing: 4) {
            StarRatingView(rating: item.rating)
            caption
        }
    }
    
    private var caption: some View {
        HStack {
            VStack(spacing: 4) {
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
        HStack {
            Image(item.isInCart ? .cartRemove : .cartAdd)
        }
        .frame(width: iconContainerSize, height: iconContainerSize)
    }
}

#Preview {
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
