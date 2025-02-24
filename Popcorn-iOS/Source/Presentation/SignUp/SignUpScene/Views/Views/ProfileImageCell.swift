//
//  ProfileImageCellCollectionViewCell.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/7/25.
//

import UIKit

class ProfileImageCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let cellSize = (UIScreen.main.bounds.width - (29 * 2 + 18 * 2)) / 3

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public interface
extension ProfileImageCell {
    func configureContents(image: UIImage) {
        imageView.image = image
    }
}

// MARK: - Configure UI
extension ProfileImageCell {
    private func configureSubviews() {
        imageView.layer.cornerRadius = cellSize / 2
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
    }

    private func configureLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: cellSize),
            imageView.heightAnchor.constraint(equalToConstant: cellSize)
        ])
    }
}
