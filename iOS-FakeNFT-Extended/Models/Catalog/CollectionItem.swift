//
//  CollectionItem.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 10.02.2026.
//

import Foundation

struct CollectionItem: Hashable {
    let id: String
    let name: String
    let imageURLs: [String]
    let rating: Int
    let price: Decimal
    let isFavorite: Bool
    let isInCart: Bool
    
    init(id: String, name: String, imageURLs: [String], rating: Int, price: Decimal, isFavorite: Bool, isInCart: Bool = false) {
        self.id = id
        self.name = name
        self.imageURLs = imageURLs
        self.rating = rating
        self.price = price
        self.isFavorite = isFavorite
        self.isInCart = isInCart
    }
}

extension CollectionItem {
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
