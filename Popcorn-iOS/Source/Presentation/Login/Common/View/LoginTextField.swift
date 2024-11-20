//
//  LoginTextField.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/19/24.
//

import UIKit

final class LoginTextField: UITextField {
    private let insets: UIEdgeInsets = .init(top: 17, left: 20, bottom: 15, right: 20)
    
    init(placeholder: String, keyboardType: UIKeyboardType, isSecureTextEntry: Bool = false) {
        super.init(frame: .zero)
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)]
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

// MARK: - configure TextField
extension LoginTextField {
    private func configureTextField() {
        backgroundColor = #colorLiteral(red: 0.969, green: 0.973, blue: 0.976, alpha: 1)
        textColor = #colorLiteral(red: 0.514, green: 0.568, blue: 0.631, alpha: 1)
        autocapitalizationType = .none
        autocorrectionType = .no
        spellCheckingType = .no
        clearsOnBeginEditing = false
        font = UIFont.systemFont(ofSize: 14)
        textAlignment = .left
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.borderColor = #colorLiteral(red: 0.855, green: 0.855, blue: 0.855, alpha: 1)
        layer.borderWidth = 1
    }
}
