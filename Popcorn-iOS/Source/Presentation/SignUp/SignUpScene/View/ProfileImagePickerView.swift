//
//  ProfileImagePickerView.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/5/25.
//

import UIKit

class ProfileImagePickerView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 선택"
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 18/852
        label.font = UIFont(name: RobotoFontName.robotoSemiBold, size: size)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    let closeButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .clear
        config.image = UIImage(resource: .closeButton)
        button.configuration = config
        return button
    }()

    let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .popcornGray2)
        return view
    }()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProfileImageCell.self, forCellWithReuseIdentifier: ProfileImageCell.reuseIdentifier)
        return collectionView
    }()

    let completeButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(resource: .popcornOrange)
        config.background.cornerRadius = 10
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 15 / 852
        config.attributedTitle = AttributedString(
            "선택 완료",
            attributes: AttributeContainer([
                .font: UIFont(name: RobotoFontName.robotoSemiBold, size: size)!,
                .foregroundColor: UIColor(.white)
            ])
        )
        button.configuration = config
        return button
    }()

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
extension ProfileImagePickerView {
    private func configureInitialSetting() {
        backgroundColor = .white
    }
}

// MARK: - Configure Layout
extension ProfileImagePickerView {
    private func configureSubviews() {
        [
            titleLabel,
            closeButton,
            separatorLine,
            collectionView,
            completeButton
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),

            closeButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -31),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 12/393),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),

            separatorLine.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            separatorLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            separatorLine.heightAnchor.constraint(equalToConstant: 2),

            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 15),
            collectionView.heightAnchor.constraint(equalToConstant: calculateCollectionViewHeight()),

            completeButton.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 32),
            completeButton.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -32),
            completeButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 44),
            completeButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 56/460)
        ])
    }

    private func calculateCollectionViewHeight() -> CGFloat {
        let cellSize = (UIScreen.main.bounds.width - (29 * 2 + 18 * 2)) / 3
        let totalHeight = cellSize * 2 + 18
        return totalHeight
    }
}
