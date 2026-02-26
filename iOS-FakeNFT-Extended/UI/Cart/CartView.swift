//
//  CartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 09.02.2026.
//

import SwiftUI

struct CartView: View {
    @State private var viewModel: CartViewModel
    @State private var selectedNFT: NFTModel?
    @State private var isSortingPresented = false

    @AppStorage("cart_sort_option")
    private var savedSortOption: String = CartSortOption.name.rawValue

    private var selectedSortOption: CartSortOption {
        get { CartSortOption(rawValue: savedSortOption) ?? .name }
        nonmutating set { savedSortOption = newValue.rawValue }
    }

    private var isErrorAlertPresented: Binding<Bool> {
        Binding {
            viewModel.errorMessage != nil
        } set: { isPresented in
            if !isPresented {
                viewModel.errorMessage = nil
            }
        }
    }

    init(viewModel: CartViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: .zero) {
                switch viewModel.state {
                case .loading:
                    LoadingPlaceholderView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .empty:
                    emptyState
                case .content, .updating:
                    itemsList
                        .padding(.top, 20)
                    summaryPanel
                }
            }
            .background(.appBackground)
            .toolbar {
                if !viewModel.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        sortButton
                    }
                }
            }
        }
        .task {
            await viewModel.load(sortedBy: selectedSortOption)
        }
        .onChange(of: savedSortOption, { _, newValue in
            let option = CartSortOption(rawValue: newValue) ?? .name
            viewModel.applySort(option)
        })
        .alert(
            L10n.Alerts.dataLoadFailed,
            isPresented: isErrorAlertPresented
        ) {
            Button(L10n.Common.retry) {
                Task {
                    await viewModel.load(sortedBy: selectedSortOption)
                }
            }
            Button(L10n.Common.cancel, role: .cancel) { viewModel.errorMessage = nil }
        }
        .confirmationDialog(
            L10n.Sort.title,
            isPresented: $isSortingPresented,
            titleVisibility: .visible
        ) {
            sortDialogButtons
        }
        .fullScreenCover(
            item: $selectedNFT,
            onDismiss: { selectedNFT = nil },
            content: { nft in
                DeleteView(
                    nft: nft,
                    onDelete: {
                        Task {
                            await viewModel.deleteFromCart(nft: nft)
                            selectedNFT = nil
                        }
                    },
                    onCancel: {
                        selectedNFT = nil
                    }
                )
                .presentationBackground(.clear)
            }
        )
    }

    private var emptyState: some View {
        Text(L10n.Cart.emptyCart)
            .font(.title)
            .foregroundStyle(.appTextPrimary)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }

    private var itemsList: some View {
        List {
            ForEach(viewModel.items) { nft in
                NFTCartCell(nft: nft) {
                    selectedNFT = nft
                }
                .listRowSeparator(.hidden)
                .listRowInsets(.init())
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private var summaryPanel: some View {
        HStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 2) {
                Text(verbatim: "\(viewModel.itemsAmount) NFT")
                    .font(.text)
                    .foregroundStyle(.appTextPrimary)
                Text(verbatim: "\(viewModel.totalPrice) ETH")
                    .font(.title)
                    .foregroundStyle(.appGreen)
            }
            NavigationLink {
                CurrencyListView(viewModel: viewModel)
                    .customNavigationBar(title: L10n.Cart.choosePaymentMethod)
                    .toolbar(.hidden, for: .tabBar)
            } label: {
                Text(L10n.Cart.totalToPay)
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .foregroundStyle(.appBackground)
                    .background(.appTextPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .padding(16)
        .frame(height: 76)
        .background(.appSurfaceBackground)
        .clipShape(.rect(topLeadingRadius: 12, topTrailingRadius: 12))
    }

    private var sortButton: some View {
        Button {
            isSortingPresented = true
        } label: {
            Image(.sort)
                .foregroundStyle(.appTextPrimary)
        }
    }

    private var sortDialogButtons: some View {
        Group {
            Button(L10n.Sort.byPrice) {
                selectedSortOption = .price
                isSortingPresented = false
            }
            Button(L10n.Sort.byRating) {
                selectedSortOption = .rating
                isSortingPresented = false
            }
            Button(L10n.Sort.byName) {
                selectedSortOption = .name
                isSortingPresented = false
            }
            Button(L10n.Common.close, role: .cancel) {
                isSortingPresented = false
            }
        }
    }
}
