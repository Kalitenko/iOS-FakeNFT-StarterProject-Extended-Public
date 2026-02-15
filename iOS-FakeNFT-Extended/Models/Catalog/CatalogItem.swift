//
//  CatalogItem.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 10.02.2026.
//

import Foundation

struct CatalogItem: Hashable {
    let id: String
    let name: String
    let description: String
    let count: Int
    let cover: String
    let elements: [CollectionItem]
    let author: String
    let website: String
}

extension CatalogItem {
    private static let description = "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей."
    
    static let mockItems: [CatalogItem] = [
        CatalogItem(id: "1", name: "Beige", description: description, count: 21, cover: "Beige", elements: CollectionItem.mockItems, author: "John Doe", website: "mock.author"),
        CatalogItem(id: "2", name: "Blue", description: description, count: 15, cover: "Blue", elements: CollectionItem.mockItems, author: "John Doe", website: "mock.author"),
        CatalogItem(id: "3", name: "Brown", description: description, count: 24, cover: "Brown", elements: [], author: "John Doe", website: "mock.author"),
        CatalogItem(id: "4", name: "Gray", description: description, count: 60, cover: "Gray", elements: CollectionItem.mockItems, author: "John Doe", website: "mock.author"),
        CatalogItem(id: "5", name: "Green", description: description, count: 12, cover: "Green", elements: CollectionItem.mockItems, author: "John Doe", website: "mock.author"),
        CatalogItem(id: "6", name: "Peach", description: description, count: 33, cover: "Peach", elements: CollectionItem.mockItems, author: "John Doe", website: "mock.author"),
        CatalogItem(id: "7", name: "Pink", description: description, count: 42, cover: "Pink", elements: CollectionItem.mockItems, author: "John Doe", website: "mock.author"),
        CatalogItem(id: "8", name: "White", description: description, count: 21, cover: "White", elements: CollectionItem.mockItems, author: "John Doe", website: "mock.author"),
        CatalogItem(id: "9", name: "Yellow", description: description, count: 24, cover: "Yellow", elements: CollectionItem.mockItems, author: "John Doe", website: "mock.author"),
        CatalogItem(id: "10", name: "Test Dark", description: description, count: 0, cover: "Test Dark", elements: CollectionItem.mockItems, author: "John Doe", website: "mock.author"),
        CatalogItem(id: "11", name: "Test Dark", description: description, count: 0, cover: "Test Dark", elements: CollectionItem.mockItems, author: "John Doe", website: "mock.author"),
        CatalogItem(id: "12", name: "Test Light", description: description, count: 0, cover: "Test Light", elements: CollectionItem.mockItems, author: "John Doe", website: "mock.author"),
        CatalogItem(id: "13", name: "Test Dark", description: description, count: 0, cover: "Test Dark", elements: CollectionItem.mockItems, author: "John Doe", website: "mock.author"),
        CatalogItem(id: "14", name: "Test Light", description: description, count: 0, cover: "Test Light", elements: CollectionItem.mockItems, author: "John Doe", website: "mock.author"),
        CatalogItem(id: "15", name: "Test Dark", description: description, count: 0, cover: "Test Dark", elements: CollectionItem.mockItems, author: "John Doe", website: "mock.author"),
        CatalogItem(id: "16", name: "Test Dark", description: description, count: 0, cover: "Test Dark", elements: CollectionItem.mockItems, author: "John Doe", website: "mock.author"),
        CatalogItem(id: "17", name: "Test Light", description: description, count: 0, cover: "Test Light", elements: CollectionItem.mockItems, author: "John Doe", website: "mock.author"),
        CatalogItem(id: "18", name: "Test Dark", description: description, count: 0, cover: "Test Dark", elements: CollectionItem.mockItems, author: "John Doe", website: "mock.author"),
        CatalogItem(id: "19", name: "Test Light", description: description, count: 0, cover: "Test Light", elements: CollectionItem.mockItems, author: "John Doe", website: "mock.author"),
        CatalogItem(id: "20", name: "Test Dark", description: description, count: 0, cover: "Test Dark", elements: CollectionItem.mockItems, author: "John Doe", website: "mock.author")
    ]
    
    static let mock = CatalogItem(id: "6", name: "Peach", description: description, count: 33, cover: "Peach", elements: CollectionItem.mockItems, author: "John Doe", website: "mock.author")
}
