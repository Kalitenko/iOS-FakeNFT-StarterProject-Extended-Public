//
//  NFTMock.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 27/02/2026.
//
import Foundation

struct NFTMock: Identifiable {
    let id = UUID()
    let name: String
    let author: String
    let price: Double
    let imageName: String
    let rating: Int
}

extension NFTMock {

    static let sampleFavoritesNFTs: [NFTMock] = [
        NFTMock(
            name: "Archie",
            author: "John Doe",
            price: 1.78,
            imageName: "ArchieNFT",
            rating: 1
        ),
        NFTMock(
            name: "Pixi",
            author: "John Doe",
            price: 1.78,
            imageName: "PixiNFT",
            rating: 3
        ),
        NFTMock(
            name: "Melissa",
            author: "John Doe",
            price: 1.78,
            imageName: "MelissaNFT",
            rating: 5
        ),
        NFTMock(
            name: "April",
            author: "John Doe",
            price: 1.78,
            imageName: "AprilNFT",
            rating: 2
        ),
        NFTMock(
            name: "Daisy",
            author: "John Doe",
            price: 1.78,
            imageName: "DaisyNFT",
            rating: 1
        ),
        NFTMock(
            name: "Lilo",
            author: "John Doe",
            price: 1.78,
            imageName: "LiloNFT",
            rating: 4
        )
    ]
}
