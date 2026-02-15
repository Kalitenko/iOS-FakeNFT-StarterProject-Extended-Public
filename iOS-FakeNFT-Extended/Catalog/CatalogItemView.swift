//
//  CatalogItemView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 10.02.2026.
//

import SwiftUI

struct CatalogItemView: View {
    
    let item: CatalogItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(item.cover)
                .resizable()
                .scaledToFill()
                .frame(height: 140, alignment: .top)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 12))
            HStack(spacing: 4) {
                Text("\(item.name)")
                Text("(\(item.count))")
            }
            .foregroundStyle(.appTextPrimary)
            .font(.title)
        }
        .background(.clear)
        
    }
}

#Preview {
    CatalogItemView(item: CatalogItem.mock)
        .padding(16)
        .background(Color(.yellow))
}
