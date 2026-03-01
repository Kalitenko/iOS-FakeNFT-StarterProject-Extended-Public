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
    
    @Environment(ServicesAssembly.self) private var services
    
    init(viewModel: CatalogViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                CircularProgressView()
            } else {
                catalogContent()
            }
        }
        .task { await viewModel.prepare() }
    }
    
    private func catalogContent() -> some View {
        CatalogListView(
            items: viewModel.items,
            isLoadingMore: viewModel.isLoadingMore,
            loadMore: { Task { await viewModel.loadMore() } }
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
        .customNavigationBarApplyingIOS26(
            hidesLeading: true,
            trailingAction: { showSortMenu = true }
        )
        .navigationDestination(for: CatalogItem.self) { item in
            CollectionView(viewModel:
                            CollectionViewModel(
                                catalogService: viewModel.catalogService,
                                profileService: services.commonProfileService,
                                orderService: services.commonOrderService,
                                collectionInfo: item
                            )
            )
            .customBackground()
            .toolbar(.hidden, for: .tabBar)
        }
        .confirmationDialog(L10n.Sort.title, isPresented: $showSortMenu, titleVisibility: .visible) {
            Button(L10n.Sort.byTitle) { Task { await viewModel.changeSort(to: .byTitle) } }
            Button(L10n.Sort.byNFTCount) { Task { await viewModel.changeSort(to: .byNFTCount) } }
            Button(L10n.Common.close, role: .cancel) {}
        }
        .alert(
            alertTitle,
            isPresented: Binding(
                get: { viewModel.screenError != nil },
                set: { newValue in
                    if !newValue { viewModel.screenError = nil }
                }
            )
        ) {
            alertButtons
        }
    }
    
    private var alertTitle: String {
        switch viewModel.screenError {
        case .loading:
            return L10n.Alerts.dataLoadFailed
        case .generic:
            return L10n.Alerts.somethingWentWrong
        case .none:
            return ""
        }
    }
    
    @ViewBuilder
    private var alertButtons: some View {
        switch viewModel.screenError {
        case .loading:
            Button(L10n.Common.cancel, role: .cancel) { viewModel.screenError = nil }
            Button(L10n.Common.retry) {
                viewModel.screenError = nil
                Task { await viewModel.loadInitial() }
            }
        case .generic:
            Button(L10n.Alerts.okay, role: .cancel) { viewModel.screenError = nil }
        case .none:
            EmptyView()
        }
    }
}
