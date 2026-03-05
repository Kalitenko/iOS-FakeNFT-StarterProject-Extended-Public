//
//  MyNFTsView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 27/02/2026.
//

import SwiftUI

struct MyNFTsView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var isSortPresented = false
    @State private var sort: MyNFTSort = .name

    let nfts: [NFTMock]

    private enum MyNFTSort {
        case price
        case rating
        case name
    }

    private var sortedNfts: [NFTMock] {
        switch sort {
        case .price:
            nfts.sorted { $0.price < $1.price }
        case .rating:
            nfts.sorted { $0.rating > $1.rating }
        case .name:
            nfts.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        }
    }
    
    private var isEmpty: Bool { sortedNfts.isEmpty }

    var body: some View {
        Group {
            if isEmpty {
                MyNFTEmptyView()
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(sortedNfts) { nft in
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
            title: isEmpty ? nil : L10n.Profile.myNFT,
            hidesBackground: false,
            trailingAction: isEmpty ? nil : { isSortPresented = true }
        )

        .confirmationDialog(L10n.Sort.title, isPresented: $isSortPresented, titleVisibility: .visible) {
            Button(L10n.Sort.byPrice) { sort = .price }
            Button(L10n.Sort.byRating) { sort = .rating }
            Button(L10n.Sort.byName) { sort = .name }
            Button(L10n.Common.close, role: .cancel) { }
        }
    }
}

#Preview("Empty state") {
    NavigationStack {
        MyNFTsView(nfts: [])
    }
}

#Preview("With data") {
    NavigationStack {
        MyNFTsView(nfts: NFTMock.sampleFavoritesNFTs)
    }
}
