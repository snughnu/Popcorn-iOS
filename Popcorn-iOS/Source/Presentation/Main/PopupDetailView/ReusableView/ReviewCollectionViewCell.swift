//
//  ReviewCollectionViewCell.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 1/5/25.
//

import UIKit

final class ReviewCollectionViewCell: UICollectionViewCell {
    private lazy var reviewImages = [UIImage]() {
        didSet {
            reviewImagesHeightConstraint.constant = reviewImages.isEmpty ? 0 : 60

            reviewImagesCollectionView.reloadData()
        }
    }

    private let reviewImagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 6
        layout.itemSize = CGSize(width: 60, height: 60)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false

        return collectionView
    }()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(resource: .grayCircle)
        return imageView
    }()

    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.popcornMedium(text: "작성자 이름", size: 11)
        return label
    }()

    private let starRatingView = StarRatingView(starSpacing: 3.6)

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .popcornGray2)
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()

    private let reviewDateLabel: UILabel = {
        let label = UILabel()
        label.popcornMedium(text: "0000.00.00", size: 11)
        return label
    }()

    private let reviewLabel: UILabel = {
        let label = UILabel()
        label.popcornMedium(text: "...", size: 13)
        label.numberOfLines = 0
        return label
    }()

    // MARK: - StackView
    private lazy var starRatingReviewDateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [starRatingView, separatorView, reviewDateLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var reviewerInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nickNameLabel, starRatingReviewDateStackView])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var reviewHeaderStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImageView, reviewerInfoStackView])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    private var reviewImagesHeightConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureInitialSetting()
        configureSubviews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
}

// MARK: - Initial Setting
extension ReviewCollectionViewCell {
    private func configureInitialSetting() {
        reviewImagesCollectionView.dataSource = self

        reviewImagesCollectionView.register(
            ReviewImageCollectionViewCell.self,
            forCellWithReuseIdentifier: ReviewImageCollectionViewCell.reuseIdentifier
        )
    }
}

// MARK: - Public Interface
extension ReviewCollectionViewCell {
    func configureContents(
        profileImage: UIImage,
        nickName: String,
        starRating: Float,
        reviewDate: String,
        reviewImages: [UIImage],
        reviewText: String
    ) {
        profileImageView.image = profileImage
        nickNameLabel.text = nickName
        starRatingView.configureRating(at: starRating)
        reviewDateLabel.text = reviewDate
        self.reviewImages = reviewImages
        reviewLabel.text = reviewText
    }
}

// MARK: - Implement CollectionView DataSource
extension ReviewCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewImages.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ReviewImageCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? ReviewImageCollectionViewCell else {
            return UICollectionViewCell()
        }

        let reviewImage = reviewImages[indexPath.row]
        cell.configureContents(image: reviewImage)

        return cell
    }
}

// MARK: - Configure UI
extension ReviewCollectionViewCell {
    private func configureSubviews() {
        [reviewHeaderStackView, reviewImagesCollectionView, reviewLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        reviewImagesHeightConstraint = reviewImagesCollectionView.heightAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            reviewHeaderStackView.topAnchor.constraint(equalTo: topAnchor, constant: 31),
            reviewHeaderStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),

            profileImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 32/393),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),

            separatorView.heightAnchor.constraint(equalTo: starRatingReviewDateStackView.heightAnchor, constant: -3),

            reviewImagesCollectionView.topAnchor.constraint(equalTo: reviewHeaderStackView.bottomAnchor, constant: 15),
            reviewImagesCollectionView.leadingAnchor.constraint(equalTo: reviewHeaderStackView.leadingAnchor),
            reviewImagesCollectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            reviewImagesHeightConstraint,

            reviewLabel.topAnchor.constraint(equalTo: reviewImagesCollectionView.bottomAnchor, constant: 12),
            reviewLabel.leadingAnchor.constraint(equalTo: reviewHeaderStackView.leadingAnchor),
            reviewLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
            reviewLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
