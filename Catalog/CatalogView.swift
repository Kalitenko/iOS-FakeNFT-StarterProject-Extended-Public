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
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    sortButton
                }
            })
    }
    
    private var sortButton: some View {
        Button(action: action, label: {
            Image(.sort)
                .foregroundStyle(.appTextPrimary)
        })
    }
}

#Preview {
    NavigationStack {
        CatalogView(items: CatalogItem.mockItems) {
            print("Action button tapped!")
        }
    }
}
