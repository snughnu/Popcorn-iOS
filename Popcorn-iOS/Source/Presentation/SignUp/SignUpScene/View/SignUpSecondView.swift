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
    lazy var firstLineInterestStackView: UIStackView = {
        let interests = ["패션", "뷰티", "음식", "캐릭터"]
        let buttons = interests.map { title in
            SignUpInterestButton(title: title)
        }
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = 13
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    lazy var secondLineInterestStackView: UIStackView = {
        let interests = ["드라마/영화", "라이프 스타일", "예술"]
        let buttons = interests.map { title in
            SignUpInterestButton(title: title)
        }
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = 13
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    lazy var thirdLineInterestStackView: UIStackView = {
        let interests = ["IT", "스포츠", "셀럽", "반려동물"]
        let buttons = interests.map { title in
            SignUpInterestButton(title: title)
        }
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = 13
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    lazy var interestStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            firstLineInterestStackView,
            secondLineInterestStackView,
            thirdLineInterestStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 13
        stackView.distribution = .fillEqually
        return stackView
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
            profileImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 129),
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

            signUpButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
            signUpButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -32),
            signUpButton.heightAnchor.constraint(equalToConstant: 55),
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
