//
//  CartViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 09.02.2026.
//
import SwiftUI

@Observable
final class CartViewModel {
    var items: [NFTModel] = []

    var itemsMock: [NFTModel] = [
        NFTModel(name: "April", price: "1,78 ETH", rating: 1, image: Image(.april)),
        NFTModel(name: "Greena", price: "1,78 ETH", rating: 3, image: Image(.greena)),
        NFTModel(name: "Spring", price: "1,78 ETH", rating: 5, image: Image(.spring))
    ]

    init(items: [NFTModel] = []) {
        self.items = items
    }
}
