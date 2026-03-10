//
//  SettingsStorage.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 26.02.2026.
//

import Foundation

enum StorageKeys: String {
    case catalogSort
}

protocol SettingsStorageProtocol: Actor {
    func set(_ value: String, forKey key: StorageKeys)
    func get(forKey key: StorageKeys) -> String?
}

actor UserDefaultsStorage: SettingsStorageProtocol {
    
    static let shared = UserDefaultsStorage()
    
    private let storage: UserDefaults = .standard
    
    func set(_ value: String, forKey key: StorageKeys) {
        storage.set(value, forKey: key.rawValue)
    }
    
    func get(forKey key: StorageKeys) -> String? {
        storage.string(forKey: key.rawValue)
    }
}
