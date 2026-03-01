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
    static let sampleMyNFTs: [NFTMock] = [
        NFTMock(
            name: "Lilo",
            author: "John Doe",
            price: 1.78,
            imageName: "LiloNFT",
            rating: 3
        ),
        NFTMock(
            name: "Spring",
            author: "John Doe",
            price: 1.78,
            imageName: "SpringNFT",
            rating: 3
        ),
        NFTMock(
            name: "April",
            author: "John Doe",
            price: 1.78,
            imageName: "AprilNFT",
            rating: 3
        )
    ]
}
