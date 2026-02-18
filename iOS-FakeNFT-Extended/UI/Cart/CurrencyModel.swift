//
//  CurrencyModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 18.02.2026.
//

import Foundation

struct CurrencyModel: Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let name: String
    let imageURL: URL

    init?(id: String, title: String, name: String, imageURLString: String) {
        guard let url = URL(string: imageURLString) else { return nil }
        self.id = id
        self.title = title
        self.name = name
        self.imageURL = url
    }
}
