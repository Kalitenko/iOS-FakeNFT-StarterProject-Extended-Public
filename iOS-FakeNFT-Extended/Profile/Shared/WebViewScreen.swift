//
//  WebViewScreen.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 02/03/2026.
//

import SwiftUI

struct WebViewScreen: View {
    let url: URL

    @State private var isLoading = true

    var body: some View {
        WebView(
            url: url,
            fallbackURL: nil,
            isLoading: $isLoading
        )
        .toolbar(.hidden, for: .tabBar)
        .customNavigationBar(title: "Webview")
        .overlay {
            if isLoading {
                ProgressView()
            }
        }
    }
}
