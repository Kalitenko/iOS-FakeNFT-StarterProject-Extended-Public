//
//  MyNFTEmptyView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 27/02/2026.
//

import SwiftUI

struct MyNFTEmptyView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("У Вас ещё нет NFT")
                .font(.system(size: 17, weight: .bold))
                .frame(height: 22)
                .foregroundStyle(Color(uiColor: .appTextPrimary))
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            Spacer()
        }
    }
}
