//
//  WebView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 25.02.2026.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    let url: URL
    let fallbackURL: URL?

    @Binding var isLoading: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator

        context.coordinator.loadingObservation =
        webView.observe(\.isLoading, options: [.new]) { [weak coordinator = context.coordinator] webView, _ in
            DispatchQueue.main.async {
                coordinator?.parent.isLoading = webView.isLoading
            }
        }

        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {

    }

    class Coordinator: NSObject, WKNavigationDelegate {

        let parent: WebView
        var loadingObservation: NSKeyValueObservation?
        private var didTryFallback = false

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView,
                     didFailProvisionalNavigation navigation: WKNavigation!,
                     withError error: Error) {
            handle(error: error, webView: webView)
        }

        func webView(_ webView: WKWebView,
                     didFail navigation: WKNavigation!,
                     withError error: Error) {
            handle(error: error, webView: webView)
        }

        private func handle(error: Error, webView: WKWebView) {
            let nsError = error as NSError

            if nsError.code == NSURLErrorCancelled {
                return
            }

            if let fallback = parent.fallbackURL, !didTryFallback {
                didTryFallback = true
                webView.load(URLRequest(url: fallback))
            }
        }
    }
}
