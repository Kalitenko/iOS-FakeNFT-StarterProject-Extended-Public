//
//  LikesStore.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 24/03/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class LikesStore {
    
    var likes: [String] = []
    var errorMessage: String?
    
    private let commonProfileService: CommonProfileServiceProtocol
    
    init(commonProfileService: CommonProfileServiceProtocol) {
        self.commonProfileService = commonProfileService
    }
    
    func loadLikes() async {
        do {
            let profile = try await commonProfileService.fetchProfile()
            likes = profile.likes
            errorMessage = nil
        } catch let error as URLError where error.code == .cancelled {
            return
        } catch {
            errorMessage = L10n.Alerts.dataLoadFailed
        }
    }
    
    func toggleLike(id: String) async {
        let updatedLikes: [String]
        
        if likes.contains(id) {
            updatedLikes = likes.filter { $0 != id }
        } else {
            updatedLikes = likes + [id]
        }
        
        do {
            let updatedProfile = try await commonProfileService.updateLikes(likes: updatedLikes)
            likes = updatedProfile.likes
            errorMessage = nil
        } catch let error as URLError where error.code == .cancelled {
            return
        } catch {
            errorMessage = L10n.Alerts.somethingWentWrong
        }
    }
    
    func contains(_ id: String) -> Bool {
        likes.contains(id)
    }
}
