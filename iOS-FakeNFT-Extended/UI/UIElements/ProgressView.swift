//
//  ProgressView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 08.02.2026.
//

import SwiftUI

struct LoadingPlaceholderView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(.appProgressViewBackground)
            .frame(width: 82, height: 82)
            .overlay {
                CircularProgressView(tintColor: .appBlack)
            }
    }
}

struct CircularProgressView: View {
    
    var tintColor: Color = .appTextPrimary
    
    var body: some View {
        ProgressView()
            .scaleEffect(1.5)
            .progressViewStyle(.circular)
            .tint(tintColor)
    }
}

#Preview("LoadingPlaceholderView") {
    LoadingPlaceholderView()
}

#Preview("CircularProgressView") {
    CircularProgressView()
}

#Preview("Size") {
    VStack {
        CircularProgressView()
    }
    .frame(width: 30, height: 30)
    .background(.gray)
    .border(.red)
}
