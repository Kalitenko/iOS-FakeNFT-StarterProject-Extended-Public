//
//  WebViewComponent.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 25.02.2026.
//

import SwiftUI

struct WebViewComponent: View {

    let url: URL
    let fallbackURL: URL?

    @State private var isLoading = true

    init(
        url: URL,
        fallbackURL: URL? = URL(string: "https://practicum.yandex.ru/ios-developer/")
    ) {
        self.url = url
        self.fallbackURL = fallbackURL
    }

    var body: some View {
        WebView(
            url: url,
            fallbackURL: fallbackURL,
            isLoading: $isLoading
        )
        .overlay {
            if isLoading {
                LoadingPlaceholderView()
            }
        }
    }
}
