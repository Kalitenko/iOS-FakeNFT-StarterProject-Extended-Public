//
//  CatalogView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 10.02.2026.
//

import SwiftUI

struct CatalogView: View {
    
    @State private var showSortMenu = false
    @State private var viewModel: CatalogViewModel
    
    init(viewModel: CatalogViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                CircularProgressView()
                
            case .loaded(let items):
                catalogContent(items)
                
            case .error:
                // TODO: обработать ошибку
                catalogContent([])
            }
        }
        .task {
            await viewModel.loadData()
        }
    }
    
    private func catalogContent(_ items: [CatalogItem]) -> some View {
        CatalogListView(items: items)
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
            .customNavigationBarApplyingIOS26(
                hidesLeading: true,
                trailingAction: {
                    showSortMenu = true
                }
            )
            .navigationDestination(for: CatalogItem.self) { item in
                CollectionView(viewModel: CollectionViewModel(catalogService: viewModel.catalogService, collectionInfo: item))
                    .customBackground()
                    .toolbar(.hidden, for: .tabBar)
            }
            .confirmationDialog(L10n.Sort.title, isPresented: $showSortMenu, titleVisibility: .visible) {
                Button(L10n.Sort.byTitle) { print(L10n.Sort.byTitle) }
                Button(L10n.Sort.byNFTCount) { print(L10n.Sort.byNFTCount) }
                Button(L10n.Common.close, role: .cancel) { }
            }
    }
}

#Preview {
    NavigationStack {
        CatalogView(viewModel: .mock())
            .customBackground(color: .purple)
    }
}
