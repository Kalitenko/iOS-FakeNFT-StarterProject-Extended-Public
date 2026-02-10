//
//  CartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 09.02.2026.
//

import SwiftUI

struct CartView: View {
    @State private var viewModel: CartViewModel

    init(viewModel: CartViewModel = CartViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                itemsList
                    .padding(.top, 20)
                summaryPanel
            }
            .background(.appBackground)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    sortButton
                }
            }
        }
    }

    private var itemsList: some View {
        List {
            ForEach(viewModel.itemsMock) { nft in
                NFTCartCell(nft: nft)
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
}

#Preview {
    CartView()
}
