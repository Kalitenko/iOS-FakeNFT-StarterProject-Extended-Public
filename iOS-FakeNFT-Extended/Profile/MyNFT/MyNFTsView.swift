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
            return nfts.sorted { $0.price < $1.price }
        case .rating:
            return nfts.sorted { $0.rating > $1.rating }
        case .name:
            return nfts.sorted {
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
        .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Image("back.chevron")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(Color(uiColor: .appTextPrimary))
                        .frame(width: 44, height: 44, alignment: .leading)
                        .contentShape(Rectangle())
                        .padding(.leading, -8)
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("myNFT.backButton")
            }

            // Title + Sort — только если НЕ пусто
            if !isEmpty {
                ToolbarItem(placement: .principal) {
                    Text("Мои NFT")
                        .font(.system(size: 17, weight: .bold))
                        .frame(height: 22)
                        .foregroundStyle(Color(uiColor: .appTextPrimary))
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button { isSortPresented = true } label: {
                        Image("sort")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 42, height: 42)
                            .foregroundStyle(Color(uiColor: .appTextPrimary))
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("myNFT.sortButton")
                }
            }
        }
        .confirmationDialog("Сортировка", isPresented: $isSortPresented, titleVisibility: .visible) {
            Button("По цене") { sort = .price }
            Button("По рейтингу") { sort = .rating }
            Button("По названию") { sort = .name }
            Button("Закрыть", role: .cancel) { }
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
        MyNFTsView(nfts: NFTMock.sampleMyNFTs)
    }
}
