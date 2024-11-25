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
            attributes: [
                .foregroundColor: UIColor(resource: .popcornDarkBlueGray),
                .font: UIFont(name: RobotoFontName.robotoMedium, size: 15) as Any
            ]
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
        backgroundColor = UIColor(resource: .popcornGray4)
        textColor = UIColor(resource: .popcornDarkBlueGray)
        autocapitalizationType = .none
        autocorrectionType = .no
        spellCheckingType = .no
        clearsOnBeginEditing = false
        font = UIFont(name: RobotoFontName.robotoMedium, size: 15)
        textAlignment = .left
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.borderColor = UIColor(resource: .popcornGray2).cgColor
        layer.borderWidth = 1
    }
}
