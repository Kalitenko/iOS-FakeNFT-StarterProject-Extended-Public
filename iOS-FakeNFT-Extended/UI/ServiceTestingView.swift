//
//  ServiceTestingView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 17.02.2026.
//

import SwiftUI

struct ServiceTestingView: View {
    
    @State private var page = 0
    @State private var limit = 5
    
    @Environment(ServicesAssembly.self) var servicesAssembly
    
    var body: some View {
        VStack(spacing: 20) {
            
            Image(systemName: "testtube.2")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            VStack {
                Stepper("Page: \(page)", value: $page, in: 0...100)
                Stepper("Limit: \(limit)", value: $limit, in: 0...100)
            }
            .padding()
            
            Button("Fetch Catalog") {
                Task { await fetchCatalog(page: page, limit: limit) }
            }
            
            Button("Fetch NFTs") {
                Task { await fetchNFTList(page: page, limit: limit) }
            }
        }
        .padding()
    }
    
    private func fetchCatalog(page: Int, limit: Int) async {
        do {
            let service = servicesAssembly.catalogService
            
            print("Fetching catalog...")
            let response = try await service.fetchCatalog(page: page, limit: limit)
            
            print("Successfully fetched catalog: \(response)")
        } catch {
            print("Error fetching catalog: \(error)")
        }
    }
    
    private func fetchNFTList(page: Int, limit: Int) async {
        do {
            let service = servicesAssembly.catalogService
            
            print("Fetching NFTs...")
            let response = try await service.fetchNFTs(page: page, limit: limit)
            
            print("Successfully fetched NFTs: \(response)")
        } catch {
            print("Error fetching NFTs: \(error)")
        }
    }
}

#Preview {
    ServiceTestingView()
        .environment(ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl()))
}
