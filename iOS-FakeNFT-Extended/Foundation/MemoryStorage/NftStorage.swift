import Foundation

protocol NftStorage: AnyObject {
    func saveNft(_ nft: NftDTO) async
    func getNft(with id: String) async -> NftDTO?
}

// Пример простого актора, который сохраняет данные из сети
actor NftStorageImpl: NftStorage {
    private var storage: [String: NftDTO] = [:]

    func saveNft(_ nft: NftDTO) async {
        storage[nft.id] = nft
    }

    func getNft(with id: String) async -> NftDTO? {
        storage[id]
    }
}
