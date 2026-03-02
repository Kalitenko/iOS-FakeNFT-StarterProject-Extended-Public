//
//  WebViewScreen.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 02/03/2026.
//

//import SwiftUI
//
//struct WebViewScreen: View {
//    let url: URL
//
//    @Environment(\.dismiss) private var dismiss
//    @State private var isLoading = true
//    @State private var errorMessage: String?
//
//    var body: some View {
//        WebView(
//            url: url,
//            isLoading: $isLoading,
//            errorMessage: $errorMessage
//        )
//        .navigationTitle("Webview")
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarBackButtonHidden(true)
//        .toolbar(.hidden, for: .tabBar)// <-- ВОТ ЭТО УБИРАЕТ ВТОРУЮ СИСТЕМНУЮ "НАЗАД"
//        .toolbar {
//            ToolbarItem(placement: .topBarLeading) {
//                Button(action: { dismiss() }) {
//                    Image(systemName: "chevron.left")
//                        .foregroundStyle(Color(uiColor: .appTextPrimary))
//                }
//            }
//        }
//        .overlay {
//            if isLoading {
//                ProgressView()
//            }
//        }
//        .alert("Не удалось загрузить страницу", isPresented: Binding(
//            get: { errorMessage != nil },
//            set: { if !$0 { errorMessage = nil } }
//        )) {
//            Button("Отмена", role: .cancel) { }
//            Button("Повторить") {
//                // сбросим ошибку и покажем лоадер — дальше WebView должен перезагрузиться по trigger (см. ниже)
//                errorMessage = nil
//                isLoading = true
//            }
//        } message: {
//            Text(errorMessage ?? "")
//        }
//    }
//}

import SwiftUI

struct WebViewScreen: View {
    let url: URL

    @Environment(\.dismiss) private var dismiss
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
        .navigationTitle("Webview")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color(uiColor: .appTextPrimary))
                }
            }
        }
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
                // ✅ иначе алерт будет появляться снова
                errorMessage = nil
            }
            Button("Повторить") {
                // ✅ дергаем reload через токен
                reloadToken += 1
            }
        } message: {
            Text(errorMessage ?? "")
        }
    }
}
