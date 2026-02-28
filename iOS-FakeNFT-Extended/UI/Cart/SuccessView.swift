//
//  SuccessView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 26.02.2026.
//

import SwiftUI

struct SuccessView: View {
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            congratsView
            .frame(maxHeight: .infinity)

            ActionButton(
                title: L10n.Cart.backToCart,
                action: onBack
            )
            .padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.appBackground)
    }

    private var congratsView: some View {
        VStack {
            Image(.tater)
                .resizable()
                .scaledToFit()
                .frame(width: 278, height: 278)

            Text(L10n.Cart.successTitle)
                .font(.bigTitle)
                .foregroundStyle(.appTextPrimary)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    SuccessView(onBack: { })
}
