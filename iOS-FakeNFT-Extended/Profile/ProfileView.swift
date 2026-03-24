//
//  ProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei Boyarko on 15/02/2026.
//

import SwiftUI
import SafariServices

struct ProfileView: View {
    
    @Environment(ServicesAssembly.self) private var services
    
    @State private var isWebViewPresented = false
    
    @State private var profile = UserProfile(
        name: "Joaquin Phoenix",
        about: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
        website: "JoaquinPhoenix.com",
        photoURL: nil,
        isPhotoRemoved: false
    )
    
    @State private var currentLikes: [String] = []
    
    @State private var errorMessage: String?
        
    @State private var myNFTCount = 0
    @State private var favoriteNFTCount = 0
    
    private enum Layout {
        static let screenPadding: CGFloat = 16
        
        static let avatarSize: CGFloat = 70
        
        static let nameFontSize: CGFloat = 22
        static let nameLineHeight: CGFloat = 28
        static let nameTracking: CGFloat = 0.35
        
        static let headerSpacing: CGFloat = 20
        static let headerBottomPadding: CGFloat = 40
        static let headerRowSpacing: CGFloat = 12
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
    
    private var websiteURL: URL? {
        Self.makeWebURL(from: profile.website)
    }
    
    private var avatarURL: URL? {
        guard !profile.isPhotoRemoved else { return nil }
        guard let raw = profile.photoURL else { return nil }
        return Self.makeWebURL(from: raw)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    header
                        .padding(.bottom, Layout.headerBottomPadding)
                    
                    navigationRows
                    
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, Layout.screenPadding)
                .padding(.top, Layout.screenPadding)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        ProfileEditView(profile: $profile) { editedProfile in
                            Task {
                                let currentProfile = try await services.commonProfileService.fetchProfile()
                                
                                let dto = UpdateProfileDTO(
                                    name: editedProfile.name,
                                    avatar: editedProfile.photoURL ?? "",
                                    description: editedProfile.about,
                                    website: editedProfile.website,
                                    likes: currentProfile.likes
                                )
                                
                                print("🚀 SENDING UPDATE PROFILE DTO:", dto)

                                do {
                                    let updated = try await services.commonProfileService.updateProfile(profile: dto)
                                    currentLikes = updated.likes
                                    favoriteNFTCount = updated.likes.count
                                               print("✅ UPDATE SUCCESS, likes:", updated.likes)
                                } catch {
                                    errorMessage = profileErrorMessage(from: error)
                                }
                            }
                        }
                    } label: {
                        Image("edit")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 26, height: 26)
                            .foregroundStyle(.appTextPrimary)
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.plain)
                    .contentShape(Rectangle())
                    .accessibilityIdentifier("profile.editButton")
                }
            }
            .sheet(isPresented: $isWebViewPresented) {
                if let url = websiteURL {
                    SafariView(url: url).ignoresSafeArea()
                } else {
                    Text("Некорректная ссылка")
                        .font(.system(size: 17, weight: .regular))
                        .padding()
                } 
            }
            .task {
                do {
                    let profileDTO = try await services.commonProfileService.fetchProfile()
                    currentLikes = profileDTO.likes
                    favoriteNFTCount = profileDTO.likes.count
                    myNFTCount = profileDTO.nfts.count
                } catch {
                    errorMessage = profileErrorMessage(from: error)
                }
            }
            .alert(
                L10n.Alerts.somethingWentWrong,
                isPresented: Binding(
                    get: { errorMessage != nil },
                    set: { if !$0 { errorMessage = nil } }
                )
            ) {
                Button(L10n.Alerts.okay, role: .cancel) {
                    errorMessage = nil
                }
            } message: {
                Text(errorMessage ?? "")
            }
        
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: Layout.headerSpacing) {
            
            HStack(spacing: Layout.headerRowSpacing) {
                RemoteAvatarView(
                    url: avatarURL,
                    isRemoved: profile.isPhotoRemoved,
                    size: Layout.avatarSize,
                    placeholderAssetName: "joaquinPhoenixFoto"
                )
                .accessibilityIdentifier("profile.avatar")
                
                Text(profile.name)
                    .font(.system(size: Layout.nameFontSize, weight: .bold))
                    .tracking(Layout.nameTracking)
                    .frame(height: Layout.nameLineHeight, alignment: .leading)
                    .foregroundStyle(Color(uiColor: .appTextPrimary))
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(profile.about)
                    .font(.system(size: 13, weight: .regular))
                    .lineSpacing(5)
                    .foregroundStyle(Color(uiColor: .appTextPrimary))
                    .fixedSize(horizontal: false, vertical: true)
                
                if let url = websiteURL {
                    NavigationLink {
                        WebViewScreen(url: url)
                    } label: {
                        Text(profile.website)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(.appBlue)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 8)
                    .accessibilityIdentifier("profile.websiteButton")
                } else {
                    Text(profile.website)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(.appBlue)
                        .opacity(0.5)
                        .padding(.top, 8)
                        .accessibilityIdentifier("profile.websiteButton")
                }
            }
        }
    }
    
    private var navigationRows: some View {
        VStack(spacing: 8) {
            NavigationLink {
                //                MyNFTsView(nfts: []) проверить пустой экран My NFT
                MyNFTsView()
            } label: {
                row(title: L10n.Profile.myNFT, value: myNFTCount)
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("profile.myNFTRow")
            
            NavigationLink {
                FavoritesNFTView()
                    .toolbar(.hidden, for: .tabBar)
            } label: {
                row(title: L10n.Profile.favoriteNFT, value: favoriteNFTCount)
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("profile.favoriteNFTRow")
        }
    }
    
    private func row(title: String, value: Int) -> some View {
        HStack(spacing: 4) {
            Text(title)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color(uiColor: .appTextPrimary))
            
            Text("(\(value))")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color(uiColor: .appTextPrimary))
            
            Spacer()
            
            Image("chevron")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 8, height: 14)
                .foregroundStyle(Color(uiColor: .appTextPrimary))
        }
        .padding(.vertical, 14)
        .contentShape(Rectangle())
    }
    
    // MARK: - URL helper
    
    private static func makeWebURL(from rawString: String) -> URL? {
        let trimmed = rawString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        
        let candidate: String
        if trimmed.lowercased().hasPrefix("http://") || trimmed.lowercased().hasPrefix("https://") {
            candidate = trimmed
        } else {
            candidate = "https://\(trimmed)"
        }
        
        guard let url = URL(string: candidate),
              let scheme = url.scheme, (scheme == "http" || scheme == "https"),
              url.host != nil
        else { return nil }
        
        return url
    }
}

