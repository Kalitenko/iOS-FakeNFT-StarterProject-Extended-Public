//
//  NumberFormatter.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 20.02.2026.
//
import Foundation

final class NumberFormatterManager {
    static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.decimalSeparator = ","
        return formatter
    }()
}
