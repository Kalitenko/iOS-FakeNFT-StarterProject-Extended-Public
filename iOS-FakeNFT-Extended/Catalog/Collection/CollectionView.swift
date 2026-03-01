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
            Group {
                switch viewModel.state {
                case .loading:
                    LoadingPlaceholderView()
                    
                case .loaded(let items):
                    grid(items)
                }
            }
        }
        .alert(
            alertTitle,
            isPresented: Binding(
                get: { viewModel.screenError != nil },
                set: { if !$0 { viewModel.screenError = nil } }
            )
        ) {
            alertButtons
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
            if let url = viewModel.authorURL {
                NavigationLink(viewModel.collectionInfo.author) {
                    WebViewComponent(url: url)
                        .customNavigationBarApplyingIOS26()
                }
                .foregroundStyle(.appBlue)
            } else {
                Text("\(viewModel.collectionInfo.author)")
            }
        }
    }
    
    private func grid(_ items: [CollectionItem]) -> some View {
        
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        return LazyVGrid(columns: columns, spacing: 8) {
            ForEach(items, id: \.id) { item in
                CollectionCell(
                    item: item,
                    onLikeTap: { viewModel.toggleLike(for: item.id) },
                    onCartTap: { viewModel.toggleCart(for: item.id) }
                )
            }
        }
    }
    
    private var alertTitle: String {
        switch viewModel.screenError {
        case .loadFailed:
            return L10n.Alerts.dataLoadFailed
        case .likeFailed, .cartFailed:
            return L10n.Alerts.somethingWentWrong
        case .none:
            return ""
        }
    }
    
    @ViewBuilder
    private var alertButtons: some View {
        switch viewModel.screenError {
            
        case .loadFailed:
            Button(L10n.Common.cancel, role: .cancel) {
                viewModel.screenError = nil
            }
            
            Button(L10n.Common.retry) {
                viewModel.screenError = nil
                Task {
                    await viewModel.loadData()
                }
            }
            
        case .likeFailed, .cartFailed:
            Button(L10n.Alerts.okay, role: .cancel) {
                viewModel.screenError = nil
            }
            
        case .none:
            EmptyView()
        }
    }
}
