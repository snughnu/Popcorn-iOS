//
//  ResetPwView.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 12/30/24.
//

import UIKit

class ResetPwView: UIView {
    let pwTextField = FindIdPwTextField(
        keyboardType: .emailAddress,
        placeholder: "비밀번호 입력"
    )

    let checkPwTextField = FindIdPwTextField(
        keyboardType: .emailAddress,
        placeholder: "비밀번호 확인"
    )

    let pwEyeButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(resource: .loginPasswordEyeButton)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button.configuration = config
        return button
    }()

    let checkPwEyeButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(resource: .loginPasswordEyeButton)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button.configuration = config
        return button
    }()

    var completeButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(resource: .popcornOrange)
        config.background.cornerRadius = 10
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 15/852
        config.attributedTitle = AttributedString(
            "완료",
            attributes: AttributeContainer([
                .font: UIFont(name: RobotoFontName.robotoSemiBold, size: size)!,
                .foregroundColor: UIColor(.white)
            ])
        )
        button.configuration = config
        return button
    }()

    // MARK: - StackView
    private lazy var pwStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            pwTextField,
            checkPwTextField
        ])
        stackView.axis = .vertical
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 38/852
        stackView.spacing = size
        stackView.alignment = .fill
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
extension ResetPwView {
    private func configureInitialSetting() {
        backgroundColor = .white
    }
}

// MARK: - Configure Layout
extension ResetPwView {
    private func configureSubviews() {
        [
            pwStackView,
            pwEyeButton,
            checkPwEyeButton,
            completeButton
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            pwStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
            pwStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -32),
            pwStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 146),

            pwTextField.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 50/759),

            pwEyeButton.centerYAnchor.constraint(equalTo: pwTextField.centerYAnchor),
            pwEyeButton.trailingAnchor.constraint(equalTo: pwTextField.trailingAnchor, constant: -20),

            checkPwEyeButton.centerYAnchor.constraint(equalTo: checkPwTextField.centerYAnchor),
            checkPwEyeButton.trailingAnchor.constraint(equalTo: checkPwTextField.trailingAnchor, constant: -20),

            completeButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
            completeButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -32),
            completeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -84),
            completeButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 56/759)
        ])
    }
}

// MARK: - 관심사 버튼들 설정
extension ResetPwView {
    private func createLineStackView(with titles: [String]) -> UIStackView {
        let buttons = titles.map { SignUpInterestButton(title: $0) }
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = 13
        stackView.distribution = .fillProportionally
        return stackView
    }
}
