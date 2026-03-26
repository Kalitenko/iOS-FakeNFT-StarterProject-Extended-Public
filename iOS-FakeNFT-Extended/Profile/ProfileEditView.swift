//
//  ProfileEditView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei Boyarko on 16/02/2026.
//

import SwiftUI
import UIKit

struct ProfileEditView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Binding var profile: UserProfile
    
    let onSave: (UserProfile) -> Void
    
    // MARK: - Initial values (to detect changes)
    private let initialName: String
    private let initialAbout: String
    private let initialWebsite: String
    private let initialPhotoURL: String?
    private let initialIsPhotoRemoved: Bool
    
    // MARK: - State (editable)
    @State private var name: String
    @State private var about: String
    @State private var website: String
    
    // Photo (mock)
    @State private var isPhotoMenuPresented = false
    @State private var photoURLText: String
    @State private var photoURLAlert: TextFieldAlert?
    @State private var isPhotoRemoved: Bool
    
    // Keyboard / Focus
    private enum Field: Hashable {
        case name
        case about
        case website
    }
    @FocusState private var focusedField: Field?
    @State private var isKeyboardVisible = false
    
    // Website validation UX
    @State private var showWebsiteError: Bool = false
    @State private var websiteShake: CGFloat = 0
    
    // Exit without saving alert
    @State private var isExitAlertPresented: Bool = false
    
    // Loader
    @State private var isSaving: Bool = false
    
    // MARK: - Layout constants (from Figma)
    private enum Layout {
        static let screenPadding: CGFloat = 16
        
        // Avatar
        static let avatarSize: CGFloat = 70
        static let avatarTopOffsetFromScreen: CGFloat = 80
        static let avatarBottomSpacing: CGFloat = 24
        
        // Camera badge
        static let cameraBadgeSize: CGFloat = 22.57
        static let cameraIconWidth: CGFloat = 11.73
        static let cameraIconHeight: CGFloat = 10.26
        
        // Sections
        static let sectionSpacing: CGFloat = 8
        static let sectionTopSpacing: CGFloat = 24
        
        // Fields
        static let singleLineFieldHeight: CGFloat = 44
        static let aboutFieldHeight: CGFloat = 132
        static let aboutMaxCharacters: Int = 300
        static let websiteMaxLength: Int = 255
        
        // Insets
        static let defaultFieldInsets = EdgeInsets(top: 11, leading: 16, bottom: 11, trailing: 16)
        
        // Extra space for counter inside about field
        static let aboutCounterReservedBottom: CGFloat = 18
        
        // Save button
        static let saveButtonHeight: CGFloat = 60
        static let saveButtonBottomPadding: CGFloat = 50
        
        static var contentBottomPaddingWithButton: CGFloat {
            saveButtonBottomPadding + saveButtonHeight + 16
        }
        static let contentBottomPaddingNoButton: CGFloat = 24
        
        // Loader
        static let loaderSize: CGFloat = 82
        static let loaderCornerRadius: CGFloat = 8
        
        // Nav bar button tweak (чуть ближе к краю)
        static let navBarLeadingAdjustment: CGFloat = -8
    }
    
    // MARK: - Init
    init(
        profile: Binding<UserProfile>,
        onSave: @escaping (UserProfile) -> Void
    ) {
        self._profile = profile
        self.onSave = onSave
        
        let profileValue = profile.wrappedValue
        self.initialName = profileValue.name
        self.initialAbout = profileValue.about
        self.initialWebsite = profileValue.website
        
        self.initialPhotoURL = profileValue.photoURL
        self.initialIsPhotoRemoved = profileValue.isPhotoRemoved
        
        _name = State(initialValue: profileValue.name)
        _about = State(initialValue: profileValue.about)
        _website = State(initialValue: profileValue.website)
        
        _photoURLText = State(initialValue: profileValue.photoURL ?? "")
        _isPhotoRemoved = State(initialValue: profileValue.isPhotoRemoved)
    }
    
    // MARK: - Derived
    private var hasChanges: Bool {
        name != initialName
        || about != initialAbout
        || website != initialWebsite
        || photoURLText != (initialPhotoURL ?? "")
        || isPhotoRemoved != initialIsPhotoRemoved
    }
    
    private var photoURL: URL? {
        guard !isPhotoRemoved else { return nil }
        
        let raw = photoURLText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !raw.isEmpty else { return nil }
        
        let candidate =
        raw.lowercased().hasPrefix("http://") || raw.lowercased().hasPrefix("https://")
        ? raw
        : "https://\(raw)"
        
        guard let components = URLComponents(string: candidate) else { return nil }
        
        guard
            let scheme = components.scheme?.lowercased(),
            (scheme == "http" || scheme == "https"),
            let host = components.host, !host.isEmpty
        else { return nil }
        
        return components.url
    }
    
    private var showAboutCounter: Bool {
        isKeyboardVisible && focusedField == .about
    }
    
    private enum WebsiteState: Equatable {
        case valid
        case invalid(String)
    }
    
    private var normalizedWebsiteForValidation: String {
        website.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private var websiteState: WebsiteState {
        let raw = normalizedWebsiteForValidation
        guard !raw.isEmpty else { return .valid }
        
        if raw.contains(" ") { return .invalid(L10n.Profile.invalidWebsite) }
        
        let candidate: String
        if raw.lowercased().hasPrefix("http://") || raw.lowercased().hasPrefix("https://") {
            candidate = raw
        } else {
            candidate = "https://\(raw)"
        }
        
        guard
            let components = URLComponents(string: candidate),
            let host = components.host,
            host.contains("."),
            host.first != ".",
            host.last != "."
        else {
            return .invalid(L10n.Profile.invalidWebsite)
        }
        
        return .valid
    }
    
    private var canSave: Bool {
        if case .invalid = websiteState { return false }
        return true
    }
    
    private var websiteErrorText: String? {
        guard showWebsiteError else { return nil }
        switch websiteState {
        case .invalid(let message): return message
        default: return nil
        }
    }
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    avatarBlock
                        .padding(.top, Layout.avatarTopOffsetFromScreen)
                        .padding(.bottom, Layout.avatarBottomSpacing)
                    
                    form
                }
                .padding(.horizontal, Layout.screenPadding)
                .padding(
                    .bottom,
                    (hasChanges && !isKeyboardVisible)
                    ? Layout.contentBottomPaddingWithButton
                    : Layout.contentBottomPaddingNoButton
                )
            }
            .disabled(isSaving)
            .ignoresSafeArea(.container, edges: .top)
            .toolbarBackground(.hidden, for: .navigationBar)
            
            // Save button
            if hasChanges && !isKeyboardVisible {
                GeometryReader { proxy in
                    let bottomInset = proxy.safeAreaInsets.bottom
                    
                    Button {
                        showWebsiteError = true
                        
                        guard canSave else {
                            UINotificationFeedbackGenerator().notificationOccurred(.error)
                            focusedField = .website
                            withAnimation(.default) { websiteShake += 1 }
                            return
                        }
                        
                        focusedField = nil
                        showWebsiteError = false
                        saveMock()
                    } label: {
                        Text(L10n.Profile.save)
                            .font(.system(size: 17, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .frame(height: Layout.saveButtonHeight)
                            .foregroundStyle(Color(uiColor: .systemBackground))
                            .background(Color(uiColor: .appTextPrimary))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 16)
                    .padding(.bottom, max(Layout.saveButtonBottomPadding - bottomInset, 0))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                }
                .ignoresSafeArea(edges: .bottom)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .overlay {
            if isSaving {
                LoaderTileView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .transition(.opacity)
                    .zIndex(1000)
            }
        }
        
        .overlay {
            if isPhotoMenuPresented {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: hasChanges)
        .animation(.easeInOut(duration: 0.2), value: isKeyboardVisible)
        .toolbar(.hidden, for: .tabBar)
        .customNavigationBar(
            title: nil,
            hidesBackground: true,
            leadingAction: { onBackTap() }
        )
        .overlay {
            if isExitAlertPresented {
                ExitConfirmOverlay(
                    onStay: { isExitAlertPresented = false },
                    onExit: {
                        isExitAlertPresented = false
                        dismiss()
                    }
                )
                .transition(.opacity)
                .zIndex(999)
            }
        }
        
        .confirmationDialog(
            L10n.Profile.profilePhoto,
            isPresented: $isPhotoMenuPresented,
            titleVisibility: .visible
        ) {
            Button(L10n.Profile.changePhoto) {
                photoURLAlert = TextFieldAlert(
                    title: L10n.Profile.photoLink,
                    placeholder: "http://www.example.com",
                    text: photoURLText,
                    keyboardType: .URL,
                    onCancel: { },
                    onSave: { newValue in
                        photoURLText = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                        isPhotoRemoved = false
                    }
                )
            }
            Button(L10n.Profile.deletePhoto, role: .destructive) {
                photoURLText = ""
                isPhotoRemoved = true
            }
            Button(L10n.Common.cancel, role: .cancel) {}
        }
        
        .onTapGesture {
            focusedField = nil
        }
        .photoURLAlert($photoURLAlert)
        
        .onReceive(
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
        ) { _ in
            isKeyboardVisible = true
        }
        .onReceive(
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
        ) { _ in
            isKeyboardVisible = false
        }
    }
    
    // MARK: - Actions
    
    private func onBackTap() {
        guard !isSaving else {
            return
        }
        focusedField = nil
        
        if hasChanges {
            isExitAlertPresented = true
        } else {
            dismiss()
        }
    }
    
    private func saveMock() {
        isSaving = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            profile.name = name
            profile.about = about
            profile.website = website.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let trimmedPhoto = photoURLText.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if isPhotoRemoved {
                profile.photoURL = nil
                profile.isPhotoRemoved = true
            } else if !trimmedPhoto.isEmpty {
                profile.photoURL = trimmedPhoto
                profile.isPhotoRemoved = false
            }
            
            onSave(profile)
            
            isSaving = false
            print("SAVED photoURL:", profile.photoURL ?? "nil", "removed:", profile.isPhotoRemoved)
            dismiss()
        }
    }
    
    // MARK: - Subviews
    
    private var avatarBlock: some View {
        HStack {
            Spacer()
            
            ZStack(alignment: .bottomTrailing) {
                
                Group {
                    if isPhotoRemoved {
                        Circle()
                            .fill(Color(.systemGray5))
                            .overlay {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                                    .foregroundStyle(.secondary)
                            }
                    } else if let url = photoURL {
                        
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                
                            case .failure:
                                Image("joaquinPhoenixFoto")
                                    .resizable()
                                    .scaledToFill()
                                
                            @unknown default:
                                Image("joaquinPhoenixFoto")
                                    .resizable()
                                    .scaledToFill()
                            }
                        }
                        .id(url.absoluteString)
                    } else {
                        Image("joaquinPhoenixFoto")
                            .resizable()
                            .scaledToFill()
                    }
                }
                .frame(width: Layout.avatarSize, height: Layout.avatarSize)
                .clipShape(Circle())
                
                Button {
                    isPhotoMenuPresented = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color(.appSurfaceBackground))
                            .frame(width: Layout.cameraBadgeSize, height: Layout.cameraBadgeSize)
                        
                        Image("profile.camera")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: Layout.cameraIconWidth, height: Layout.cameraIconHeight)
                            .foregroundStyle(Color.primary)
                    }
                }
                .buttonStyle(.plain)
                .offset(x: 2, y: 2)
                .accessibilityIdentifier("editProfile.changePhotoButton")
                .disabled(isSaving)
            }
            
            Spacer()
        }
    }
    
    private var form: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            sectionTitle(L10n.Profile.name)
            RoundedField(
                fieldHeight: Layout.singleLineFieldHeight,
                contentInsets: Layout.defaultFieldInsets
            ) {
                TextField("", text: $name)
                    .editFieldTextStyle()
                    .focused($focusedField, equals: .name)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .about }
                    .accessibilityIdentifier("editProfile.nameField")
            }
            
            Spacer().frame(height: Layout.sectionTopSpacing)
            
            sectionTitle(L10n.Profile.description)
            
            let aboutInsets = EdgeInsets(
                top: Layout.defaultFieldInsets.top,
                leading: Layout.defaultFieldInsets.leading,
                bottom: Layout.defaultFieldInsets.bottom + (showAboutCounter ? Layout.aboutCounterReservedBottom : 0),
                trailing: Layout.defaultFieldInsets.trailing
            )
            
            RoundedField(
                fieldHeight: Layout.aboutFieldHeight,
                contentInsets: aboutInsets
            ) {
                ZStack(alignment: .bottomTrailing) {
                    TextEditor(text: $about)
                        .editFieldTextStyle()
                        .scrollContentBackground(.hidden)
                        .focused($focusedField, equals: .about)
                        .accessibilityIdentifier("editProfile.aboutField")
                        .onChange(of: about) {
                            if about.count > Layout.aboutMaxCharacters {
                                about = String(about.prefix(Layout.aboutMaxCharacters))
                            }
                        }
                    
                    if showAboutCounter {
                        Text("\(about.count)/\(Layout.aboutMaxCharacters)")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(about.count >= Layout.aboutMaxCharacters ? .red : .secondary)
                            .padding(.trailing, 4)
                            .padding(.bottom, 2)
                            .accessibilityIdentifier("editProfile.aboutCounter")
                            .transition(.opacity)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            
            Spacer().frame(height: Layout.sectionTopSpacing)
            
            sectionTitle(L10n.Profile.website)
            RoundedField(
                isError: websiteErrorText != nil,
                helperText: websiteErrorText,
                shake: websiteShake,
                fieldHeight: Layout.singleLineFieldHeight,
                contentInsets: Layout.defaultFieldInsets
            ) {
                TextField("", text: $website)
                    .editFieldTextStyle()
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .website)
                    .submitLabel(.done)
                    .onSubmit { focusedField = nil }
                    .accessibilityIdentifier("editProfile.websiteField")
                    .onChange(of: website) {
                        if website.count > Layout.websiteMaxLength {
                            website = String(website.prefix(Layout.websiteMaxLength))
                        }
                    }
            }
        }
    }
    
    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 22, weight: .bold))
            .kerning(0.35)
            .lineSpacing(0)
            .frame(height: 28, alignment: .leading)
            .foregroundStyle(Color(uiColor: .appTextPrimary))
            .padding(.bottom, Layout.sectionSpacing)
    }
}

