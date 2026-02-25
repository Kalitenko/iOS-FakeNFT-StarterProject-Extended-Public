//
//  CurrencyListView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 25.02.2026.
//

import SwiftUI

struct CurrencyListView: View {
    let viewModel: CartViewModel

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    private var isErrorAlertPresented: Binding<Bool> {
        Binding {
            viewModel.currencyErrorMessage != nil
        } set: { isPresented in
            if !isPresented {
                viewModel.currencyErrorMessage = nil
            }
        }
    }

    var body: some View {
        VStack {
            switch viewModel.currencyListState {
            case .loading:
                LoadingPlaceholderView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .empty:
                emptyState
            case .content:
                currenciesGrid
                Spacer()
                bottomPanel
            }
        }
        .background(.appBackground)
        .ignoresSafeArea(.all, edges: .bottom)
        .task {
            await viewModel.loadCurrencies()
        }
        .alert(
            L10n.Alerts.dataLoadFailed,
            isPresented: isErrorAlertPresented
        ) {
            Button(L10n.Common.retry) { Task { await viewModel.loadCurrencies() } }
            Button(L10n.Common.cancel, role: .cancel) { viewModel.currencyErrorMessage = nil }
        }
    }

    private var currenciesGrid: some View {
        LazyVGrid(columns: columns, spacing: 7) {
            ForEach(viewModel.currencies) { currency in
                Button {
                    viewModel.selectCurrency(currency)
                    print("Выбрана валюта \(currency)")
                } label: {
                    CurrencyCell(
                        currency: currency,
                        isSelected: viewModel.isCurrencySelected(currency)
                    )
                }
            }
        }
        .padding(.top, 20)
        .padding(.horizontal, 16)
    }

    private var bottomPanel: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(L10n.Cart.agreementText)
                    .font(.smallText)
                Text(L10n.Cart.userAgreement)
                    .font(.smallText)
            }
            ActionButton(title: L10n.Cart.pay) {

            }
            .padding(.bottom, 16)
        }
        .padding(16)
        .background(.appSurfaceBackground)
        .clipShape(.rect(topLeadingRadius: 12, topTrailingRadius: 12))
    }

    private var emptyState: some View {
        Text(L10n.Cart.noCurrencies)
            .font(.title)
            .foregroundStyle(.appTextPrimary)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
