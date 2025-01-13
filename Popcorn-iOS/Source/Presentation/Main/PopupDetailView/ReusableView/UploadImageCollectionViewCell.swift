//
//  UploadImageCollectionViewCell.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 1/12/25.
//
import UIKit
final class UploadImageCollectionViewCell: UICollectionViewCell {
    private let reviewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .uploadImagePlaceholder)
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
extension UploadImageCollectionViewCell {
    func configureContents(image: UIImage) {
        reviewImageView.image = image
    }
}

// MARK: - Configure UI
extension UploadImageCollectionViewCell {
    private func configureSubviews() {
        [reviewImageView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            reviewImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            reviewImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            reviewImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            reviewImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
