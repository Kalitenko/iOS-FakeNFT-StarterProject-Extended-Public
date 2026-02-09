//
//  ActionButton.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 08.02.2026.
//

import SwiftUI

struct ActionButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .foregroundStyle(.appBackground)
                .background(.appTextPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(.horizontal, 16)
    }
}

#Preview("Корзина") {
    ZStack {
        Color(.appBackground)
            .ignoresSafeArea()
        VStack {
            Spacer()
            ActionButton(title: "Вернуться в корзину", action: { })
                .padding(.bottom, 16)
        }
    }
}

#Preview("Вход") {
    ZStack {
        Color(.appBackground)
            .ignoresSafeArea()
        ActionButton(title: "Войти", action: { })
    }
}
