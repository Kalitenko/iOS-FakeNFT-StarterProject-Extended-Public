//
//  ProfileViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 24/03/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class ProfileViewModel {
    
    
    // Временное локальное состояние профиля.
    // Счётчики и likes приходят с сервера, поля профиля будут переведены на серверные данные
    // после расширения модели CommonProfileDTO.
    var profile = UserProfile(
        name: "Joaquin Phoenix",
        about: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
        website: "JoaquinPhoenix.com",
        photoURL: nil,
        isPhotoRemoved: false
    )
    
    var currentLikes: [String] = []
    var myNFTCount = 0
    var favoriteNFTCount = 0
    var errorMessage: String?
    
    private let commonProfileService: CommonProfileServiceProtocol
    
    init(commonProfileService: CommonProfileServiceProtocol) {
        self.commonProfileService = commonProfileService
    }
    
    func loadProfile() async {
        do {
            let profileDTO = try await commonProfileService.fetchProfile()
            currentLikes = profileDTO.likes
            favoriteNFTCount = profileDTO.likes.count
            myNFTCount = profileDTO.nfts.count
            errorMessage = nil
        } catch {
            errorMessage = profileErrorMessage(from: error)
        }
    }
    
    func updateProfile(with editedProfile: UserProfile) async {
        do {
            let currentProfile = try await commonProfileService.fetchProfile()

            let dto = UpdateProfileDTO(
                name: editedProfile.name,
                avatar: editedProfile.photoURL ?? "",
                description: editedProfile.about,
                website: editedProfile.website,
                likes: currentProfile.likes
            )

            let updated = try await commonProfileService.updateProfile(profile: dto)

            profile = editedProfile
            currentLikes = updated.likes
            favoriteNFTCount = updated.likes.count
            errorMessage = nil
        } catch {
            errorMessage = profileErrorMessage(from: error)
        }
    }
    
    private func profileErrorMessage(from error: Error) -> String? {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .cancelled:
                return nil
            case .notConnectedToInternet, .timedOut:
                return L10n.Alerts.dataLoadFailed
            default:
                return L10n.Alerts.somethingWentWrong
            }
        }
        
        if error is DecodingError {
            return L10n.Alerts.dataLoadFailed
        }
        
        return L10n.Alerts.somethingWentWrong
    }
}
