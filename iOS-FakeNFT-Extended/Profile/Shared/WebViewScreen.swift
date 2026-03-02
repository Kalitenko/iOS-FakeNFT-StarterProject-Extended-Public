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
    @State private var errorMessage: String?
    @State private var reloadToken: Int = 0

    var body: some View {
        WebView(
            url: url,
            isLoading: $isLoading,
            errorMessage: $errorMessage,
            reloadToken: $reloadToken
        )
        .toolbar(.hidden, for: .tabBar)
        .customNavigationBar(title: "Webview")
        .overlay {
            if isLoading {
                ProgressView()
            }
        }
        .alert("Не удалось загрузить страницу", isPresented: Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("Отмена", role: .cancel) {
                errorMessage = nil
            }
            Button("Повторить") {
                reloadToken += 1
            }
        } message: {
            Text(errorMessage ?? "")
        }
    }
}
