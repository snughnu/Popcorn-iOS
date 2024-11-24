//
//  LoginTextField.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/19/24.
//

import UIKit

// MARK: - UIFont를 반환하는 메서드 추가
extension UILabel {
    static func popcornMediumFont(size: CGFloat) -> UIFont {
        return UIFont(name: RobotoFontName.robotoMedium, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

final class LoginTextField: UITextField {
    private let insets: UIEdgeInsets = .init(top: 17, left: 20, bottom: 15, right: 20)

    init(placeholder: String, keyboardType: UIKeyboardType, isSecureTextEntry: Bool = false) {
        super.init(frame: .zero)
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor(resource: .popcornDarkBlueGray),
                .font: UILabel.popcornMediumFont(size: 15)
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
        font = UILabel.popcornMediumFont(size: 15)
        textAlignment = .left
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.borderColor = UIColor(resource: .popcornGray2).cgColor
        layer.borderWidth = 1
    }
}
