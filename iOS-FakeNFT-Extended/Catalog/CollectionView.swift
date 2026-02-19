//
//  CollectionView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 12.02.2026.
//

import SwiftUI

struct CollectionView: View {
    
    @State private var viewModel: CollectionViewModel
    
    init(viewModel: CollectionViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            collectionCover
            collectionContent
                .padding([.top, .horizontal], 16)
        }
        .ignoresSafeArea(.container, edges: .top)
        .customNavigationBarApplyingIOS26()
        .task {
            await viewModel.loadData()
        }
    }
    
    private var collectionContent: some View {
        VStack(spacing: 24) {
            caption
            grid
        }
    }
    
    private var collectionCover: some View {
        AppImageView(source: viewModel.collectionInfo.cover)
            .frame(maxWidth: .infinity)
            .clipped()
    }
    
    private var caption: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.collectionInfo.name)
                .font(.bigTitle)
            
            VStack(alignment: .leading, spacing: 5) {
                author
                Text(viewModel.collectionInfo.description)
            }
            .font(.smallText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var author: some View {
        HStack(spacing: 4) {
            Text("\(L10n.Catalog.collectionAuthor): ")
            NavigationLink("\(viewModel.collectionInfo.author)") {
                AuthorWebsiteView(author: viewModel.collectionInfo.author, website: viewModel.collectionInfo.website)
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
            ForEach(viewModel.items, id: \.id) { item in
                CollectionCell(item: item)
            }
        }
    }
}

#Preview("Экран коллекции") {
    CollectionView(viewModel: .mock())
}

#Preview("Экран коллекции в навигации") {
    NavigationStack {
        NavigationLink("Open") {
            CollectionView(viewModel: .mock())
                .customBackground()
        }
    }
}
