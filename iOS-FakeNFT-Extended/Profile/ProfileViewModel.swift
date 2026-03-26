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
    
    var profile = UserProfile(
        name: "Joaquin Phoenix",
        about: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
        website: "JoaquinPhoenix.com",
        photoURL: nil,
        isPhotoRemoved: false
    )
    
    var myNFTCount = 0
    var favoriteNFTCount = 0
    var errorMessage: String?
    
    private let commonProfileService: CommonProfileServiceProtocol
    private let likesStore: LikesStore
    
    init(
        commonProfileService: CommonProfileServiceProtocol,
        likesStore: LikesStore
    ) {
        self.commonProfileService = commonProfileService
        self.likesStore = likesStore
    }
    
    func loadProfile() async {
        do {
            let profileDTO = try await commonProfileService.fetchProfile()
            myNFTCount = profileDTO.nfts.count
            
            await likesStore.loadLikes()
            favoriteNFTCount = likesStore.likes.count
            
            errorMessage = likesStore.errorMessage
            if errorMessage == nil {
                errorMessage = nil
            }
        } catch {
            errorMessage = profileErrorMessage(from: error)
        }
    }
    
    func updateProfile(with editedProfile: UserProfile) async {
        do {
            let dto = UpdateProfileDTO(
                name: editedProfile.name,
                avatar: editedProfile.photoURL ?? "",
                description: editedProfile.about,
                website: editedProfile.website,
                likes: likesStore.likes
            )
            
            let updated = try await commonProfileService.updateProfile(profile: dto)
            
            profile = editedProfile
            likesStore.likes = updated.likes
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
