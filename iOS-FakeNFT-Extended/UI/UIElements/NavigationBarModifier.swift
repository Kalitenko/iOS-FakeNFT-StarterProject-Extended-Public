//
//  NavigationBarModifier.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 13.02.2026.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
    
    @Environment(\.dismiss) private var dismiss
    
    let title: String?
    let hidesBackground: Bool
    let hidesLeading: Bool
    let leadingAction: (() -> Void)?
    let trailingAction: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.appBackground, for: .navigationBar)
            .toolbarBackground(
                hidesBackground ? .hidden : .automatic,
                for: .navigationBar
            )
            .toolbar {
                if !hidesLeading {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            leadingAction?() ?? dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                    }
                }
                
                if let title {
                    ToolbarItem(placement: .principal) {
                        Text(title)
                    }
                }
                
                if let trailingAction {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: trailingAction) {
                            Image(.sort)
                        }
                    }
                }
            }
            .foregroundStyle(.appTextPrimary)
            .font(.title)
    }
}

extension View {
    func customNavigationBar(
        title: String? = nil,
        hidesBackground: Bool = false,
        hidesLeading: Bool = false,
        leadingAction: (() -> Void)? = nil,
        trailingAction: (() -> Void)? = nil
    ) -> some View {
        modifier(
            NavigationBarModifier(
                title: title,
                hidesBackground: hidesBackground,
                hidesLeading: hidesLeading,
                leadingAction: leadingAction,
                trailingAction: trailingAction
            )
        )
    }
}

#Preview("Применение по умолчанию") {
    NavigationStack {
        NavigationLink("Open") {
            Text("Применение по умолчанию")
                .customNavigationBar()
        }
    }
}

#Preview("Кнопка назад с заголовком") {
    NavigationStack {
        NavigationLink("Open") {
            Text("Кнопка назад с заголовком")
                .customNavigationBar(title: "Заголовок")
        }
    }
}

#Preview("Только trailing кнопка") {
    NavigationStack {
        Text("Только trailing кнопка")
            .customNavigationBar(hidesLeading: true,
                                 trailingAction: {
                print("Sort tapped")
            }
            )
    }
}

#Preview("Кнопки назад и сортировки + заголовок") {
    NavigationStack {
        NavigationLink("Open") {
            Text("Кнопки назад и сортировки + заголовок")
                .customNavigationBar(
                    title: "Collection",
                    trailingAction: {
                        print("Sort tapped")
                    }
                )
        }
    }
}

#Preview("Использование другой навигации вместо стандартного dismiss") {
    NavigationStack {
        NavigationLink("Open") {
            Text("Своя навигация")
                .customNavigationBar(
                    leadingAction: {
                        print("Своя навигация")
                    }
                )
        }
    }
}

#Preview("Скрытие navbar при прокрутке") {
    NavigationStack {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(0..<30) { index in
                    Text("Item \(index)")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.gray.opacity(0.2))
                }
            }
            .padding()
        }
        .customNavigationBar(
            title: "Скрытый NavBar",
            hidesBackground: true
        )
    }
}
