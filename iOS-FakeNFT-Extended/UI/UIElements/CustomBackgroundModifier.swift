//
//  CustomBackgroundModifier.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 13.02.2026.
//

import SwiftUI

struct CustomBackgroundModifier: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        ZStack {
            Color(color).ignoresSafeArea()
            content
        }
    }
}

extension View {
    func customBackground(color: Color = .appBackground) -> some View {
        modifier(CustomBackgroundModifier(color: color))
    }
}

#Preview("Применение по умолчанию") {
    VStack {
        Text("Применение по умолчанию")
            .padding()
        
        List(0..<5) { number in
            Text("Item \(number)")
                .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .frame(height: 200)
    }
    .customBackground()
}

#Preview("Применение с цветом") {
    VStack {
        Text("Применение с цветом")
            .padding()
        
        List(["Apple", "Banana", "Cherry"], id: \.self) { fruit in
            Text(fruit)
                .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .frame(height: 200)
    }
    .customBackground(color: .red)
}

#Preview("Применение для стиля insetGrouped и настройкой разных цветов") {
    VStack {
        Text("Применение с цветом")
            .padding()
        
        List(["Apple", "Banana", "Cherry"], id: \.self) { fruit in
            Text(fruit)
                .listRowBackground(Color.yellow)
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(.blue)
        .frame(height: 200)
    }
    .customBackground(color: .red)
}
