//
//  CollectionView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 12.02.2026.
//

import SwiftUI

struct CollectionView: View {
    
    let collection: CatalogItem
    
    var body: some View {
        ScrollView {
            collectionInfo
            grid
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
        }
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
    
    private var collectionInfo: some View {
        VStack(spacing: 16) {
            cover
            caption
                .padding(.horizontal, 16)
        }
    }
    
    private var cover: some View {
        Image(collection.cover)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .clipped()
    }
    
    private var caption: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(collection.name)
                .font(.bigTitle)
            VStack(alignment: .leading, spacing: 5) {
                Text("\(L10n.Catalog.collectionAuthor): ")
                Text(collection.description)
            }
            .font(.smallText)
        }
        .foregroundStyle(.appTextPrimary)
    }
    
    private var grid: some View {
        
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        return LazyVGrid(columns: columns, spacing: 8) {
            ForEach(collection.elements, id: \.self) { item in
                CollectionCell(item: item)
            }
        }
    }
}

#Preview("Экран коллекции") {
    CollectionView(collection: CatalogItem.mock)
}

#Preview("Экран коллекции в навигации") {
    NavigationStack {
        NavigationLink("Open") {
            CollectionView(collection: CatalogItem.mock)
        }
    }
}
