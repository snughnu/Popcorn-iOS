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
            selectProfileImageButton
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
            selectProfileImageButton.heightAnchor.constraint(equalTo: selectProfileImageButton.widthAnchor)
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
