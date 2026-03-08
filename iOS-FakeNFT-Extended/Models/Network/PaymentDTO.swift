//
//  PaymentDTO.swift
//  iOS-FakeNFT-Extended
//
//  Created by Stepan Chuiko on 19.02.2026.
//

import Foundation

struct PaymentDTO: Decodable, Sendable {
    let success: Bool
    let orderId: String
    let id: String
}
