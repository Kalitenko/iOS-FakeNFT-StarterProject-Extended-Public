import Foundation

protocol NftStorage: AnyObject {
    func saveNft(_ nft: NftDTOCart) async
    func getNft(with id: String) async -> NftDTOCart?
}

// Пример простого актора, который сохраняет данные из сети
actor NftStorageImpl: NftStorage {
    private var storage: [String: NftDTOCart] = [:]

    func saveNft(_ nft: NftDTOCart) async {
        storage[nft.id] = nft
    }

    func getNft(with id: String) async -> NftDTOCart? {
        storage[id]
    }
}
