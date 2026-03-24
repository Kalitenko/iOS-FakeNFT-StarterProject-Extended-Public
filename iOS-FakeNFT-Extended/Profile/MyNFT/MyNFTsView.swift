//
//  MyNFTsView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 27/02/2026.
//

import SwiftUI

struct MyNFTsView: View {
    
    @State private var viewModel: MyNFTsViewModel
    @State private var isSortPresented = false
    
    init(viewModel: MyNFTsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoaderTileView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.isEmpty {
                MyNFTEmptyView()
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.sortedNfts, id: \.id) { nft in
                            MyNFTCell(nft: nft)
                        }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                }
            }
        }
        .background(Color(uiColor: .systemBackground))
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .customNavigationBar(
            title: viewModel.isEmpty ? nil : L10n.Profile.myNFT,
            hidesBackground: false,
            trailingAction: viewModel.isEmpty ? nil : { isSortPresented = true }
        )
        .confirmationDialog(
            L10n.Sort.title,
            isPresented: $isSortPresented,
            titleVisibility: .visible
        ) {
            Button(L10n.Sort.byPrice) {
                viewModel.sort = .price
            }
            Button(L10n.Sort.byRating) {
                viewModel.sort = .rating
            }
            Button(L10n.Sort.byName) {
                viewModel.sort = .name
            }
            Button(L10n.Common.close, role: .cancel) {
            }
        }
        .task {
            await viewModel.loadMyNFTs()
        }
        .alert(
            L10n.Alerts.somethingWentWrong,
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )
        ) {
            Button(L10n.Alerts.okay, role: .cancel) {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}
