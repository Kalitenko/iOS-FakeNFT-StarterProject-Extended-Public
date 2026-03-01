//
//  MyNFTCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 27/02/2026.
//
import SwiftUI

struct MyNFTCell: View {
    let nft: NFTMock
    
    private enum Layout {
        static let rowHeight: CGFloat = 140
        static let horizontalPadding: CGFloat = 16
        static let spacing: CGFloat = 16
        
        static let imageSize: CGFloat = 108
        static let imageCornerRadius: CGFloat = 12
        
        static let likeSize: CGFloat = 24
        static let likePadding: CGFloat = 8
        
        static let starsSize: CGFloat = 12
        static let starsSpacing: CGFloat = 2
        
        static let contentWidth: CGFloat = 320
        static let priceBlockWidth: CGFloat = 75
        static let heartContainerSize: CGFloat = 42
    }
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: Layout.spacing) {
                
                ZStack {
                    Image(nft.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: Layout.imageSize, height: Layout.imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: Layout.imageCornerRadius, style: .continuous))
                }
                .overlay(alignment: .topTrailing) {
                    Image("favorites.inactive")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.appWhite)
                        .frame(width: 42, height: 42)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(nft.name)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color(uiColor: .appTextPrimary))
                        .frame(height: 22, alignment: .top)
                    
                    HStack(spacing: Layout.starsSpacing) {
                        ForEach(0..<5, id: \.self) { ratingStarIndex in
                            Image(ratingStarIndex < nft.rating ? "starFilled" : "starEmpty")
                                .resizable()
                                .scaledToFit()
                                .frame(width: Layout.starsSize, height: Layout.starsSize)
                        }
                    }
                    
                    Text("от \(nft.author)")
                        .font(.system(size: 13))
                        .kerning(-0.08)
                        .frame(height: 20, alignment: .top)
                        .foregroundStyle(Color(uiColor: .appTextPrimary))
                }
                
                Spacer(minLength: 0)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Цена")
                        .font(.system(size: 13))
                        .kerning(-0.08)
                        .foregroundStyle(Color(uiColor: .appTextPrimary))
                    
                    Text("\(nft.priceFormattedRu) ETH")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color(uiColor: .appTextPrimary))
                }
                .frame(width: Layout.priceBlockWidth, alignment: .leading)
            }
            .frame(width: Layout.contentWidth, alignment: .leading)
            
            Spacer()
        }
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.vertical, 16)
        .frame(height: Layout.rowHeight)
    }
}

extension NFTMock {
    var priceFormattedRu: String {
        price.formatted(
            .number
                .precision(.fractionLength(2))
                .locale(Locale(identifier: "ru_RU"))
        )
    }
}
