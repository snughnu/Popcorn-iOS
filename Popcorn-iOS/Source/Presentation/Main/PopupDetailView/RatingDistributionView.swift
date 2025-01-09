//
//  PopupRatingCountView.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 12/31/24.
//

import UIKit

enum ReviewDistribution: String {
    case verySatisfied = "매우만족"
    case satisfied = "만족"
    case average = "보통"
    case dissatisfied = "별로"
    case veryDissatisfied = "매우별로"
}

final class RatingDistributionView: UIView {
    private let progressViewHeight: CGFloat = 5

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.popcornMedium(text: "평가 등급", size: 11)
        label.textColor = UIColor(resource: .popcornGray1)
        return label
    }()

    private lazy var ratingProgressBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.backgroundColor = UIColor(resource: .popcornGray2)
        progressView.progressTintColor = UIColor(resource: .popcornOrange)
        progressView.cornerRadius(radius: progressViewHeight / CGFloat(2))
        return progressView
    }()

    private let ratingCountLabel: UILabel = {
        let label = UILabel()
        label.popcornMedium(text: "000", size: 11)
        return label
    }()

    init(title: ReviewDistribution) {
        super.init(frame: .zero)
        titleLabel.text = title.rawValue
        configureSubviews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Interface
extension RatingDistributionView {
    func configureContents(ratingCount: Int, totalRatingCount: Int) {
        ratingProgressBar.progress = Float(ratingCount) / Float(totalRatingCount)
        ratingCountLabel.text = String(ratingCount)
    }

    func higlightMaximumDistribution(text: ReviewDistribution) {
        titleLabel.popcornMedium(text: text.rawValue, size: 11)
        titleLabel.textColor = UIColor.black
    }
}

// MARK: - Configure UI
extension RatingDistributionView {
    private func configureSubviews() {
        [titleLabel, ratingProgressBar, ratingCountLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        ratingProgressBar.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            ratingProgressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 49),
            ratingProgressBar.centerYAnchor.constraint(equalTo: centerYAnchor),
            ratingProgressBar.widthAnchor.constraint(equalToConstant: 78),
            ratingProgressBar.heightAnchor.constraint(equalToConstant: progressViewHeight),

            ratingCountLabel.topAnchor.constraint(equalTo: topAnchor),
            ratingCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 135),
            ratingCountLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            ratingCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
