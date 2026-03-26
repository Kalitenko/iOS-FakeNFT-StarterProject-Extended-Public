//
//  TextFieldAlert.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei Boyarko on 16/02/2026.
//

import SwiftUI
import UIKit

// MARK: - Model

struct TextFieldAlert {
    let title: String
    var message: String? = nil
    var placeholder: String = ""
    var text: String = ""
    var keyboardType: UIKeyboardType = .URL
    var onCancel: (() -> Void)? = nil
    var onSave: ((String) -> Void)? = nil
}

// MARK: - ViewModifier

extension View {
    func photoURLAlert(_ alert: Binding<TextFieldAlert?>) -> some View {
        modifier(PhotoURLAlertModifier(alert: alert))
    }
}

private struct PhotoURLAlertModifier: ViewModifier {
    @Binding var alert: TextFieldAlert?

    func body(content: Content) -> some View {
        content
            .overlay {
                if let model = alert {
                    PhotoURLAlertView(
                        model: model,
                        onCancel: {
                            model.onCancel?()
                            alert = nil
                        },
                        onSave: { value in
                            model.onSave?(value)
                            alert = nil
                        }
                    )
                    .transition(.opacity)
                    .zIndex(999)
                }
            }
    }
}

// MARK: - Alert View (SwiftUI, Figma-like)

private struct PhotoURLAlertView: View {
    let model: TextFieldAlert
    let onCancel: () -> Void
    let onSave: (String) -> Void

    @State private var text: String
    @FocusState private var isFocused: Bool

    private enum Layout {
        static let width: CGFloat = 273
        static let height: CGFloat = 151
        static let cornerRadius: CGFloat = 14

        static let titleTop: CGFloat = 12
        static let titleHeight: CGFloat = 22

        static let fieldHeight: CGFloat = 46
        static let fieldHorizontalPadding: CGFloat = 16
        static let fieldInnerHorizontalPadding: CGFloat = 12
        static let fieldTopSpacing: CGFloat = 12
        static let fieldCornerRadius: CGFloat = 10

        static let buttonsHeight: CGFloat = 44
        static let divider: CGFloat = 0.5

        static let dimOpacity: CGFloat = 0.50

        static let cardTintOpacity: CGFloat = 0.75
    }

    init(model: TextFieldAlert, onCancel: @escaping () -> Void, onSave: @escaping (String) -> Void) {
        self.model = model
        self.onCancel = onCancel
        self.onSave = onSave
        _text = State(initialValue: model.text)
    }

    var body: some View {
        ZStack {
            Color.black.opacity(Layout.dimOpacity)
                .ignoresSafeArea()
                .onTapGesture { onCancel() }

            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Text(model.title)
                        .font(.system(size: 17, weight: .semibold))
                        .kerning(-0.41)
                        .frame(height: Layout.titleHeight, alignment: .center)
                        .padding(.top, Layout.titleTop)

                    TextField(model.placeholder, text: $text)
                        .textFieldStyle(.plain)
                        .font(.system(size: 17, weight: .regular))
                        .kerning(-0.41)
                        .foregroundStyle(.appTextPrimary)
                        .tint(Color.appBlue)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(model.keyboardType)
                        .focused($isFocused)
                        .submitLabel(.done)
                        .onSubmit {
                            let value = text.trimmingCharacters(in: .whitespacesAndNewlines)
                            onSave(value)
                        }
                        .padding(.horizontal, Layout.fieldInnerHorizontalPadding)
                        .frame(height: Layout.fieldHeight)
                        .background(Color("AlertTextFieldBackground"))
                        .clipShape(RoundedRectangle(cornerRadius: Layout.fieldCornerRadius, style: .continuous))
                        .padding(.top, Layout.fieldTopSpacing)
                        .padding(.horizontal, Layout.fieldHorizontalPadding)

                    Spacer(minLength: 0)
                }
                .frame(height: Layout.height - Layout.buttonsHeight - Layout.divider)

                Rectangle()
                    .fill(Color(uiColor: .separator))
                    .frame(height: Layout.divider)

                HStack(spacing: 0) {
                    Button(action: onCancel) {
                        Text("Отмена")
                            .font(.system(size: 17, weight: .regular))
                            .kerning(-0.41)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .foregroundStyle(.appBlue)

                    Rectangle()
                        .fill(Color(uiColor: .separator))
                        .frame(width: Layout.divider)

                    Button {
                        let value = text.trimmingCharacters(in: .whitespacesAndNewlines)
                        onSave(value)
                    } label: {
                        Text("Сохранить")
                            .font(.system(size: 17, weight: .semibold))
                            .kerning(-0.41)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .foregroundStyle(.appBlue)
                }
                .frame(height: Layout.buttonsHeight)
            }
            .frame(width: Layout.width, height: Layout.height)
            .background(
                ZStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                    Color("PhotoAlertBackground")
                        .opacity(Layout.cardTintOpacity)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous))
            .shadow(color: .black.opacity(0.18), radius: 20, x: 0, y: 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .ignoresSafeArea(.keyboard)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isFocused = true
            }
        }
    }
}
