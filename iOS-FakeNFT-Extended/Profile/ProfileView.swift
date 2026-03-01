//
//  ProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei Boyarko on 15/02/2026.
//

import SwiftUI
import SafariServices

struct ProfileView: View {
    
    @State private var isWebViewPresented = false
    @State private var profile = UserProfile(
        name: "Joaquin Phoenix",
        about: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
        website: "JoaquinPhoenix.com"
    )
    
    // Пока nil, но оставляем на будущее
    private let avatarURL: URL? = nil
    
    private let myNFTCount = 112
    private let favoriteNFTCount = 11
    
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
    
    private var websiteURL: URL? {
        let trimmed = profile.website.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        
        if trimmed.lowercased().hasPrefix("http://") || trimmed.lowercased().hasPrefix("https://") {
            return URL(string: trimmed)
        } else {
            return URL(string: "https://\(trimmed)")
        }
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
                        ProfileEditView(profile: $profile)
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
                    SafariView(url: url)
                        .ignoresSafeArea()
                } else {
                    Text("Некорректная ссылка")
                        .font(.system(size: 17, weight: .regular))
                        .padding()
                }
            }
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: Layout.headerSpacing) {
            
            HStack(spacing: Layout.headerRowSpacing) {
                avatar
                
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
                
                Button {
                    guard websiteURL != nil else { return }
                    isWebViewPresented = true
                } label: {
                    Text(profile.website)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(Color("AppBlue"))
                }
                .buttonStyle(.plain)
                .padding(.top, 8)
                .accessibilityIdentifier("profile.websiteButton")
                .disabled(websiteURL == nil)
            }
        }
    }
    
    private var avatar: some View {
        ZStack {
            Image("joaquinPhoenixFoto")
                .resizable()
                .scaledToFill()
            
            if let avatarURL {
                AsyncImage(url: avatarURL) { phase in
                    if case .success(let image) = phase {
                        image
                            .resizable()
                            .scaledToFill()
                    }
                }
            }
        }
        .frame(width: Layout.avatarSize, height: Layout.avatarSize)
        .clipShape(Circle())
        .accessibilityIdentifier("profile.avatar")
    }
    
    private var navigationRows: some View {
        VStack(spacing: 8) {
            NavigationLink {
                Text(L10n.Profile.myNFT)
            } label: {
                row(title: L10n.Profile.myNFT, value: myNFTCount)
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("profile.myNFTRow")
            
            NavigationLink {
                Text(L10n.Profile.favoriteNFT)
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
}

// MARK: - Safari WebView wrapper

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
