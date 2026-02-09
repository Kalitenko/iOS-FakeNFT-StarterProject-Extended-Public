//
//  CartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 09.02.2026.
//

import SwiftUI

struct CartView: View {
    var body: some View {
        NavigationStack {
            VStack {
                itemsList

                Text("")
            }
            .background(.appBackground)
        }
    }

    private var itemsList: some View {
        List {
            NFTCartCell(nft: NFTModel(
                name: "April",
                price: "1,78 ETH",
                rating: 4,
                image: Image(.april))
            )
            NFTCartCell(nft: NFTModel(
                name: "April",
                price: "1,78 ETH",
                rating: 4,
                image: Image(.april))
            )
        }
        .listStyle(.inset)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {

                } label: {
                    Image(.sort)
                        .foregroundStyle(.appTextPrimary)
                }
            }
        }
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    CartView()
}
