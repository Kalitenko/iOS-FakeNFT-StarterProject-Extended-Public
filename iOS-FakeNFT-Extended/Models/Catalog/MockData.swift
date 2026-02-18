//
//  MockData.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 16.02.2026.
//

import Foundation

enum MockData {
    
    enum Catalog {
        private static let description = "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей."
        
        static let mockItems: [CatalogItem] = [
            CatalogItem(id: "1", name: "Beige", description: description, count: 21, cover: "Beige", nftIDs: [], author: "John Doe", website: "mock.author"),
            CatalogItem(id: "2", name: "Blue", description: description, count: 15, cover: "Blue", nftIDs: [], author: "John Doe", website: "mock.author"),
            CatalogItem(id: "3", name: "Brown", description: description, count: 24, cover: "Brown", nftIDs: [], author: "John Doe", website: "mock.author"),
            CatalogItem(id: "4", name: "Gray", description: description, count: 60, cover: "Gray", nftIDs: [], author: "John Doe", website: "mock.author"),
            CatalogItem(id: "5", name: "Green", description: description, count: 12, cover: "Green", nftIDs: [], author: "John Doe", website: "mock.author"),
            CatalogItem(id: "6", name: "Peach", description: description, count: 33, cover: "Peach", nftIDs: [], author: "John Doe", website: "mock.author"),
            CatalogItem(id: "7", name: "Pink", description: description, count: 42, cover: "Pink", nftIDs: [], author: "John Doe", website: "mock.author"),
            CatalogItem(id: "8", name: "White", description: description, count: 21, cover: "White", nftIDs: [], author: "John Doe", website: "mock.author"),
            CatalogItem(id: "9", name: "Yellow", description: description, count: 24, cover: "Yellow", nftIDs: [], author: "John Doe", website: "mock.author"),
            CatalogItem(id: "10", name: "Test Dark", description: description, count: 0, cover: "Test Dark", nftIDs: [], author: "John Doe", website: "mock.author"),
            CatalogItem(id: "11", name: "Test Dark", description: description, count: 0, cover: "Test Dark", nftIDs: [], author: "John Doe", website: "mock.author"),
            CatalogItem(id: "12", name: "Test Light", description: description, count: 0, cover: "Test Light", nftIDs: [], author: "John Doe", website: "mock.author"),
            CatalogItem(id: "13", name: "Test Dark", description: description, count: 0, cover: "Test Dark", nftIDs: [], author: "John Doe", website: "mock.author"),
            CatalogItem(id: "14", name: "Test Light", description: description, count: 0, cover: "Test Light", nftIDs: [], author: "John Doe", website: "mock.author"),
            CatalogItem(id: "15", name: "Test Dark", description: description, count: 0, cover: "Test Dark", nftIDs: [], author: "John Doe", website: "mock.author"),
            CatalogItem(id: "16", name: "Test Dark", description: description, count: 0, cover: "Test Dark", nftIDs: [], author: "John Doe", website: "mock.author"),
            CatalogItem(id: "17", name: "Test Light", description: description, count: 0, cover: "Test Light", nftIDs: [], author: "John Doe", website: "mock.author"),
            CatalogItem(id: "18", name: "Test Dark", description: description, count: 0, cover: "Test Dark", nftIDs: [], author: "John Doe", website: "mock.author"),
            CatalogItem(id: "19", name: "Test Light", description: description, count: 0, cover: "Test Light", nftIDs: [], author: "John Doe", website: "mock.author"),
            CatalogItem(id: "20", name: "Test Dark", description: description, count: 0, cover: "Test Dark", nftIDs: [], author: "John Doe", website: "mock.author")
        ]
        
        static let mock = CatalogItem(id: "6", name: "Peach", description: description, count: 33, cover: "Peach", nftIDs: [], author: "John Doe", website: "mock.author")
    }
    
