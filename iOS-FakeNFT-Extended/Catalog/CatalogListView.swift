//
//  CatalogListView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 10.02.2026.
//

import SwiftUI

struct CatalogListView: View {
    let items: [CatalogItem]
    
    var body: some View {
        List(items, id: \.id) { item in
            CatalogItemView(item: item)
                .background(
                    NavigationLink(value: item) {
                        EmptyView()
                    }
                        .opacity(0)
                )
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    NavigationStack {
        CatalogListView(items: CatalogItem.mockItems)
            .background(.green)
            .padding(16)
            .background(.yellow)
    }
}
