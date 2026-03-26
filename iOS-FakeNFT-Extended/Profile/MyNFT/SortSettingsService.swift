//
//  SortSettingsService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 26/03/2026.
//

import Foundation

final class SortSettingsService {
    
    private enum Constants {
        static let sortKey = "myNFTs.sort"
    }
    
    func save(sort: MyNFTsViewModel.NFTSortType) {
        UserDefaults.standard.set(sort.rawValue, forKey: Constants.sortKey)
    }
    
    func load() -> MyNFTsViewModel.NFTSortType {
        let savedSort = UserDefaults.standard.string(forKey: Constants.sortKey)
        return MyNFTsViewModel.NFTSortType(rawValue: savedSort ?? "") ?? .name
    }
}
