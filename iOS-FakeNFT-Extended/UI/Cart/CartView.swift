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

    init(viewModel: CartViewModel = CartViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: .zero) {
                if viewModel.isEmpty {
                    emptyState
                } else {
                    itemsList
                        .padding(.top, 20)
                    summaryPanel
                }
            }
            .background(.appBackground)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    sortButton
                }
            }
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
                        viewModel.remove(nft)
                        selectedNFT = nil
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

            Button {

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
                isSortingPresented = false
            }
            Button(L10n.Sort.byRating) {
                isSortingPresented = false
            }
            Button(L10n.Sort.byName) {
                isSortingPresented = false
            }
            Button(L10n.Common.close, role: .cancel) {
                isSortingPresented = false
            }
        }
    }

    private func confirmDelete(_ nft: NFTModel) {
        withAnimation(.easeInOut(duration: 0.2)) {
            viewModel.remove(nft)
        }
        selectedNFT = nil
    }
}

#Preview {
    CartView()
}
