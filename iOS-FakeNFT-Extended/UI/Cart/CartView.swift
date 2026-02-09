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
            VStack {
                itemsList
                    .padding(.top, 20)
            }
            .background(.appBackground)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {

                    } label: {
                        Image(.sort)
                            .foregroundStyle(.appTextPrimary)
                    }
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
}

#Preview {
    CartView()
}
