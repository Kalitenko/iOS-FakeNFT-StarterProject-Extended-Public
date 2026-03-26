//
//  NftPreviewImageView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 25/03/2026.
//

import SwiftUI

struct NftPreviewImageView: View {
    let imageURL: URL?
    let size: CGFloat
    let cornerRadius: CGFloat
    
    var body: some View {
        Group {
            if let imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        loadingPlaceholder
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: size, height: size)
                    case .failure:
                        imagePlaceholder
                    @unknown default:
                        imagePlaceholder
                    }
                }
            } else {
                imagePlaceholder
            }
        }
        .frame(width: size, height: size)
        .clipShape(
            RoundedRectangle(
                cornerRadius: cornerRadius,
                style: .continuous
            )
        )
    }
    
    private var loadingPlaceholder: some View {
        ProgressView()
            .frame(width: size, height: size)
    }
    
    private var imagePlaceholder: some View {
        Color.gray.opacity(0.2)
            .frame(width: size, height: size)
    }
}
