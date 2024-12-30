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
        placeholder: String,
        keyboardType: UIKeyboardType = .emailAddress,
        isSecureTextEntry: Bool = false
    ) {
        signUpLabel = SignUpLabel(text: labelText)
        signUpTextField = SignUpTextField(
            keyboardType: keyboardType,
            isSecureTextEntry: isSecureTextEntry,
            placeholder: placeholder
        )
        super.init(frame: .zero)
        configureSV()
        configureLayout()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - configure SignUpFieldStackView
extension SignUpFieldStackView {
    private func configureSV() {
        axis = .vertical
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 12/852
        spacing = size
        alignment = .fill
        distribution = .fill
    }
}

// MARK: - configure AutoLayout
extension SignUpFieldStackView {
    private func configureLayout() {
        addArrangedSubview(signUpTextField)
        addArrangedSubview(signUpLabel)

        signUpTextField.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signUpTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor),

            signUpLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        ])
    }
}
