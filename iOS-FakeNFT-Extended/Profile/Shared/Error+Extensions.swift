//
//  Error+Extensions.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 25/03/2026.
//
import Foundation

extension Error {
    var isCancelled: Bool {
        (self as? URLError)?.code == .cancelled
    }
}
