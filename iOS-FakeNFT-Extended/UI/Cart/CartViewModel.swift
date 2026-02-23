//
//  CartViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 09.02.2026.
//
import SwiftUI

@Observable @MainActor
final class CartViewModel {
    private let cartService: CartServiceProtocol

    var items: [NFTModel] = []
    var isLoading: Bool = false
    var isUpdating: Bool = false
    var errorMessage: String?

    var isEmpty: Bool { items.isEmpty }

    var isShowingToolbar: Bool { !isEmpty }

    var itemsAmount: Int { items.count }

    var totalPrice: String {
        let sum = items.compactMap { parseETH($0.price) }.reduce(0, +)

        let formatter = NumberFormatterManager.formatter
        return formatter.string(from: NSNumber(value: sum)) ?? "\(sum)"
    }

    init(cartService: CartServiceProtocol) {
        self.cartService = cartService
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            items = try await cartService.loadCartItems()
        } catch {
            errorMessage = "Не удалось получить данные: \(error)"
            print(errorMessage ?? "")
            items = []
        }
        isLoading = false
    }

    func deleteFromCart(nft: NFTModel) async {
        guard !isUpdating else { return }
        isUpdating = true
        errorMessage = nil

        let newIDs = items
            .filter { $0.id != nft.id }
            .map(\.id)

        do {
            _ = try await cartService.updateCart(nftIDs: newIDs)
            items.removeAll { $0.id == nft.id }
        } catch {
            errorMessage = "Не удалось удалить товар: \(error)"
            print(errorMessage ?? "")
        }
        isUpdating = false
    }

    // Test example
    func loadCurrencies() async {
        var currencies = [CurrencyModel]()
        do {
            currencies = try await cartService.getCurrencies()
        } catch {
            errorMessage = "Не удалось получить список валют \(error)"
            print(errorMessage ?? "")
        }
        print(currencies.first ?? "")
    }

    // Test example
    func completeOrder() async {
        guard !isUpdating else { return }
        isUpdating = true
        errorMessage = nil

        do {
            _ = try await cartService.completeOrder(nftIDs: items.map(\.id), currencyID: "2")
        } catch {
            errorMessage = "Не удалось выполнить заказ \(error)"
            print(errorMessage ?? "")
        }
        isUpdating = false
    }

    private func parseETH(_ text: String) -> Double? {
        let cleaned = text
            .replacingOccurrences(of: " ETH", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ",", with: ".")
        return Double(cleaned)
    }
}
