//
//  LikeButton.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 14.02.2026.
//

import SwiftUI

struct LikeButton: View {
    
    let isFavorite: Bool
    let action: () -> Void
    private let size: CGFloat = 40
    
    var body: some View {
        Button(action: action) {
            Image(isFavorite ? .favoritesActive : .favoritesInactive)
                .foregroundStyle(isFavorite ? .appRed : .appWhite)
        }
        .contentShape(Rectangle())
        .frame(width: size, height: size)
    }
}

#Preview {
    VStack {
        LikeButton(isFavorite: true, action: {
            print("Favorite tapped")
        })
        LikeButton(isFavorite: false, action: {
            print("Not favorite tapped")
        })
    }
    .background(.gray)
}
