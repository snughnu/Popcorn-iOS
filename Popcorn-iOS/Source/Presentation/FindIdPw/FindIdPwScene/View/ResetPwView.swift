//
//  ResetPwView.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 12/30/24.
//

import UIKit

class ResetPwView: UIView {
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

    let pwTextField = FindIdPwTextField(
        keyboardType: .emailAddress,
        placeholder: "비밀번호"
    )

    let changePwButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(resource: .popcornOrange)
        config.background.cornerRadius = 10
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 13/852
        config.attributedTitle = AttributedString(
            "변경",
            attributes: AttributeContainer([
                .font: UIFont(name: RobotoFontName.robotoSemiBold, size: size)!,
                .foregroundColor: UIColor.white
            ])
        )
        button.configuration = config
        return button
    }()

    let emailTextField = FindIdPwTextField(
        keyboardType: .emailAddress,
        placeholder: "이메일"
    )
    
    let changeEmailButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(resource: .popcornOrange)
        config.background.cornerRadius = 10
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 13/852
        config.attributedTitle = AttributedString(
            "변경",
            attributes: AttributeContainer([
                .font: UIFont(name: RobotoFontName.robotoSemiBold, size: size)!,
                .foregroundColor: UIColor.white
            ])
        )
        button.configuration = config
        return button
    }()

    private let interestTitles: [[String]] = [
        ["패션", "뷰티", "음식", "캐릭터"],
        ["드라마/영화", "라이프 스타일", "예술"],
        ["IT", "스포츠", "셀럽", "반려동물"]
    ]

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

    private lazy var pwStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            pwTextField,
            changePwButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var emailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            emailTextField,
            changeEmailButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var changeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            pwStackView,
            emailStackView
        ])
        stackView.axis = .vertical
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 20/852
        stackView.spacing = size
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var userChoiceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nickNameInterestStackView,
            changeStackView
        ])
        stackView.axis = .vertical
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 27/852
        stackView.spacing = size
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private lazy var entireStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            userChoiceStackView,
            completeButton
        ])
        stackView.axis = .vertical
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 37/852
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
extension ResetPwView {
    private func configureInitialSetting() {
        backgroundColor = .white
    }
}

// MARK: - Configure Layout
extension ResetPwView {
    private func configureSubviews() {
        [
            entireStackView,
            profileImageView,
            selectProfileImageButton,
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

            changeStackView.widthAnchor.constraint(equalTo: nickNameTextField.widthAnchor),

            changePwButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 90/393),
            changePwButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 50/759),

            changeEmailButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 90/393),

            completeButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 56/759),
            completeButton.widthAnchor.constraint(equalTo: nickNameTextField.widthAnchor)
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
