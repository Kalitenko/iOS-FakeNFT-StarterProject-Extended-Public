//
//  Array+Extensions.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 21.02.2026.
//

import Foundation

extension Array where Element: Hashable {
    func uniquedPreservingOrder() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}
