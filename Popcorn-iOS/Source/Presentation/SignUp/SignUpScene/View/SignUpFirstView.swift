//
//  SignUpFirstView.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/24/24.
//

import UIKit

class SignUpFirstView: UIView {
    let nameField = SignUpFieldStackView(
        labelText: "*이름을 입력해주세요.",
        placeholder: "이름",
        keyboardType: .default
    )

    let idField = SignUpFieldStackView(
        labelText: "*아이디를 입력해주세요.",
        placeholder: "아이디"
    )

    let duplicateCheckButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(resource: .popcornOrange)
        config.background.cornerRadius = 10
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 13/852
        config.attributedTitle = AttributedString(
            "중복확인",
            attributes: AttributeContainer([
                .font: UIFont(name: RobotoFontName.robotoSemiBold, size: size)!,
                .foregroundColor: UIColor.white
            ])
        )
        button.configuration = config
        return button
    }()

    let passwordField = SignUpFieldStackView(
        labelText: "*비밀번호를 입력해주세요.",
        placeholder: "비밀번호"
    )

    let confirmPasswordField = SignUpFieldStackView(
        labelText: "*비밀번호 확인란을 입력해주세요.",
        placeholder: "비밀번호 확인"
    )

    let emailField = SignUpFieldStackView(
        labelText: "*이메일을 입력해주세요.",
        placeholder: "이메일"
    )

    let requestAuthButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(resource: .popcornOrange)
        config.background.cornerRadius = 10
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 13/852
        config.attributedTitle = AttributedString(
            "인증",
            attributes: AttributeContainer([
                .font: UIFont(name: RobotoFontName.robotoSemiBold, size: size)!,
                .foregroundColor: UIColor.white
            ])
        )
        button.configuration = config
        return button
    }()

    let authNumberTextField = SignUpTextField(
        keyboardType: .numberPad,
        placeholder: "인증번호를 입력하세요"
    )

    let nextButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(resource: .popcornOrange)
        config.background.cornerRadius = 10
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 15/852
        config.attributedTitle = AttributedString(
            "다음",
            attributes: AttributeContainer([
                .font: UIFont(name: RobotoFontName.robotoSemiBold, size: size)!,
                .foregroundColor: UIColor.white
            ])
        )
        button.configuration = config
        return button
    }()

    // MARK: - StackView
    private lazy var idStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            idField,
            duplicateCheckButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .top
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var emailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            emailField,
            requestAuthButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .top
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private lazy var fieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nameField,
            idStackView,
            passwordField,
            confirmPasswordField,
            emailStackView,
            authNumberTextField
        ])
        stackView.axis = .vertical
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 13/852
        stackView.spacing = size
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var entireStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            fieldStackView,
            nextButton
        ])
        stackView.axis = .vertical
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 65/852
        stackView.spacing = size
        stackView.distribution = .fill
        return stackView
    }()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureInitialSetting()
        configureSubviews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure InitialSetting
extension SignUpFirstView {
    private func configureInitialSetting() {
        backgroundColor = .white
    }
}

// MARK: - Configure Layout
extension SignUpFirstView {
    private func configureSubviews() {
        [
            entireStackView
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            entireStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
            entireStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -32),
            entireStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -84),

            duplicateCheckButton.centerYAnchor.constraint(equalTo: idField.textFieldReference.centerYAnchor),
            duplicateCheckButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 90/393),
            duplicateCheckButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 50/759),

            requestAuthButton.centerYAnchor.constraint(equalTo: emailField.textFieldReference.centerYAnchor),
            requestAuthButton.centerXAnchor.constraint(equalTo: duplicateCheckButton.centerXAnchor),
            requestAuthButton.heightAnchor.constraint(equalTo: emailField.textFieldReference.heightAnchor),
            requestAuthButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 90/393),

            nameField.textFieldReference.heightAnchor.constraint(equalTo: duplicateCheckButton.heightAnchor),
            idField.textFieldReference.heightAnchor.constraint(equalTo: duplicateCheckButton.heightAnchor),
            passwordField.textFieldReference.heightAnchor.constraint(equalTo: duplicateCheckButton.heightAnchor),
            confirmPasswordField.textFieldReference.heightAnchor.constraint(equalTo: duplicateCheckButton.heightAnchor),
            emailField.textFieldReference.heightAnchor.constraint(equalTo: duplicateCheckButton.heightAnchor),
            authNumberTextField.heightAnchor.constraint(equalTo: duplicateCheckButton.heightAnchor),

            nextButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 56/759)
        ])
    }
}
