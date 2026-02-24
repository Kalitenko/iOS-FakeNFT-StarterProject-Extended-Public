//
//  CurrencyCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 24.02.2026.
//

import SwiftUI
import Kingfisher

struct CurrencyCell: View {
    let currency: CurrencyModel?
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 4) {
            image
            title
            Spacer()
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 12)
        .frame(height: 46)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.appSurfaceBackground)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? .appTextPrimary : .clear)
        }
    }

    var image: some View {
        ZStack {
            Color(.appBlack)
            KFImage(currency?.imageURL)
                .resizable()
                .scaledToFit()
        }
        .frame(width: 36, height: 36)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }

    var title: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text(currency?.title ?? "")
                .foregroundStyle(.appTextPrimary)
            Text(currency?.name ?? "")
                .foregroundStyle(.appGreen)
        }
        .font(.smallText)
    }
}

#Preview("Default") {
    CurrencyCell(
        currency: CurrencyModel(
            id: "1",
            title: "Cardano",
            name: "ADA",
            imageURLString: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Cardano_(ADA).png"
        ),
        isSelected: false
    )
    .frame(width: 168)
}

#Preview("Selected") {
    CurrencyCell(
        currency: CurrencyModel(
            id: "0",
            title: "Shiba_Inu",
            name: "SHIB",
            imageURLString: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Shiba_Inu_(SHIB).png"
        ),
        isSelected: true
    )
    .frame(width: 168)
}
