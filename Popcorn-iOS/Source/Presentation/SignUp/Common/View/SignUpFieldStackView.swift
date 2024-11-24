//
//  SignUpFieldStackView.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/24/24.
//

import UIKit

final class SignUpFieldStackView: UIStackView {
    private let textField: SignUpTextField

    init(
        labelText: String,
        keyboardType: UIKeyboardType = .default,
        isSecureTextEntry: Bool = false
    ) {
        textField = SignUpTextField(keyboardType: keyboardType, isSecureTextEntry: isSecureTextEntry)
        super.init(frame: .zero)
        axis = .vertical
        spacing = 5
        let label = SignUpLabel(text: labelText)
        addArrangedSubview(label)
        addArrangedSubview(textField)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var textFieldReference: SignUpTextField {
        return textField
    }
}
