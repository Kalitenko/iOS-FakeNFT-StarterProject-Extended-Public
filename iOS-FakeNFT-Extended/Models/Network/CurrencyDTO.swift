//
//  CurrencyDTO.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 18.02.2026.
//

import Foundation

struct CurrencyDTO: Decodable, Sendable {
    let title: String
    let name: String
    let image: String
    let id: String
}
