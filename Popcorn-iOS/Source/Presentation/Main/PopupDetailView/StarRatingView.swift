//
//  StarRatingView.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 12/31/24.
//

import UIKit

final class StarRatingView: UIView {
    private var currentRating: Float = 0 {
        didSet {
            updateStarImages()
        }
    }
    weak var delegate: StarRatingViewDelegate?

    private let fullStarImage = UIImage(resource: .star)
    private let halfStarImage = UIImage(resource: .halfStar)
    private let emptyStarImage = UIImage(resource: .emptyStar)
    private let smallFullStarImage = UIImage(resource: .smallStar)
    private let smallHalfStarImage = UIImage(resource: .smallHalfStar)
    private let smallEmptyStarImage = UIImage(resource: .smallEmptyStar)
    private var starSpacing: CGFloat = 10

    private lazy var starStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = starSpacing
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()

    init(starSpacing: CGFloat, isUserInteractionEnabled: Bool = false) {
        super.init(frame: .zero)
        self.isUserInteractionEnabled = isUserInteractionEnabled

        configureUI(starSpacing: starSpacing)
        configureSubviews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Interface
extension StarRatingView {
    func configureRating(at point: Float) {
        currentRating = point
    }
}

// MARK: - Configure Gesture
extension StarRatingView {
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self).x
        let newRating = convertToStarRating(from: location)

        if newRating != currentRating {
            currentRating = newRating
            updateStarImages()
            delegate?.didChangeRating(to: Float(newRating))
        }
    }

    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self).x
        let newRating = convertToStarRating(from: location)

        if newRating != currentRating {
            currentRating = Float(newRating)
            updateStarImages()
            delegate?.didChangeRating(to: Float(newRating))
        }
    }

    private func convertToStarRating(from location: CGFloat) -> Float {
        let starWidth = bounds.width / 5    // 각 별의 왼쪽 끝의 x 좌표는 starWidth 단위로 나눠짐.
        let rawRating = location / starWidth
        let flooredRating = floor(rawRating)
        let remaining = rawRating - flooredRating

        var rating: Float
        if remaining < 0.25 {
            rating =  Float(flooredRating)
        } else if remaining < 0.75 {
            rating =  Float(flooredRating) + 0.5
        } else {
            rating =  Float(flooredRating) + 1.0
        }

        return max(rating, 0.5)
    }

    private func updateStarImages() {
        for (index, imageView) in starStackView.arrangedSubviews.enumerated() {
            guard let starImageView = imageView as? UIImageView else { continue }

            if Float(index + 1) <= currentRating {
                starImageView.image = isUserInteractionEnabled ? fullStarImage : smallFullStarImage
            } else if Float(index) < currentRating && Float(index + 1) > currentRating {
                starImageView.image = isUserInteractionEnabled ? halfStarImage : smallHalfStarImage
            } else {
                starImageView.image = isUserInteractionEnabled ? emptyStarImage : smallEmptyStarImage
            }
        }
    }
}

// MARK: - Configure UI
extension StarRatingView {
    private func configureUI(starSpacing: CGFloat) {
        self.starSpacing = starSpacing
        starStackView.spacing = self.starSpacing

        for idx in 1...5 {
            let starImageView: UIImageView = {
                let imageView = UIImageView()
                imageView.image = isUserInteractionEnabled ? fullStarImage : smallFullStarImage
                imageView.contentMode = .scaleAspectFit
                imageView.setContentHuggingPriority(.required, for: .horizontal)
                return imageView
            }()

            if idx == Int(currentRating) && currentRating.truncatingRemainder(dividingBy: Float(idx)) >= 0.5 {
                starImageView.image = isUserInteractionEnabled ? halfStarImage : smallHalfStarImage
            } else if idx > Int(currentRating) {
                starImageView.image = isUserInteractionEnabled ? emptyStarImage : smallEmptyStarImage
            }

            starStackView.addArrangedSubview(starImageView)
        }
    }

    private func configureSubviews() {
        [starStackView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            starStackView.topAnchor.constraint(equalTo: topAnchor),
            starStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            starStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            starStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
