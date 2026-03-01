//
//  CatalogListView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 10.02.2026.
//

import SwiftUI

struct CatalogListView: View {
    let items: [CatalogItem]
    let isLoadingMore: Bool
    let loadMore: () -> Void
    
    var body: some View {
        List {
            ForEach(items, id: \.id) { item in
                CatalogItemView(item: item)
                    .onAppear {
                        if item.id == items.last?.id && !isLoadingMore {
                            loadMore()
                        }
                    }
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
            
            if isLoadingMore {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
    }
    
}
