//
//  ClosingSoonPopupCell.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/19/24.
//

import UIKit

final class ClosingSoonPopupCell: UICollectionViewCell {
    private let popupImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MainImage")
        imageView.contentMode = .scaleAspectFill
        imageView.cornerRadius(radius: 10)
        return imageView
    }()

    private let popupTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "팝업 스토어 제목"
        label.textColor = .black
        // MARK: - ToDo 폰트 교체
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()

    private let popupPeriodLabel: UILabel = {
        let label = UILabel()
        label.text = "yy.mm.dd~yy.mm.dd"
        label.textColor = .black
        // MARK: - ToDo 폰트 교체
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.numberOfLines = 1
        return label
    }()

    private let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "location")
        return imageView
    }()

    private let popupLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "OO광역시 OO구 OO로OO"
        label.textColor = .black
        // MARK: - ToDo 폰트 교체
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.numberOfLines = 2
        return label
    }()

    private let titlePeriodStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private let locationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    private let popupDescriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading
        stackView.distribution = .fill
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
extension ClosingSoonPopupCell {
    func configureContents(popupImage: UIImage, popupTitle: String, period: String, location: String) {
        popupImageView.image = popupImage
        popupTitleLabel.text = popupTitle
        popupPeriodLabel.text = period
        popupLocationLabel.text = location
    }
}

// MARK: - Configure UI
extension ClosingSoonPopupCell {
    private func configureSubviews() {
        [popupTitleLabel, popupPeriodLabel].forEach {
            titlePeriodStackView.addArrangedSubview($0)
        }

        [locationImageView, popupLocationLabel].forEach {
            locationStackView.addArrangedSubview($0)
        }

        [titlePeriodStackView, locationStackView].forEach {
            popupDescriptionStackView.addArrangedSubview($0)
        }

        [popupImageView, popupDescriptionStackView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            popupImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            popupImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            popupImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            popupImageView.heightAnchor.constraint(equalTo: popupImageView.widthAnchor, multiplier: 1.2),

            popupDescriptionStackView.topAnchor.constraint(equalTo: popupImageView.bottomAnchor, constant: 13),
            popupDescriptionStackView.leadingAnchor.constraint(equalTo: popupImageView.leadingAnchor),
            popupDescriptionStackView.trailingAnchor.constraint(equalTo: popupImageView.trailingAnchor),
            popupDescriptionStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
