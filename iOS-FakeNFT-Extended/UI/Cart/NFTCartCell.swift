//
//  NFTCartCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 09.02.2026.
//

import SwiftUI

struct NFTCartCell: View {
    let nft: NFTModel

    var body: some View {
        HStack(spacing: 20) {
            image
            VStack(alignment: .leading, spacing: 0) {
                name
                    .padding(.bottom, 4)
                StarRatingView(rating: nft.rating)
                    .padding(.bottom, 12)
                price
            }
            Spacer()

            removeButton
                .padding(.trailing, 12)
        }
        .padding(16)
    }

    private var image: some View {
        Image(.april)
            .resizable()
            .scaledToFit()
            .frame(width: 108, height: 108)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var name: some View {
        Text(nft.name)
            .font(.title)
            .foregroundStyle(.appTextPrimary)
    }

    private var price: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(L10n.Common.price)
                .font(.smallText)
                .foregroundStyle(.appTextPrimary)
            Text(nft.price)
                .font(.title)
                .foregroundStyle(.appTextPrimary)
        }
    }

    private var removeButton: some View {
        Button {

        } label: {
            Image(.cartRemove)
                .resizable()
                .frame(width: 16, height: 18.56)
                .foregroundStyle(.appTextPrimary)
        }
    }
}

struct StarRatingView: View {
    let rating: Int
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(index <= rating ? .appYellow : .appSurfaceBackground)
            }
        }
    }
}

#Preview {
    NFTCartCell(nft: NFTModel(
        name: "April",
        price: "1,78 ETH",
        rating: 4,
        image: Image(.april))
    )
}
