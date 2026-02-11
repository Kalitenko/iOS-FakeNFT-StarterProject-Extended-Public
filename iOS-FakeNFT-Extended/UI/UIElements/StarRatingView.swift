//
//  StarRatingView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 11.02.2026.
//

import SwiftUI

struct StarRatingView: View {
    
    private let rating: Int
    private let minRating = 0
    private let maxRating = 5
    
    init(rating: Int) {
        self.rating = rating
    }
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(minRating+1...maxRating, id: \.self) { index in
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(
                        index <= rating
                        ? .appYellow
                        : .appSurfaceBackground
                    )
            }
        }
    }
}

#Preview {
    HStack(spacing: 50) {
        VStack {
            StarRatingView(rating: 5)
            StarRatingView(rating: 4)
            StarRatingView(rating: 3)
            StarRatingView(rating: 2)
            StarRatingView(rating: 1)
        }
        VStack {
            StarRatingView(rating: -1234567890)
            StarRatingView(rating: -5)
            StarRatingView(rating: 0)
            StarRatingView(rating: 20)
            StarRatingView(rating: 1234567890)
        }
    }
}
