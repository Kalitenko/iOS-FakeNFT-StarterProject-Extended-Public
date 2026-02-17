//
//  CartViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 09.02.2026.
//
import SwiftUI

@Observable
final class CartViewModel {
    private let cartService: CartService
    var items: [NFTModel] = []
    var isLoading: Bool = false
    var errorMessage: String?

    var isEmpty: Bool { !isLoading && items.isEmpty }

    var itemsAmount: Int { items.count }

    var totalPrice: String {
        let sum = items.compactMap { parseETH($0.price) }.reduce(0, +)

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        return formatter.string(from: NSNumber(value: sum)) ?? "\(sum)"
    }

    init(cartService: CartService) {
        self.cartService = cartService
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            items = try await cartService.loadCartItems()
        } catch {
            errorMessage = "Не удалось загрузить корзину: \(error)"
            items = []
        }
        isLoading = false
    }

    func remove(_ nft: NFTModel) {
        items.removeAll { $0.id == nft.id }
    }

    private func parseETH(_ text: String) -> Double? {
        let cleaned = text
            .replacingOccurrences(of: " ETH", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ",", with: ".")
        return Double(cleaned)
    }
}
