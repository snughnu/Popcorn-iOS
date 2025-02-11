//
//  ProfileImageCellCollectionViewCell.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/7/25.
//

import UIKit

class ProfileImageCell: UICollectionViewCell {
    private let cellBackgroundView = UIView()
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

    func configureContents(image: UIImage, color: UIColor, isSelected: Bool) {
        imageView.image = image
        cellBackgroundView.backgroundColor = color
        cellBackgroundView.layer.borderWidth = isSelected ? 3 : 0
        cellBackgroundView.layer.borderColor = isSelected ? UIColor(resource: .popcornOrange).cgColor : nil
    }
}

// MARK: - Configure UI
extension ProfileImageCell {
    private func configureSubviews() {
        cellBackgroundView.layer.cornerRadius = cellSize / 2
        cellBackgroundView.clipsToBounds = true

        imageView.layer.cornerRadius = cellSize / 2
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        contentView.addSubview(cellBackgroundView)
        contentView.addSubview(imageView)
    }

    private func configureLayout() {
        cellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cellBackgroundView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cellBackgroundView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellBackgroundView.widthAnchor.constraint(equalToConstant: cellSize),
            cellBackgroundView.heightAnchor.constraint(equalToConstant: cellSize),

            imageView.centerXAnchor.constraint(equalTo: cellBackgroundView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: cellBackgroundView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: cellSize),
            imageView.heightAnchor.constraint(equalToConstant: cellSize)
        ])
    }
}
