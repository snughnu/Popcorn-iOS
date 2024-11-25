//
//  SignUpFirstView.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/24/24.
//

import UIKit

class SignUpFirstView: UIView {
    let nameField = SignUpFieldStackView(
        labelText: "이름"
    )

    let idField = SignUpFieldStackView(
        labelText: "아이디"
    )

    let passwordField = SignUpFieldStackView(
        labelText: "비밀번호",
        isSecureTextEntry: true
    )

    let confirmPasswordField = SignUpFieldStackView(
        labelText: "비밀번호 확인",
        isSecureTextEntry: true
    )

    let emailLabel = SignUpLabel(
        text: "이메일"
    )

    let emailTextField = SignUpTextField(
        keyboardType: .emailAddress
    )

    let requestAuthButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(resource: .popcornOrange)
        config.background.cornerRadius = 10
        config.background.strokeWidth = 1
        config.background.strokeColor = #colorLiteral(red: 0.855, green: 0.855, blue: 0.855, alpha: 1)
        config.attributedTitle = AttributedString(
            "인증요청",
            attributes: AttributeContainer([
                .font: UIFont(name: RobotoFontName.robotoSemiBold, size: 13)!,
                .foregroundColor: UIColor.white,
                .paragraphStyle: {
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineHeightMultiple = 1.04
                    return paragraphStyle
                }()
            ])
        )
        button.configuration = config
        return button
    }()

    lazy var emailTextFieldRequestAuthButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            emailTextField,
            requestAuthButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 9.7
        stackView.distribution = .fill

        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        requestAuthButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailTextField.widthAnchor.constraint(equalTo: requestAuthButton.widthAnchor, multiplier: 230 / 90)
        ])
        return stackView
    }()

    lazy var emailFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            emailLabel,
            emailTextFieldRequestAuthButtonStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fillProportionally

        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextFieldRequestAuthButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),

            emailTextFieldRequestAuthButtonStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            emailTextFieldRequestAuthButtonStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
        return stackView
    }()

    let authNumberTextField = SignUpTextField(
        keyboardType: .numberPad,
        placeholder: "인증번호를 입력하세요"
    )

    lazy var authFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            emailFieldStackView,
            authNumberTextField
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillProportionally
        return stackView
    }()

    lazy var signUpstackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nameField,
            idField,
            passwordField,
            confirmPasswordField,
            authFieldStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        return stackView
    }()

    var nextButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(resource: .popcornOrange)
        config.background.cornerRadius = 10
        config.attributedTitle = AttributedString(
            "다음",
            attributes: AttributeContainer([
                .font: UIFont(name: RobotoFontName.robotoSemiBold, size: 15)!,
                .foregroundColor: UIColor.white
            ])
        )
        button.configuration = config
        return button
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
    func configureInitialSetting() {
        backgroundColor = .white
    }
}

// MARK: - Configure Layout
extension SignUpFirstView {
    private func configureSubviews() {
        [
            signUpstackView,
            nextButton
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            signUpstackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
            signUpstackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -32),
            signUpstackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 103),

            nextButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
            nextButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -32),
            nextButton.topAnchor.constraint(equalTo: signUpstackView.bottomAnchor, constant: 63),
            nextButton.heightAnchor.constraint(equalTo: requestAuthButton.heightAnchor, multiplier: 56 / 50)
        ])
    }
}