// MARK: - Text style helper

private extension View {
    func editFieldTextStyle() -> some View {
        self
            .font(.system(size: 17, weight: .regular))
            .kerning(-0.41)
            .foregroundStyle(Color(uiColor: .appTextPrimary))
    }
}

// MARK: - Reusable field container + error + shake

private struct RoundedField<Content: View>: View {
    let isError: Bool
    let helperText: String?
    let shake: CGFloat
    let fieldHeight: CGFloat?
    let contentInsets: EdgeInsets
    let content: Content
    
    init(
        isError: Bool = false,
        helperText: String? = nil,
        shake: CGFloat = 0,
        fieldHeight: CGFloat? = nil,
        contentInsets: EdgeInsets = EdgeInsets(
            top: 11,
            leading: 16,
            bottom: 11,
            trailing: 16
        ),
        @ViewBuilder content: () -> Content
    ) {
        self.isError = isError
        self.helperText = helperText
        self.shake = shake
        self.fieldHeight = fieldHeight
        self.contentInsets = contentInsets
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            content
                .padding(contentInsets)
                .frame(height: fieldHeight, alignment: .topLeading)
                .background(Color(.systemGray6))
                .overlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(isError ? Color.red : Color.clear, lineWidth: 1)
                }
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .modifier(ShakeEffect(animatableData: shake))
            
