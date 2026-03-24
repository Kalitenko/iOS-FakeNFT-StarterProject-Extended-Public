//
//  WebViewScreen.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 02/03/2026.
//

import SwiftUI

struct WebViewScreen: View {
    let url: URL

    var body: some View {
        WebViewComponent(url: url)
            .toolbar(.hidden, for: .tabBar)
            .customNavigationBar(title: "Webview")
    }
}
