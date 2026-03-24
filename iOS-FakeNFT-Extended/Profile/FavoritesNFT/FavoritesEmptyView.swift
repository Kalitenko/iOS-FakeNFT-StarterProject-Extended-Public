//
//  FavoritesEmptyView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 01/03/2026.
//

import SwiftUI

struct FavoritesEmptyView: View {

    private enum Layout {
        static let messageTopInset: CGFloat = 395
        static let messageHorizontalInset: CGFloat = 16
        static let messageFontSize: CGFloat = 17
        static let messageLineHeight: CGFloat = 22
    }

    var body: some View {
        VStack {
            Spacer()

            Text(L10n.Profile.noFavoriteNFT)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color(uiColor: .appTextPrimary))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
    
    }
}

