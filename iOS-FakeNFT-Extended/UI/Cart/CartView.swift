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

                Text("Итоги")
            }
            .background(.appBackground)
        }
    }

    private var itemsList: some View {
        List {
            Text("Cell 1")
            Text("Cell 2")
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
