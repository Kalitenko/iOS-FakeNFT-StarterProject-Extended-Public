//
//  FavoritesEmptyView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 01/03/2026.
//

import SwiftUI

struct FavoritesEmptyView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    private enum Layout {
        
        static let messageTopInset: CGFloat = 395
        static let messageHorizontalInset: CGFloat = 16
        
        static let messageFontSize: CGFloat = 17
        static let messageLineHeight: CGFloat = 22
        
        static let backIconSize: CGFloat = 18
        static let backTapArea: CGFloat = 44
        static let backLeadingInset: CGFloat = 8
        static let backTopInset: CGFloat = 4
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
            
            Text("У Вас ещё нет избранных NFT")
                .font(.system(size: Layout.messageFontSize, weight: .bold))
                .foregroundStyle(Color(uiColor: .appTextPrimary))
                .multilineTextAlignment(.center)
                .frame(height: Layout.messageLineHeight)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, Layout.messageHorizontalInset)
                .padding(.top, Layout.messageTopInset)
            
            Button { dismiss() } label: {
                Image("back.chevron")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Layout.backIconSize, height: Layout.backIconSize)
                    .foregroundStyle(Color(uiColor: .appTextPrimary))
                    .frame(width: Layout.backTapArea, height: Layout.backTapArea, alignment: .leading)
                    .contentShape(Rectangle())
                    .padding(.leading, Layout.backLeadingInset)
                    .padding(.top, Layout.backTopInset)
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("favorites.backButton")
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)       
    }
}

#Preview("Favorites Empty") {
    NavigationStack {
        FavoritesEmptyView()
    }
}
