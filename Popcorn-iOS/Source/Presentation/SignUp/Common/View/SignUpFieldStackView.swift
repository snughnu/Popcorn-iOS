//
//  SignUpFieldStackView.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/24/24.
//

import UIKit

final class SignUpFieldStackView: UIStackView {
    private let textField: SignUpTextField
    private let label: SignUpLabel

    init(
        labelText: String,
        keyboardType: UIKeyboardType = .default,
        isSecureTextEntry: Bool = false
    ) {
        label = SignUpLabel(text: labelText)
        textField = SignUpTextField(keyboardType: keyboardType, isSecureTextEntry: isSecureTextEntry)
        super.init(frame: .zero)
        axis = .vertical
        spacing = 5
        addArrangedSubview(label)
        addArrangedSubview(textField)

        label.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var textFieldReference: SignUpTextField {
        return textField
    }
}
