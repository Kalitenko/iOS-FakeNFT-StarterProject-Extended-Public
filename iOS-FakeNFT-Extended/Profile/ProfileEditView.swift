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

    // MARK: - Initial values (to detect changes)
    private let initialName: String
    private let initialAbout: String
    private let initialWebsite: String

    // MARK: - State (editable)
    @State private var name: String
    @State private var about: String
    @State private var website: String

    // Photo (mock)
    @State private var isPhotoMenuPresented = false
    @State private var photoURLText: String = "http://www.example.com"
    @State private var photoURLAlert: TextFieldAlert?

    // Keyboard / Focus
    private enum Field: Hashable { case name, about, website }
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
        static let aboutMaxCharacters: Int = 150
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
    init(profile: Binding<UserProfile>) {
        self._profile = profile

        let profileValue = profile.wrappedValue
        self.initialName = profileValue.name
        self.initialAbout = profileValue.about
        self.initialWebsite = profileValue.website

        _name = State(initialValue: profileValue.name)
        _about = State(initialValue: profileValue.about)
        _website = State(initialValue: profileValue.website)
    }

    // MARK: - Derived
    private var hasChanges: Bool {
        name != initialName || about != initialAbout || website != initialWebsite
    }

    private var showAboutCounter: Bool {
        isKeyboardVisible && focusedField == .about
    }

    private enum WebsiteState: Equatable {
        case ok
        case invalid(String)
    }

    private var normalizedWebsiteForValidation: String {
        website.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var websiteState: WebsiteState {
        let raw = normalizedWebsiteForValidation
        guard !raw.isEmpty else { return .ok }

        if raw.contains(" ") { return .invalid("Введите корректный адрес сайта") }

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
            return .invalid("Введите корректный адрес сайта")
        }

        return .ok
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
                        Text("Сохранить")
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
                Color.black.opacity(0.80)
                    .ignoresSafeArea()

                ZStack {
                    RoundedRectangle(cornerRadius: Layout.loaderCornerRadius, style: .continuous)
                        .fill(Color("AppProgressViewBackground"))
                        .frame(width: Layout.loaderSize, height: Layout.loaderSize)

                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(1.2)
                        .tint(Color.black.opacity(0.75))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: hasChanges)
        .animation(.easeInOut(duration: 0.2), value: isKeyboardVisible)
        .toolbar(.hidden, for: .tabBar)

        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { onBackTap() } label: {
                    Image("back.chevron")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(Color(uiColor: .appTextPrimary))
                        .frame(width: 44, height: 44, alignment: .leading)
                        .contentShape(Rectangle())
                        .padding(.leading, Layout.navBarLeadingAdjustment)
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("editProfile.backButton")
                .disabled(isSaving)
            }
        }

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
            "Фото профиля",
            isPresented: $isPhotoMenuPresented,
            titleVisibility: .visible
        ) {
            Button("Изменить фото") {
                photoURLAlert = TextFieldAlert(
                    title: "Ссылка на фото",
                    placeholder: "http://www.example.com",
                    text: photoURLText,
                    keyboardType: .URL,
                    onCancel: { },
                    onSave: { newValue in
                        photoURLText = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                )
            }
            Button("Удалить фото", role: .destructive) {
                // TODO: remove photo
            }
            Button("Отмена", role: .cancel) {}
        }

        .onTapGesture { focusedField = nil }
        .textFieldAlert($photoURLAlert)

        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            isKeyboardVisible = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            isKeyboardVisible = false
        }
    }

    // MARK: - Actions

    private func onBackTap() {
        guard !isSaving else { return }
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

            isSaving = false
            dismiss()
        }
    }

    // MARK: - Subviews

    private var avatarBlock: some View {
        HStack {
            Spacer()

            ZStack(alignment: .bottomTrailing) {
                Image("joaquinPhoenixFoto")
                    .resizable()
                    .scaledToFill()
                    .frame(width: Layout.avatarSize, height: Layout.avatarSize)
                    .clipShape(Circle())

                Button {
                    isPhotoMenuPresented = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color("AppSurfaceBackground"))
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

            sectionTitle("Имя")
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

            sectionTitle("Описание")

            // динамически резервируем место под счётчик,
            // только когда он реально показан (клавиатура + фокус на about)
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
                        .onChange(of: about) { newValue in
                            if newValue.count > Layout.aboutMaxCharacters {
                                about = String(newValue.prefix(Layout.aboutMaxCharacters))
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

            sectionTitle("Сайт")
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
                    .onChange(of: website) { newValue in
                        if newValue.count > Layout.websiteMaxLength {
                            website = String(newValue.prefix(Layout.websiteMaxLength))
                        }
                        if showWebsiteError {
                            showWebsiteError = true
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
        contentInsets: EdgeInsets = EdgeInsets(top: 11, leading: 16, bottom: 11, trailing: 16),
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
                Text("Уверены,\nчто хотите выйти?")
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
                        Text("Остаться")
                            .font(.system(size: 17, weight: .regular))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .foregroundStyle(Color("AppBlue"))

                    Rectangle()
                        .fill(Color(uiColor: .separator))
                        .frame(width: Layout.dividerHeight)

                    Button(action: onExit) {
                        Text("Выйти")
                            .font(.system(size: 17, weight: .semibold))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .foregroundStyle(Color("AppBlue"))
                }
                .frame(height: Layout.buttonHeight)
            }
            .frame(width: Layout.width, height: Layout.height)
            .background(Color("AppAlertBackground"))
            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous))
            .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
        }
        .onTapGesture { onStay() }
    }
}

#Preview {
    NavigationStack {
        ProfileEditView(profile: .constant(UserProfile(
            name: "Joaquin Phoenix",
            about: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
            website: "JoaquinPhoenix.com"
        )))
    }
}
