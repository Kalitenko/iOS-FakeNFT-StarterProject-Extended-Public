//
//  CartViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 09.02.2026.
//
import SwiftUI

enum CartSortOption: String {
    case name
    case price
    case rating
}

@Observable @MainActor
final class CartViewModel {
    enum CartState {
        case loading
        case empty
        case content
        case updating
    }

    enum CurrencyListState {
        case loading
        case empty
        case content
    }

    var state: CartState {
        if isLoading {
            return .loading
        }
        if items.isEmpty {
            return .empty
        }
        if isUpdating {
            return .updating
        }
        return .content
    }

    var currencyListState: CurrencyListState {
        if isCurrenciesLoading {
            return .loading
        }
        if currencies.isEmpty {
            return .empty
        }
        return .content
    }

    private let cartService: CartServiceProtocol

    // MARK: - Cart state
    var items: [NFTModel] = []
    var isLoading: Bool = false
    var isUpdating: Bool = false
    var errorMessage: String?

    private(set) var selectedSortOption: CartSortOption = .name

    // MARK: - Currency state
    var currencies: [CurrencyModel] = []
    var isCurrenciesLoading: Bool = false
    var currencyErrorMessage: String?
    var selectedCurrencyID: String?

    // MARK: - Payment state
    var isPaymentInProgress: Bool = false
    var paymentErrorMessage: String?
    var isShowingSuccessView: Bool = false

    var isEmpty: Bool { items.isEmpty }

    var itemsAmount: Int { items.count }

    var totalPrice: String {
        let sum = items.compactMap { parseETH($0.price) }.reduce(0, +)

        let formatter = NumberFormatterManager.formatter
        return formatter.string(from: NSNumber(value: sum)) ?? "\(sum)"
    }

    init(cartService: CartServiceProtocol) {
        self.cartService = cartService
    }

    func load(sortedBy sortOption: CartSortOption = .name) async {
        isLoading = true
        errorMessage = nil
        do {
            let loadedItems = try await cartService.loadCartItems()
            items = sort(items: loadedItems, by: sortOption)
            selectedSortOption = sortOption
        } catch {
            errorMessage = "Не удалось получить данные: \(error)"
            print(errorMessage ?? "")
            items = []
        }
        isLoading = false
    }

    func applySort(_ sortOption: CartSortOption) {
        selectedSortOption = sortOption
        items = sort(items: items, by: sortOption)
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

    func loadCurrencies() async {
        guard !isCurrenciesLoading else { return }
        isCurrenciesLoading = true
        currencyErrorMessage = nil

        do {
            let loadedCurrencies = try await cartService.getCurrencies()
            currencies = loadedCurrencies
        } catch {
            currencies = []
            currencyErrorMessage = "Не удалось получить список валют \(error)"
            print(currencyErrorMessage ?? "")
        }
        isCurrenciesLoading = false
    }

    func selectCurrency(_ currency: CurrencyModel) {
        selectedCurrencyID = currency.id
    }

    func isCurrencySelected(_ currency: CurrencyModel) -> Bool {
        selectedCurrencyID == currency.id
    }

    func completeOrder() async {
        guard !isPaymentInProgress else { return }
        guard let selectedCurrencyID else { return }

        isPaymentInProgress = true
        paymentErrorMessage = nil

        do {
            let isSuccess = try await cartService.completeOrder(
                nftIDs: items.map(\.id),
                currencyID: selectedCurrencyID
            )
            if isSuccess {
                items = []
                self.selectedCurrencyID = nil
                isShowingSuccessView = true
            } else {
                paymentErrorMessage = "Не удалось выполнить заказ"
            }
        } catch {
            paymentErrorMessage = "Не удалось выполнить заказ \(error)"
            print(paymentErrorMessage ?? "")
        }
        isPaymentInProgress = false
    }

    private func sort(items: [NFTModel], by option: CartSortOption) -> [NFTModel] {
        switch option {
        case .name:
            return items.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        case .price:
            return items.sorted {
                parseETH($0.price) ?? 0 < parseETH($1.price) ?? 0
            }
        case .rating:
            return items.sorted { $0.rating > $1.rating }
        }
    }

    private func parseETH(_ text: String) -> Double? {
        let cleaned = text
            .replacingOccurrences(of: " ETH", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ",", with: ".")
        return Double(cleaned)
    }
}
