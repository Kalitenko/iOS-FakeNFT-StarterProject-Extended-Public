//
//  AppImageView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 19.02.2026.
//

import SwiftUI
import Kingfisher

enum ImageSource: Hashable {
    case remote(URL)
    case local(String)
    case empty
}

struct AppImageView: View {
    
    let source: ImageSource
    let size: CGSize?
    
    init(source: ImageSource, size: CGSize? = nil) {
        self.source = source
        self.size = size
    }
    
    var body: some View {
        switch source {
        case .local(let name):
            Image(name)
                .resizable()
                .scaledToFill()
            
        case .remote(let url):
            let scale = UIScreen.main.scale
            
            let image = KFImage(url)
                .placeholder {
                    placeholderImage
                }
            
            if let size {
                image.setProcessor(
                    DownsamplingImageProcessor(
                        size: CGSize(
                            width: size.width * scale,
                            height: size.height * scale
                        )
                    )
                )
            }
            image
                .resizable()
                .scaledToFill()
            
        case .empty:
            placeholderImage
        }
    }
    
    private var placeholderImage: some View {
        Image(systemName: "photo.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(.appGrey)
    }
}

#Preview("Local") {
    let size: CGFloat = 300
    
    AppImageView(
        source: .local("Green"),
        size: CGSize(width: size, height: size)
    )
    .frame(width: size, height: size)
}

#Preview("Remote") {
    let size: CGFloat = 300
    
    if let url = URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Green.png") {
        AppImageView(
            source: .remote(url),
            size: CGSize(width: size, height: size)
        )
        .frame(width: size, height: size)
    }
}

#Preview("Remote") {
    let size: CGFloat = 300
    
    if let url = URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Green.png") {
        AppImageView(
            source: .remote(url)
        )
        .frame(width: size, height: size)
    }
}