    enum Collections {
        static let mockItems: [CollectionItem] = [
            CollectionItem(
                id: "1",
                name: "Archie",
                imageURLs: [
                    "Peach_Archie_1",
                    "Peach_Archie_2",
                    "Peach_Archie_3"
                ],
                rating: Int.random(in: 1...5),
                price: 12.345,
                isFavorite: Bool.random()
            ),
            CollectionItem(
                id: "2",
                name: "Art",
                imageURLs: [
                    "Peach_Art_1",
                    "Peach_Art_2",
                    "Peach_Art_3"
                ],
                rating: Int.random(in: 1...5),
                price: 6.789,
                isFavorite: Bool.random(),
                isInCart: true
            ),
            CollectionItem(
                id: "3",
                name: "Biscuit",
                imageURLs: [
                    "Peach_Biscuit_1",
                    "Peach_Biscuit_2",
                    "Peach_Biscuit_3"
                ],
                rating: Int.random(in: 1...5),
                price: Decimal(Double.random(in: 0...25)),
                isFavorite: Bool.random()
            ),
            CollectionItem(
                id: "4",
                name: "Daisy",
                imageURLs: [
                    "Peach_Daisy_1",
                    "Peach_Daisy_2",
                    "Peach_Daisy_3"
                ],
                rating: Int.random(in: 1...5),
                price: Decimal(Double.random(in: 0...25)),
                isFavorite: Bool.random(),
                isInCart: true
            ),
            CollectionItem(
                id: "5",
                name: "Nacho",
                imageURLs: [
                    "Peach_Nacho_1",
                    "Peach_Nacho_2",
                    "Peach_Nacho_3"
                ],
                rating: Int.random(in: 1...5),
                price: Decimal(Double.random(in: 0...25)),
                isFavorite: Bool.random()
            ),
            CollectionItem(
                id: "6",
                name: "Oreo",
                imageURLs: [
                    "Peach_Oreo_1",
                    "Peach_Oreo_2",
                    "Peach_Oreo_3"
                ],
                rating: Int.random(in: 1...5),
                price: Decimal(Double.random(in: 0...25)),
                isFavorite: Bool.random()
            ),
            CollectionItem(
                id: "7",
                name: "Pixi",
                imageURLs: [
                    "Peach_Pixi_1",
                    "Peach_Pixi_2",
                    "Peach_Pixi_3"
                ],
                rating: Int.random(in: 1...5),
                price: Decimal(Double.random(in: 0...25)),
                isFavorite: Bool.random()
            ),
            CollectionItem(
                id: "8",
                name: "Ruby",
                imageURLs: [
                    "Peach_Ruby_1",
                    "Peach_Ruby_2",
                    "Peach_Ruby_3"
                ],
                rating: Int.random(in: 1...5),
                price: Decimal(Double.random(in: 0...25)),
                isFavorite: Bool.random()
            ),
            CollectionItem(
                id: "9",
                name: "Susan",
                imageURLs: [
                    "Peach_Susan_1",
                    "Peach_Susan_2",
                    "Peach_Susan_3"
                ],
                rating: Int.random(in: 1...5),
                price: Decimal(Double.random(in: 0...25)),
                isFavorite: Bool.random()
            ),
            CollectionItem(
                id: "10",
                name: "Tater",
                imageURLs: [
                    "Peach_Tater_1",
                    "Peach_Tater_2",
                    "Peach_Tater_3"
                ],
                rating: Int.random(in: 1...5),
                price: Decimal(Double.random(in: 0...25)),
                isFavorite: Bool.random()
            ),
            CollectionItem(
                id: "11",
                name: "Zoe",
                imageURLs: [
                    "Peach_Zoe_1",
                    "Peach_Zoe_2",
                    "Peach_Zoe_3"
                ],
                rating: Int.random(in: 1...5),
                price: Decimal(Double.random(in: 0...25)),
                isFavorite: Bool.random()
            ),
            CollectionItem(
                id: "12",
                name: "TEST",
                imageURLs: [],
                rating: Int.random(in: 1...5),
                price: 0,
                isFavorite: Bool.random()
            )
        ]
        
        static let mockIsLikedAndInCart = CollectionItem(
            id: "1",
            name: "Archie",
            imageURLs: [
                "Peach_Archie_1",
                "Peach_Archie_2",
                "Peach_Archie_3"
            ],
            rating: 3,
            price: 12.34,
            isFavorite: true,
            isInCart: true
        )
        
        static let mockIsNotLikedAndInCart = CollectionItem(
            id: "1",
            name: "Archie",
            imageURLs: [
                "Peach_Archie_1",
                "Peach_Archie_2",
                "Peach_Archie_3"
            ],
            rating: 3,
            price: 12.34,
            isFavorite: false
        )
        
        static let mockWithoutImages = CollectionItem(
            id: "1",
            name: "Archie",
            imageURLs: [],
            rating: 3,
            price: 12.34,
            isFavorite: false,
            isInCart: true
        )
    }
}
