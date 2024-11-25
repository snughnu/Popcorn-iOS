//
//  SignUpFieldStackView.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/24/24.
//

import UIKit

final class SignUpFieldStackView: UIStackView {
    private let signUpTextField: SignUpTextField
    private let signUpLabel: SignUpLabel
    var textFieldReference: SignUpTextField {
        return signUpTextField
    }

    init(
        labelText: String,
        keyboardType: UIKeyboardType = .default,
        isSecureTextEntry: Bool = false
    ) {
        signUpLabel = SignUpLabel(text: labelText)
        signUpTextField = SignUpTextField(keyboardType: keyboardType, isSecureTextEntry: isSecureTextEntry)
        super.init(frame: .zero)
        axis = .vertical
        spacing = 5
        configureLayout()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - stackView 안의 label과 textField 오토레이아웃
extension SignUpFieldStackView {
    private func configureLayout() {
        addArrangedSubview(signUpLabel)
        addArrangedSubview(signUpTextField)

        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        signUpTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signUpLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            signUpTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            signUpTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
