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

private struct WebViewComponentExample: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                NavigationLink("Google") {
                    WebViewComponent(
                        url: URL(string: "https://google.com")!
                    )
                }
                
                NavigationLink("Broken link") {
                    WebViewComponent(
                        url: URL(string: "https://wrong-url-12345.com")!,
                        fallbackURL: URL(string: "https://apple.com")
                    )
                }
            }
        }
    }
}

#Preview {
    WebViewComponentExample()
}
