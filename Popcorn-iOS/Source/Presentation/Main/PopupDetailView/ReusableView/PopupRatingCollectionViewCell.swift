//
//  PopupRatingCollectionViewCell.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 12/31/24.
//

import UIKit

final class PopupRatingCollectionViewCell: UICollectionViewCell {
    private let backgroundGrayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .popcornGray4)
        view.cornerRadius(radius: 15)
        return view
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.popcornSemiBold(text: "5.0", size: 24)
        return label
    }()

    private let starRatingView = StarRatingView(starSpacing: 3.6)

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .popcornGray2)
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()

    private let ratingLevel5View = RatingDistributionView(title: .verySatisfied)
    private let ratingLevel4View = RatingDistributionView(title: .satisfied)
    private let ratingLevel3View = RatingDistributionView(title: .average)
    private let ratingLevel2View = RatingDistributionView(title: .dissatisfied)
    private let ratingLevel1View = RatingDistributionView(title: .veryDissatisfied)

    private let writeReviewButton: UIButton = {
        let button = UIButton(type: .custom)
        button.popcornSemiBold(text: "리뷰 쓰기", size: 15)
        button.setTitleColor(UIColor(resource: .popcornGray1), for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(resource: .popcornGray1).cgColor
        button.layer.cornerRadius = 20
        return button
    }()

    // MARK: - Stack View
    private lazy var starRatingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ratingLabel, starRatingView])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private lazy var ratingDistributionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            ratingLevel5View, ratingLevel4View, ratingLevel3View, ratingLevel2View, ratingLevel1View
        ])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
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
extension PopupRatingCollectionViewCell {
    func configureContents(totalRatingCount: Int, averageRating: Float, ratingDistribution: [Int: Int]) {
        let ratingLevelViews = [
            ratingLevel1View, ratingLevel2View, ratingLevel3View, ratingLevel4View, ratingLevel5View
        ]

        ratingLabel.text = String(averageRating)
        starRatingView.configureRating(at: averageRating)

        (0..<5).forEach { ratingLevelViews[$0].configureContents(
            ratingCount: ratingDistribution[$0, default: 0],
            totalRatingCount: totalRatingCount
        )}
    }
}

// MARK: - Configure UI
extension PopupRatingCollectionViewCell {
    private func configureSubviews() {
        [starRatingStackView, separatorView, ratingDistributionStackView].forEach {
            backgroundGrayView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [backgroundGrayView, writeReviewButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            backgroundGrayView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            backgroundGrayView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26),
            backgroundGrayView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundGrayView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 170/347),

            starRatingStackView.centerYAnchor.constraint(equalTo: backgroundGrayView.centerYAnchor),
            starRatingStackView.leadingAnchor.constraint(equalTo: backgroundGrayView.leadingAnchor, constant: 38),

            starRatingView.heightAnchor.constraint(equalTo: backgroundGrayView.heightAnchor, multiplier: 10/170),
            starRatingView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 68.4/341),

            separatorView.leadingAnchor.constraint(equalTo: starRatingStackView.trailingAnchor, constant: 20),
            separatorView.centerYAnchor.constraint(equalTo: backgroundGrayView.centerYAnchor),
            separatorView.heightAnchor.constraint(equalTo: backgroundGrayView.heightAnchor, multiplier: 94/170),

            ratingDistributionStackView.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 20),
            ratingDistributionStackView.centerYAnchor.constraint(equalTo: backgroundGrayView.centerYAnchor),
            ratingDistributionStackView.heightAnchor.constraint(
                equalTo: backgroundGrayView.heightAnchor,
                multiplier: 95/170
            ),

            writeReviewButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            writeReviewButton.leadingAnchor.constraint(equalTo: backgroundGrayView.leadingAnchor),
            writeReviewButton.trailingAnchor.constraint(equalTo: backgroundGrayView.trailingAnchor),
            writeReviewButton.heightAnchor.constraint(equalToConstant: 57)
        ])
    }
}
