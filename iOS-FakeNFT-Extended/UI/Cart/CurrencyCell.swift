//
//  CurrencyCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 24.02.2026.
//

import SwiftUI
import Kingfisher

struct CurrencyCell: View {
    let currency: CurrencyDTO
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
            KFImage(URL(string: currency.image))
                .resizable()
                .scaledToFit()
        }
        .frame(width: 36, height: 36)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }

    var title: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text(currency.title)
                .foregroundStyle(.appTextPrimary)
            Text(currency.name)
                .foregroundStyle(.appGreen)
        }
        .font(.smallText)
    }
}

#Preview("Default") {
    CurrencyCell(currency: CurrencyDTO(
        title: "Cardano",
        name: "ADA",
        image: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Cardano_(ADA).png",
        id: "1"),
                 isSelected: false
    )
    .frame(width: 168)
}

#Preview("Selected") {
    CurrencyCell(currency: CurrencyDTO(
        title: "Cardano",
        name: "ADA",
        image: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Cardano_(ADA).png",
        id: "1"),
                 isSelected: true
    )
    .frame(width: 168)
}