// MARK: - Avatar (clean + stable)

private struct RemoteAvatarView: View {
    let url: URL?
    let isRemoved: Bool
    let size: CGFloat
    let placeholderAssetName: String
    
    @StateObject private var loader = AvatarLoader()
    
    var body: some View {
        Group {
            if isRemoved {
                removedPlaceholder
            } else if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else if loader.isLoading {
                ProgressView()
            } else {
                Image(placeholderAssetName)
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .task(id: identityKey) {
            await loader.load(url: url, isRemoved: isRemoved)
        }
    }
    
    private var identityKey: String {
        if isRemoved { return "removed" }
        return url?.absoluteString ?? "default"
    }
    
    private var removedPlaceholder: some View {
        ZStack {
            Circle().fill(Color(UIColor.systemGray5))
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: size * 0.4, height: size * 0.4)
                .foregroundStyle(.secondary)
        }
    }
}

@MainActor
private final class AvatarLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    
    private static let cache = NSCache<NSString, UIImage>()
    
    func load(url: URL?, isRemoved: Bool) async {
        // removed -> always clear
        guard !isRemoved else {
            image = nil
            isLoading = false
            return
        }
        
        guard let url else {
            image = nil
            isLoading = false
            return
        }
        
        let key = url.absoluteString as NSString
        
        if let cached = Self.cache.object(forKey: key) {
            image = cached
            isLoading = false
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                image = nil
                return
            }
            
            guard let uiImage = UIImage(data: data) else {
                image = nil
                return
            }
            
            Self.cache.setObject(uiImage, forKey: key)
            image = uiImage
        } catch {
            image = nil
        }
    }
}

// MARK: - Safari wrapper

private struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

#Preview {
    ProfileView()
}
