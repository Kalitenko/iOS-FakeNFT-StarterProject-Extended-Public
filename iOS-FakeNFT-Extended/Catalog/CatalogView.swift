//
//  CatalogView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 10.02.2026.
//

import SwiftUI

struct CatalogView: View {
    
    let items: [CatalogItem]
    let action: () -> Void
    
    var body: some View {
        CatalogListView(items: items)
            .padding(.horizontal, 16)
            .customNavigationBar(hidesLeading: true,
                                 trailingAction: action)
            .navigationDestination(for: CatalogItem.self) { item in
                CollectionView(collection: item)
                    .customBackground()
            }
    }
}

#Preview {
    NavigationStack {
        CatalogView(items: CatalogItem.mockItems) {
            print("Action button tapped!")
        }
        .customBackground(color: .purple)
    }
}
