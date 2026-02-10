//
//  CatalogItem.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 10.02.2026.
//

import Foundation

struct CatalogItem {
    let id: String
    let name: String
    let count: Int
    let cover: String
}

extension CatalogItem {
    static let mockItems: [CatalogItem] = [
        CatalogItem(id: "1", name: "Beige", count: 21, cover: "Beige"),
        CatalogItem(id: "2", name: "Blue", count: 15, cover: "Blue"),
        CatalogItem(id: "3", name: "Brown", count: 24, cover: "Brown"),
        CatalogItem(id: "4", name: "Gray", count: 60, cover: "Gray"),
        CatalogItem(id: "5", name: "Green", count: 12, cover: "Green"),
        CatalogItem(id: "6", name: "Peach", count: 33, cover: "Peach"),
        CatalogItem(id: "7", name: "Pink", count: 42, cover: "Pink"),
        CatalogItem(id: "8", name: "White", count: 21, cover: "White"),
        CatalogItem(id: "9", name: "Yellow", count: 24, cover: "Yellow")
    ]
    
    static let mock = CatalogItem(id: "6", name: "Peach", count: 33, cover: "Peach")
}
