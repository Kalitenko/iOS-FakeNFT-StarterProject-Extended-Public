//
//  ProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei Boyarko on 15/02/2026.
//

import SwiftUI

struct ProfileView: View {

    private let avatarURL: URL? = nil
    private let displayName = "Joaquin Phoenix"
    private let aboutText = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
    private let websiteText = "JoaquinPhoenix.com"

    private let myNFTCount = 112
    private let favoriteNFTCount = 11

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    header
                        .padding(.bottom, 40)

                    navigationRows

                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
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
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 20) {

            HStack(spacing: 12) {
                avatar

                Text(displayName)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(Color(uiColor: .appTextPrimary))

                Spacer()
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(aboutText)
                    .font(.system(size: 13, weight: .regular))
                    .lineSpacing(5)
                    .foregroundStyle(Color(uiColor: .appTextPrimary))
                    .fixedSize(horizontal: false, vertical: true)

                Button(action: {}) {
                    Text(websiteText)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(Color("AppBlue"))
                }
                .buttonStyle(.plain)
                .padding(.top, 8)
                .accessibilityIdentifier("profile.websiteButton")
            }
        }
    }

    private var avatar: some View {
        ZStack {
            placeholderAvatar

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
        .frame(width: 70, height: 70)
        .clipShape(Circle())
        .accessibilityIdentifier("profile.avatar")
    }

    private var placeholderAvatar: some View {
        Circle()
            .fill(Color(.systemGray5))
            .overlay {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundStyle(.secondary)
            }
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

#Preview {
    ProfileView()
}
