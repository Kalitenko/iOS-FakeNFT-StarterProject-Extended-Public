//
//  WebView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 17/02/2026.
//

//import SwiftUI
//import WebKit
//
//struct WebView: UIViewRepresentable {
//    let url: URL
//    @Binding var isLoading: Bool
//    @Binding var errorMessage: String?
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(isLoading: $isLoading, errorMessage: $errorMessage)
//    }
//
//    func makeUIView(context: Context) -> WKWebView {
//        let webView = WKWebView()
//        webView.navigationDelegate = context.coordinator
//        webView.allowsBackForwardNavigationGestures = true
//        webView.scrollView.contentInsetAdjustmentBehavior = .never
//
//        let request = URLRequest(url: url)
//        webView.load(request)
//        return webView
//    }
//
//    func updateUIView(_ webView: WKWebView, context: Context) {
//        // чтобы не было постоянных перезагрузок на каждом обновлении SwiftUI
//        if webView.url != url {
//            let request = URLRequest(url: url)
//            webView.load(request)
//        }
//    }
//}
//
//// MARK: - Coordinator
//
//final class Coordinator: NSObject, WKNavigationDelegate {
//    @Binding private var isLoading: Bool
//    @Binding private var errorMessage: String?
//
//    init(isLoading: Binding<Bool>, errorMessage: Binding<String?>) {
//        _isLoading = isLoading
//        _errorMessage = errorMessage
//    }
//
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        DispatchQueue.main.async {
//            self.isLoading = true
//        }
//    }
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        DispatchQueue.main.async {
//            self.isLoading = false
//        }
//    }
//
//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        DispatchQueue.main.async {
//            self.isLoading = false
//            self.errorMessage = error.localizedDescription
//        }
//    }
//
//    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//        DispatchQueue.main.async {
//            self.isLoading = false
//            self.errorMessage = error.localizedDescription
//        }
//    }
//}

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    let url: URL
    @Binding var isLoading: Bool
    @Binding var errorMessage: String?
    @Binding var reloadToken: Int

    func makeCoordinator() -> Coordinator {
        Coordinator(isLoading: $isLoading, errorMessage: $errorMessage)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .never

        // initial load
        context.coordinator.loadIfNeeded(webView, url: url)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        // 1) грузим только если URL реально изменился
        context.coordinator.loadIfNeeded(webView, url: url)

        // 2) ручной перезапуск по токену (Retry)
        if context.coordinator.lastReloadToken != reloadToken {
            context.coordinator.lastReloadToken = reloadToken
            errorMessage = nil
            isLoading = true
            webView.reload()
        }
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        @Binding var isLoading: Bool
        @Binding var errorMessage: String?

        var lastLoadedURL: URL?
        var lastReloadToken: Int = 0

        init(isLoading: Binding<Bool>, errorMessage: Binding<String?>) {
            _isLoading = isLoading
            _errorMessage = errorMessage
        }

        func loadIfNeeded(_ webView: WKWebView, url: URL) {
            // чтобы не делать load снова и снова
            guard lastLoadedURL != url else { return }
            lastLoadedURL = url

            isLoading = true
            errorMessage = nil
            webView.load(URLRequest(url: url))
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            isLoading = false
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            handle(error)
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            handle(error)
        }

        private func handle(_ error: Error) {
            let nsError = error as NSError

            // ✅ -999 = отмена загрузки (часто из-за reload/перезапуска) — НЕ показываем алерт
            if nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorCancelled {
                return
            }

            isLoading = false
            errorMessage = nsError.localizedDescription
        }
    }
}
