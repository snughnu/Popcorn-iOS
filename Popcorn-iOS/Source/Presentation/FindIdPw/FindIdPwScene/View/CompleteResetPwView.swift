//
//  CompleteResetPwView.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/5/25.
//

import UIKit

class CompleteResetPwView: UIView {
    let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .checkButtonSelected)
        return imageView
    }()

    private let completeLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 변경 완료"
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 21/852
        label.font = UIFont(name: RobotoFontName.robotoMedium, size: size)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let reLoginLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 변경이 완료되었습니다.\n새로운 비밀번호로 로그인해주세요."
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 13/852
        label.font = UIFont(name: RobotoFontName.robotoMedium, size: size)
        label.textColor = UIColor(resource: .popcornDarkBlueGray)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    let goToLoginViewButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(resource: .popcornOrange)
        config.background.cornerRadius = 10
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 15/852
        config.attributedTitle = AttributedString(
            "로그인 화면으로",
            attributes: AttributeContainer([
                .font: UIFont(name: RobotoFontName.robotoSemiBold, size: size)!,
                .foregroundColor: UIColor.white
            ])
        )
        button.configuration = config
        return button
    }()

    // MARK: - StackView
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            completeLabel,
            reLoginLabel
        ])
        stackView.axis = .vertical
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 15/852
        stackView.spacing = size
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var entireStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            checkImageView,
            labelStackView
        ])
        stackView.axis = .vertical
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 23/852
        stackView.spacing = size
        stackView.alignment = .center
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
extension CompleteResetPwView {
    private func configureInitialSetting() {
        backgroundColor = .white
    }
}

// MARK: - Configure Layout
extension CompleteResetPwView {
    private func configureSubviews() {
        [
            entireStackView,
            goToLoginViewButton
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            entireStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            entireStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 195),

            goToLoginViewButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
            goToLoginViewButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -32),
            goToLoginViewButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -84),
            goToLoginViewButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 56/759)
        ])
    }
}
