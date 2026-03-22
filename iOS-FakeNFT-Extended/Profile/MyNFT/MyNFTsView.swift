//
//  MyNFTsView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 27/02/2026.
//

import SwiftUI

struct MyNFTsView: View {
    
    @Environment(ServicesAssembly.self) private var services
    @State private var isSortPresented = false
    @State private var sort: MyNFTSort = .name
    @State private var nfts: [NftDTOCart] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    private enum MyNFTSort {
        case price
        case rating
        case name
    }
    
    private var sortedNfts: [NftDTOCart] {
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
    
    private var isEmpty: Bool { !isLoading && sortedNfts.isEmpty }
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if isEmpty {
                MyNFTEmptyView()
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(sortedNfts, id: \.id) { nft in
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
        .task {
            await loadMyNFTs()
        }
        .alert(
            L10n.Alerts.somethingWentWrong,
            isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )
        ) {
            Button(L10n.Alerts.okay, role: .cancel) {
                errorMessage = nil
            }
        } message: {
            Text(errorMessage ?? "")
        }
    }
    
    @MainActor
    private func loadMyNFTs() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let profile = try await services.commonProfileService.fetchProfile()
            
            let items = try await withThrowingTaskGroup(of: NftDTOCart.self) { group in
                for id in profile.nfts {
                    group.addTask {
                        try await services.nftService.loadNft(id: id)
                    }
                }
                
                var loaded: [NftDTOCart] = []
                for try await item in group {
                    loaded.append(item)
                }
                return loaded
            }
            
            nfts = items
        } catch let error as URLError where error.code == .cancelled {
            return
        } catch {
            errorMessage = L10n.Alerts.dataLoadFailed
        }
    }
}

#Preview("Empty state") {
    NavigationStack {
        MyNFTsView()
    }
}
