//
//  DeleteView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 10.02.2026.
//

import SwiftUI

struct DeleteView: View {
    let nft: NFTModel
    let onDelete: () -> Void
    let onCancel: () -> Void

    var body: some View {
        ZStack {
            background

            VStack(spacing: 20) {
                VStack(spacing: 12) {
                    image
                    confirmText
                }
                .frame(width: 180)
                HStack(spacing: 8) {
                    deleteButton
                    backButton
                }
                .padding(.horizontal, 56)
            }
        }
    }

    private var image: some View {
        nft.image
            .resizable()
            .scaledToFit()
            .frame(width: 108, height: 108)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var confirmText: some View {
        Text(L10n.Confirmations.deleteFromCartMessage)
            .font(.smallText)
            .foregroundStyle(.appTextPrimary)
            .multilineTextAlignment(.center)
    }

    private var deleteButton: some View {
        Button(action: onDelete) {
            Text(L10n.Confirmations.delete)
                .font(.bigText)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .foregroundStyle(.appRed)
                .background(.appTextPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var backButton: some View {
        Button(action: onCancel) {
            Text(L10n.Confirmations.back)
                .font(.bigText)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .foregroundStyle(.appBackground)
                .background(.appTextPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var background: some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .ignoresSafeArea()
    }
}

#Preview {
    DeleteView(
        nft: NFTModel(name: "", price: "", rating: 0, image: Image(.april)),
        onDelete: { },
        onCancel: { }
    )
}
