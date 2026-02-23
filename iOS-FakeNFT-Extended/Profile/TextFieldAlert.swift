//
//  TextFieldAlert.swift
//  iOS-FakeNFT-Extended
//
//  Created by Andrei  Boyarko on 16/02/2026.
//

import SwiftUI
import UIKit

struct TextFieldAlert {
    let title: String
    var message: String? = nil
    var placeholder: String = ""
    var text: String = ""
    var keyboardType: UIKeyboardType = .URL
    var onCancel: (() -> Void)? = nil
    var onSave: ((String) -> Void)? = nil
}

private struct TextFieldAlertPresenter: UIViewControllerRepresentable {

    @Binding var alert: TextFieldAlert?

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        guard let model = alert else { return }
        guard uiViewController.presentedViewController == nil else { return }
        guard context.coordinator.isPresenting == false else { return }

        context.coordinator.isPresenting = true

        let ac = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)

        ac.addTextField { tf in
            tf.placeholder = model.placeholder
            tf.text = model.text
            tf.keyboardType = model.keyboardType
            tf.autocapitalizationType = .none
            tf.autocorrectionType = .no
            tf.clearButtonMode = .whileEditing
        }

        let cancel = UIAlertAction(title: "Отмена", style: .cancel) { _ in
            model.onCancel?()
            self.alert = nil
            context.coordinator.isPresenting = false
        }

        let save = UIAlertAction(title: "Сохранить", style: .default) { _ in
            let value = (ac.textFields?.first?.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            model.onSave?(value)
            self.alert = nil
            context.coordinator.isPresenting = false
        }

        ac.addAction(cancel)
        ac.addAction(save)

        uiViewController.present(ac, animated: true)
    }

    final class Coordinator {
        var isPresenting: Bool = false
    }
}

extension View {
    func textFieldAlert(_ alert: Binding<TextFieldAlert?>) -> some View {
        background(TextFieldAlertPresenter(alert: alert))
    }
}
