//
//  SignUpSecondView.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/26/24.
//

import UIKit

class SignUpSecondView: UIView {
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(resource: .popcornGray2)
        return imageView
    }()

    let selectProfileImageButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .clear
        config.image = UIImage(resource: .plusCircle)
        button.configuration = config
        return button
    }()

    let nickNameTextField = SignUpTextField(
        keyboardType: .default,
        placeholder: "닉네임",
        textAlignment: .center
    )

    private let interestTitles: [[String]] = [
        ["패션", "뷰티", "음식", "캐릭터"],
        ["드라마/영화", "라이프 스타일", "예술"],
        ["IT", "스포츠", "셀럽", "반려동물"]
    ]

    let allAgreeButton: UIButton = {
        let button = UIButton()
        let screenHeight = UIScreen.main.bounds.height
        let fontSize = screenHeight * 18/852
        var config = UIButton.Configuration.plain()
        config.baseBackgroundColor = .clear
        config.image = UIImage(resource: .checkButton)
        config.imagePlacement = .leading
        config.imagePadding = 10
        config.attributedTitle = AttributedString(
            "전체동의",
            attributes: AttributeContainer([
                .font: UIFont(name: RobotoFontName.robotoSemiBold, size: fontSize)!,
                .foregroundColor: UIColor(.black)
            ])
        )
        config.titleAlignment = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
        button.configuration = config
        return button
    }()

    let firstAgreeButton = SignUpAgreeButton(
        title: "마케팅 정보 앱 푸시 알림 수신 동의(선택)"
    )

    let secondAgreeButton = SignUpAgreeButton(
        title: "위치기반 서비스 약관 동의(필수)"
    )

    private let firstArrowButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(.clear)
        config.image = UIImage(resource: .signUpRightArrow)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button.configuration = config
        return button
    }()

    private let secondArrowButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(.clear)
        config.image = UIImage(resource: .signUpRightArrow)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button.configuration = config
        return button
    }()

    var signUpButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(resource: .popcornGray2)
        config.background.cornerRadius = 10
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 15/852
        config.attributedTitle = AttributedString(
            "가입하기",
            attributes: AttributeContainer([
                .font: UIFont(name: RobotoFontName.robotoSemiBold, size: size)!,
                .foregroundColor: UIColor(.white)
            ])
        )
        button.configuration = config
        return button
    }()

    // MARK: - StackView
    private lazy var interestStackView: UIStackView = {
        let stackView = UIStackView()
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 13/852
        stackView.axis = .vertical
        stackView.spacing = size
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        interestTitles.forEach { titles in
            let lineStackView = createLineStackView(with: titles)
            stackView.addArrangedSubview(lineStackView)
        }
        return stackView
    }()

    private lazy var nickNameInterestStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nickNameTextField,
            interestStackView
        ])
        stackView.axis = .vertical
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 28/852
        stackView.spacing = size
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var individualAgreeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            firstAgreeButton,
            secondAgreeButton
        ])
        stackView.axis = .vertical
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 10/852
        stackView.spacing = size
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var agreeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            allAgreeButton,
            individualAgreeStackView
        ])
        stackView.axis = .vertical
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 15/852
        stackView.spacing = size
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var userChoiceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nickNameInterestStackView,
            agreeStackView
        ])
        stackView.axis = .vertical
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 32/852
        stackView.spacing = size
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private lazy var entireStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            userChoiceStackView,
            signUpButton
        ])
        stackView.axis = .vertical
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 47/852
        stackView.spacing = size
        stackView.alignment = .fill
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

    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
    }
}

// MARK: - Configure InitialSetting
extension SignUpSecondView {
    private func configureInitialSetting() {
        backgroundColor = .white
    }
}

// MARK: - Configure Layout
extension SignUpSecondView {
    private func configureSubviews() {
        [
            entireStackView,
            profileImageView,
            selectProfileImageButton,
            firstArrowButton,
            secondArrowButton
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

            profileImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: nickNameTextField.topAnchor, constant: -33),
            profileImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 106/393),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),

            selectProfileImageButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -3),
            selectProfileImageButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            selectProfileImageButton.widthAnchor.constraint(
                equalTo: profileImageView.widthAnchor,
                multiplier: 24/106
            ),
            selectProfileImageButton.heightAnchor.constraint(equalTo: selectProfileImageButton.widthAnchor),

            nickNameTextField.widthAnchor.constraint(equalTo: entireStackView.widthAnchor),
            nickNameTextField.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 50/759),

            interestStackView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 128/759),
            interestStackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 341/393),

            agreeStackView.widthAnchor.constraint(equalTo: entireStackView.widthAnchor),
            agreeStackView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 104/759),

            firstArrowButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -32),
            firstArrowButton.centerYAnchor.constraint(equalTo: firstAgreeButton.centerYAnchor),

            secondArrowButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -32),
            secondArrowButton.centerYAnchor.constraint(equalTo: secondAgreeButton.centerYAnchor),

            signUpButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 56/759),
            signUpButton.widthAnchor.constraint(equalTo: nickNameTextField.widthAnchor)
        ])
    }
}

// MARK: - 관심사 버튼들 설정
extension SignUpSecondView {
    private func createLineStackView(with titles: [String]) -> UIStackView {
        let buttons = titles.map { SignUpInterestButton(title: $0) }
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = 13
        stackView.distribution = .fillProportionally
        return stackView
    }
}
