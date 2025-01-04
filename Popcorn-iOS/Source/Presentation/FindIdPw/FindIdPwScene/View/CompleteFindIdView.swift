//
//  FindIdView.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 12/30/24.
//

import UIKit

class CompleteFindIdView: UIView {
    let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .checkButtonSelected)
        return imageView
    }()

    private let checkMyIdLabel: UILabel = {
        let label = UILabel()
        label.text = "팝팝팝님의 아이디는\nqwer1234입니다."
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 21/852
        label.font = UIFont(name: RobotoFontName.robotoMedium, size: size)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    let completeButton: UIButton = {
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
                .foregroundColor: UIColor.white
            ])
        )
        button.configuration = config
        return button
    }()

    // MARK: - StackView
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            checkImageView,
            checkMyIdLabel
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
extension CompleteFindIdView {
    private func configureInitialSetting() {
        backgroundColor = .white
    }
}

// MARK: - Configure Layout
extension CompleteFindIdView {
    private func configureSubviews() {
        [
            mainStackView,
            completeButton
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 195),

            completeButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
            completeButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -32),
            completeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -84),
            completeButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 56/759)
        ])
    }
}
