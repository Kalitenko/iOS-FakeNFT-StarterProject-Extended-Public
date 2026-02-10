//
//  CartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 09.02.2026.
//

import SwiftUI

struct CartView: View {
    @State private var viewModel: CartViewModel
    @State private var isDeleting = false
    @State private var selectedNFT: NFTModel?

    init(viewModel: CartViewModel = CartViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Group {
                    if viewModel.isEmpty {
                        emptyState
                    } else {
                        VStack(spacing: 0) {
                            itemsList
                                .padding(.top, 20)
                            summaryPanel
                        }
                    }
                }
                .background(.appBackground)

                if isDeleting, let nft = selectedNFT {
                    DeleteView(
                        nft: nft,
                        onDelete: { confirmDelete(nft) },
                        onCancel: { hideConfirmation() }
                    )
                    .transition(.opacity)
                    .zIndex(1)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !viewModel.isEmpty {
                        sortButton
                    }
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isDeleting)
        }
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
                    showConfirmation(for: nft)
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

            Button(action: {

            }, label: {
                Text(L10n.Cart.totalToPay)
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .foregroundStyle(.appBackground)
                    .background(.appTextPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            })
        }
        .padding(16)
        .frame(height: 76)
        .background(.appSurfaceBackground)
        .clipShape(.rect(topLeadingRadius: 12, topTrailingRadius: 12))
    }

    private var sortButton: some View {
        Button {

        } label: {
            Image(.sort)
                .foregroundStyle(.appTextPrimary)
        }
    }

    private func showConfirmation(for nft: NFTModel) {
        selectedNFT = nft
        isDeleting = true
    }

    private func hideConfirmation() {
        isDeleting = false
        selectedNFT = nil
    }

    private func confirmDelete(_ nft: NFTModel) {
        withAnimation(.easeInOut(duration: 0.2)) {
            viewModel.remove(nft)
        }
        hideConfirmation()
    }
}

#Preview {
    CartView()
}
