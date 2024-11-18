//
//  LoginTextField.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/19/24.
//

import UIKit

final class LoginTextField: UITextField {
    private let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 40)
    init(placeholder: String, keyboardType: UIKeyboardType, isSecureTextEntry: Bool = false) {
        super.init(frame: .zero)
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)]
        )
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecureTextEntry
        configureTextField()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
}

extension LoginTextField {
    private func configureTextField() {
        backgroundColor = #colorLiteral(red: 0.9519017339, green: 0.9519017339, blue: 0.9519017339, alpha: 1)
        textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        autocapitalizationType = .none
        autocorrectionType = .no
        spellCheckingType = .no
        clearsOnBeginEditing = false
        font = UIFont.systemFont(ofSize: 14)
        textAlignment = .left
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        layer.borderWidth = 1
    }
}
