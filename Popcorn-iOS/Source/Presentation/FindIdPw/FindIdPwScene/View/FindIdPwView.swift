//
//  FindIdPwView.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 12/30/24.
//

import UIKit

class FindIdPwView: UIView {
    let nameTextField = FindIdPwTextField(
        keyboardType: .default,
        placeholder: "이름"
    )

    let emailTextField = FindIdPwTextField(
        keyboardType: .emailAddress,
        placeholder: "이메일"
    )

    let duplicateCheckButton: UIButton = {
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

    let authNumberTextField = FindIdPwTextField(
        keyboardType: .numberPad,
        placeholder: "인증번호를 입력하세요"
    )

    let idButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(resource: .popcornOrange)
        config.background.cornerRadius = 10
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 15/852
        config.attributedTitle = AttributedString(
            "아이디 찾기",
            attributes: AttributeContainer([
                .font: UIFont(name: RobotoFontName.robotoSemiBold, size: size)!,
                .foregroundColor: UIColor.white
            ])
        )
        button.configuration = config
        return button
    }()

    let pwButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(resource: .popcornOrange)
        config.background.cornerRadius = 10
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 15/852
        config.attributedTitle = AttributedString(
            "비밀번호 재설정",
            attributes: AttributeContainer([
                .font: UIFont(name: RobotoFontName.robotoSemiBold, size: size)!,
                .foregroundColor: UIColor.white
            ])
        )
        button.configuration = config
        return button
    }()

    // MARK: - StackView
    private lazy var emailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            emailTextField,
            duplicateCheckButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var idPwStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            idButton,
            pwButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var entireStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nameTextField,
            emailStackView,
            authNumberTextField
        ])
        stackView.axis = .vertical
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 38/852
        stackView.spacing = size
        stackView.distribution = .fillEqually
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
extension FindIdPwView {
    private func configureInitialSetting() {
        backgroundColor = .white
    }
}

// MARK: - Configure Layout
extension FindIdPwView {
    private func configureSubviews() {
        [
            entireStackView,
            idPwStackView
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            entireStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
            entireStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -32),
            entireStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 146),
            entireStackView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 226/759),

            duplicateCheckButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 90/393),

            idPwStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
            idPwStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -32),
            idPwStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -84),
            idPwStackView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 56/759)
        ])
    }
}
