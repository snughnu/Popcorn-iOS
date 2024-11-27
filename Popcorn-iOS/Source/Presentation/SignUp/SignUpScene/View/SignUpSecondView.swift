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

    // TODO: 열거형사용으로 리팩토링
    private let interestTitles: [[String]] = [
        ["패션", "뷰티", "음식", "캐릭터"],
        ["드라마/영화", "라이프 스타일", "예술"],
        ["IT", "스포츠", "셀럽", "반려동물"]
    ]

    private lazy var interestStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 13
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        interestTitles.forEach { titles in
            let lineStackView = createLineStackView(with: titles)
            stackView.addArrangedSubview(lineStackView)
        }
        return stackView
    }()

    var allAgreeButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(.clear)
        config.image = UIImage(resource: .checkButton)
        config.imagePadding = 10
        config.attributedTitle = AttributedString(
            "전체동의",
            attributes: AttributeContainer([
                .font: UIFont(name: RobotoFontName.robotoSemiBold, size: 18)!,
                .foregroundColor: UIColor(.black),
                .paragraphStyle: {
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineHeightMultiple = 0.95
                    paragraphStyle.alignment = .center
                    return paragraphStyle
                }()
            ])
        )
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button.configuration = config
        return button
    }()

    let firstAgreeButton = SignUpIndividualAgreeButton(
        title: "마케팅 정보 앱 푸시 알림 수신 동의(선택)"
    )

    let secondAgreeButton = SignUpIndividualAgreeButton(
        title: "위치기반 서비스 약관 동의(필수)"
    )

    lazy var individualAgreeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            firstAgreeButton,
            secondAgreeButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        return stackView
    }()

    var firstArrowButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(.clear)
        config.image = UIImage(resource: .signUpRightArrow)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button.configuration = config
        return button
    }()

    var secondArrowButton: UIButton = {
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
        config.baseBackgroundColor = UIColor(resource: .popcornOrange)
        config.background.cornerRadius = 10
        config.attributedTitle = AttributedString(
            "가입하기",
            attributes: AttributeContainer([
                .font: UIFont(name: RobotoFontName.robotoSemiBold, size: 15)!,
                .foregroundColor: UIColor(.white)
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
extension SignUpSecondView {
    func configureInitialSetting() {
        backgroundColor = .white
    }
}

// MARK: - Configure Layout
extension SignUpSecondView {
    private func configureSubviews() {
        [
            profileImageView,
            selectProfileImageButton,
            nickNameTextField,
            interestStackView,
            allAgreeButton,
            individualAgreeStackView,
            firstArrowButton,
            secondArrowButton,
            signUpButton
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 144),
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 106 / 393),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),

            selectProfileImageButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -3),
            selectProfileImageButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 0),
            selectProfileImageButton.widthAnchor.constraint(
                equalTo: profileImageView.widthAnchor,
                multiplier: 24 / 106
            ),
            selectProfileImageButton.heightAnchor.constraint(equalTo: selectProfileImageButton.widthAnchor),

            nickNameTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
            nickNameTextField.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            nickNameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 33),
            nickNameTextField.heightAnchor.constraint(equalToConstant: 50),

            interestStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 26),
            interestStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            interestStackView.topAnchor.constraint(equalTo: nickNameTextField.bottomAnchor, constant: 28),

            allAgreeButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 37),
            allAgreeButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -228),
            allAgreeButton.topAnchor.constraint(equalTo: interestStackView.bottomAnchor, constant: 32),

            individualAgreeStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 37),
            individualAgreeStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            individualAgreeStackView.topAnchor.constraint(equalTo: allAgreeButton.bottomAnchor, constant: 15),

            firstArrowButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -37),
            firstArrowButton.centerYAnchor.constraint(equalTo: firstAgreeButton.centerYAnchor),

            secondArrowButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -37),
            secondArrowButton.centerYAnchor.constraint(equalTo: secondAgreeButton.centerYAnchor),

            signUpButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
            signUpButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -32),
            signUpButton.heightAnchor.constraint(equalToConstant: 55),
            signUpButton.topAnchor.constraint(equalTo: individualAgreeStackView.bottomAnchor, constant: 47),
            signUpButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -84)
        ])
    }
}

// MARK: - Profile Image 원형 설정
extension SignUpSecondView {
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
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
