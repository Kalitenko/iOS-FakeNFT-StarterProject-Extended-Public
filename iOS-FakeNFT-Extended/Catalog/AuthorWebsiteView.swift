//
//  AuthorWebsiteView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 14.02.2026.
//

import SwiftUI

struct AuthorWebsiteView: View {
    
    let author: String
    let website: String
    
    var body: some View {
        HStack {
            Text("Тут будет web view автора ")
            + Text(author).foregroundStyle(.appRed)
            + Text(" с адресом ")
            + Text(website).foregroundStyle(.appRed)
        }
        .customNavigationBar()
    }
}

#Preview {
    AuthorWebsiteView(author: "Автор", website: "URL")
        .customBackground(color: .cyan)
}
