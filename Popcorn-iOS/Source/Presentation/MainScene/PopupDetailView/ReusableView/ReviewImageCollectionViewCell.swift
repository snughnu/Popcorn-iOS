//
//  ReviewImageCollectionViewCell.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 1/5/25.
//

import UIKit

final class ReviewImageCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .popupPreviewPlaceHolder)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.cornerRadius(radius: 5)
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Interface
extension ReviewImageCollectionViewCell {
    func configureContents(image: UIImage) {
        imageView.image = image
    }
}

// MARK: - Configure UI
extension ReviewImageCollectionViewCell {
    private func configureSubviews() {
        [imageView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