            Text(helperText ?? " ")
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.red)
                .opacity(helperText == nil ? 0 : 1)
                .accessibilityIdentifier("editProfile.websiteError")
        }
    }
}

private struct ShakeEffect: GeometryEffect {
    var travelDistance: CGFloat = 8
    var shakesPerUnit: CGFloat = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(
                translationX: travelDistance * sin(animatableData * .pi * shakesPerUnit),
                y: 0
            )
        )
    }
}

private struct ExitConfirmOverlay: View {
    let onStay: () -> Void
    let onExit: () -> Void
    
    private enum Layout {
        static let width: CGFloat = 270
        static let height: CGFloat = 119
        static let cornerRadius: CGFloat = 14
        static let dividerHeight: CGFloat = 0.5
        static let buttonHeight: CGFloat = 44
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text(L10n.Alerts.confirmLogout)
                    .font(.system(size: 17, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(uiColor: .appBlack))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 16)
                
                Rectangle()
                    .fill(Color(uiColor: .separator))
                    .frame(height: Layout.dividerHeight)
                
                HStack(spacing: 0) {
                    Button(action: onStay) {
                        Text(L10n.Alerts.stay)
                            .font(.system(size: 17, weight: .regular))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .foregroundStyle(.appBlue)
                    
                    Rectangle()
                        .fill(Color(uiColor: .separator))
                        .frame(width: Layout.dividerHeight)
                    
                    Button(action: onExit) {
                        Text(L10n.Alerts.logout)
                            .font(.system(size: 17, weight: .semibold))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .foregroundStyle(.appBlue)
                }
                .frame(height: Layout.buttonHeight)
            }
            .frame(width: Layout.width, height: Layout.height)
            .background(.appAlertBackground)
            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous))
            .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
        }
        .onTapGesture {
            onStay()
        }
    }
}

struct PlaceholderAvatarView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.25))
            
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.gray.opacity(0.6))
                .frame(width: size * 0.45)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ProfileEditView(
            profile: .constant(
                UserProfile(
                    name: "Joaquin Phoenix",
                    about: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
                    website: "JoaquinPhoenix.com",
                    photoURL: nil,
                    isPhotoRemoved: false
                )
            ),
            onSave: { _ in }
        )
    }
}
