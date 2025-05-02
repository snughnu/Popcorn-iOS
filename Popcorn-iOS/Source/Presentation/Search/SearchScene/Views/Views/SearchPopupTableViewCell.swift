//
//  SearchPopupTableViewCell.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 4/24/25.
//

import UIKit

class SearchPopupTableViewCell: UITableViewCell {
    private let popupImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let popupNameLabel: UILabel = {
        let label = UILabel()
        guard let baseFont = UIFont(name: RobotoFontName.robotoSemiBold, size: 21) else { return label }
        let scaleFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: baseFont)
        let fontSize = scaleFont.pointSize
        label.font = scaleFont
        label.textColor = UIColor(.black)
        return label
    }()

    private let distanceLabel: UILabel = {
        let label = UILabel()
        guard let baseFont = UIFont(name: RobotoFontName.robotoMedium, size: 15) else { return label }
        let scaleFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: baseFont)
        let fontSize = scaleFont.pointSize
        label.font = scaleFont
        label.textColor = UIColor(.red)
        return label
    }()

    private let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .popcornGray1)
        return view
    }()

    private let openPeriodLabel: UILabel = {
        let label = UILabel()
        guard let baseFont = UIFont(name: RobotoFontName.robotoMedium, size: 15) else { return label }
        let scaleFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: baseFont)
        let fontSize = scaleFont.pointSize
        label.font = scaleFont
        label.textColor = UIColor(.black)
        return label
    }()

    private let arrowButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(.clear)
        config.image = UIImage(resource: .arrow)
        button.configuration = config
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure Subviews
extension SearchPopupTableViewCell {
    private func configureSubviews() {
        [popupImageView,
         popupNameLabel,
         distanceLabel,
         separateView,
         openPeriodLabel,
         arrowButton
        ].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

// MARK: - Configure Layout
extension SearchPopupTableViewCell {
    private func configureLayout() {
        NSLayoutConstraint.activate([
            popupImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 27),
            popupImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -27),
            popupImageView.topAnchor.constraint(equalTo: contentView.topAnchor),

            popupNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            popupNameLabel.topAnchor.constraint(equalTo: popupImageView.bottomAnchor, constant: 25),

            distanceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            distanceLabel.topAnchor.constraint(equalTo: popupNameLabel.bottomAnchor, constant: 9),
            distanceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -42),

            separateView.leadingAnchor.constraint(equalTo: distanceLabel.trailingAnchor, constant: 10),
            separateView.centerYAnchor.constraint(equalTo: distanceLabel.centerYAnchor),
            separateView.widthAnchor.constraint(equalToConstant: 1),
            separateView.heightAnchor.constraint(equalToConstant: 11),

            openPeriodLabel.leadingAnchor.constraint(equalTo: separateView.trailingAnchor, constant: 10),
            openPeriodLabel.centerYAnchor.constraint(equalTo: distanceLabel.centerYAnchor),

            arrowButton.centerYAnchor.constraint(equalTo: popupNameLabel.centerYAnchor),
            arrowButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25)
        ])
    }
}

// MARK: - Public method: 셀 구성 (이미지, 제목, 거리, 기간)
extension SearchPopupTableViewCell {
    func configurePopupData(image: UIImage, title: String, distance: String, period: String) {
        popupImageView.image = image
        popupNameLabel.text = title
        distanceLabel.text = distance
        openPeriodLabel.text = period
    }
}
