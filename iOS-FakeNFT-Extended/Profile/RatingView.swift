//
//  RatingView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 01/03/2026.
//

import SwiftUI

struct RatingView: View {
    let rating: Int

    private enum Layout {
        static let maxRating = 5
        static let starSize: CGFloat = 12
        static let spacing: CGFloat = 2
    }

    var body: some View {
        HStack(spacing: Layout.spacing) {
            ForEach(0..<Layout.maxRating, id: \.self) { index in
                Image(index < rating ? "starFilled" : "starEmpty")
                    .resizable()
                    .scaledToFit()
                    .frame(width: Layout.starSize, height: Layout.starSize)
            }
        }
    }
}
