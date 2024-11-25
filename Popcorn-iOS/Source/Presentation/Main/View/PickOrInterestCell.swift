//
//  PickOrInterestCell.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/18/24.
//

import UIKit

final class PickOrInterestCell: UICollectionViewCell {
    private let popupImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .popupPreviewPlaceHolder)
        imageView.contentMode = .scaleAspectFill
        imageView.cornerRadius(radius: 15)
        return imageView
    }()

    private let popupTitleLabel: UILabel = {
        let label = UILabel()
        label.popcornMedium(text: "팝업 스토어 제목", size: 14)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()

    private let dDayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .popcornOrange)
        view.cornerRadius([.bottomRight], radius: 15)
        return view
    }()

    private let dDayLabel: UILabel = {
        let label = UILabel()
        label.popcornSemiBold(text: "D-0", size: 11)
        label.textColor = UIColor.white
        label.numberOfLines = 1
        return label
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
extension PickOrInterestCell {
    func configureContents(popupImage: UIImage, popupTitle: String, dDay: String) {
        popupImageView.image = popupImage
        popupTitleLabel.text = popupTitle
        dDayLabel.text = dDay
    }
}

// MARK: - Configure UI
extension PickOrInterestCell {
    private func configureSubviews() {
        [popupImageView, popupTitleLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [dDayView].forEach {
            popupImageView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [dDayLabel].forEach {
            dDayView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        popupTitleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        NSLayoutConstraint.activate([
            popupImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            popupImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            popupImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            popupImageView.heightAnchor.constraint(equalTo: popupImageView.widthAnchor),

            dDayView.topAnchor.constraint(equalTo: popupImageView.topAnchor),
            dDayView.leadingAnchor.constraint(equalTo: popupImageView.leadingAnchor),
            dDayView.heightAnchor.constraint(equalTo: popupImageView.heightAnchor, multiplier: 0.22),

            dDayLabel.topAnchor.constraint(equalTo: dDayView.topAnchor, constant: 7),
            dDayLabel.leadingAnchor.constraint(equalTo: dDayView.leadingAnchor, constant: 8),
            dDayLabel.trailingAnchor.constraint(equalTo: dDayView.trailingAnchor, constant: -8),
            dDayLabel.centerXAnchor.constraint(equalTo: dDayView.centerXAnchor),
            dDayLabel.centerYAnchor.constraint(equalTo: dDayView.centerYAnchor),

            popupTitleLabel.topAnchor.constraint(equalTo: popupImageView.bottomAnchor, constant: 10),
            popupTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            popupTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            popupTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
