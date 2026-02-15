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
            collectionCover
            collectionContent
                .padding(.top, 16)
                .padding(.horizontal, 16)
        }
        .ignoresSafeArea(.container, edges: .top)
        .customNavigationBarApplyingIOS26()
    }
    
    private var collectionContent: some View {
        VStack(spacing: 24) {
            caption
            grid
        }
    }
    
    private var collectionCover: some View {
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
                author
                Text(collection.description)
            }
            .font(.smallText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var author: some View {
        HStack(spacing: 4) {
            Text("\(L10n.Catalog.collectionAuthor): ")
            NavigationLink("\(collection.author)") {
                AuthorWebsiteView(author: collection.author, website: collection.website)
                    .customBackground()
            }
            .foregroundStyle(.appBlue)
        }
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
                .customBackground()
        }
    }
}
