//
//  CartButton.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 14.02.2026.
//

import SwiftUI

struct CartButton: View {
    
    let isInCart: Bool
    let action: () -> Void
    private let size: CGFloat = 40
    
    var body: some View {
        Button(action: action) {
            Image(isInCart ? .cartRemove : .cartAdd)
                .foregroundStyle(.appTextPrimary)
        }
        .contentShape(Rectangle())
        .frame(width: size, height: size)
    }
}

#Preview {
    VStack {
        CartButton(isInCart: true, action: {
            print("in cart tapped")
        })
        CartButton(isInCart: false, action: {
            print("Not in cart tapped")
        })
    }
    .background(.gray)
}
