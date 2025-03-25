//
//  PopupOverviewTableViewCell.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 3/16/25.
//

import UIKit

final class PopupOverviewTableViewCell: UITableViewCell {
    private var popupImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .popupPreviewPlaceHolder)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.popcornSemiBold(text: "제목", size: 15)
        label.numberOfLines = 2
        return label
    }()

    private var periodLabel: UILabel = {
        let label = UILabel()
        label.popcornMedium(text: "00.00.00~00.00.00", size: 10)
        return label
    }()

    // 기간 레이블의 왼쪽 3pt 여백을 위해
    private var periodContainerView: UIView = {
        let view = UIView()
        return view
    }()

    private var addressImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .location)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var addressLabel: UILabel = {
        let label = UILabel()
        label.popcornMedium(text: "부산광역시 남구 용소로 00", size: 10)
        label.numberOfLines = 2
        return label
    }()

    private var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .mainRightArrow)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - StackView
    private lazy var titlePeriodStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, periodContainerView])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var addressStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addressImageView, addressLabel])
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var informationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titlePeriodStackView, addressStackView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureSubviews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Interface
extension PopupOverviewTableViewCell {
    func configureContents(_ data: PopupOverviewViewData, image: UIImage) {
        popupImageView.image = image
        titleLabel.text = data.popupTitle
        periodLabel.text = data.popupPeriod
        addressLabel.text = data.popupAddress
    }
}
// MARK: - Configure UI
extension PopupOverviewTableViewCell {
    private func configureSubviews() {
        [popupImageView, informationStackView, arrowImageView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        periodContainerView.addSubview(periodLabel)
        periodLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            popupImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            popupImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            popupImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 100/393),
            popupImageView.heightAnchor.constraint(equalTo: popupImageView.widthAnchor),

            periodLabel.topAnchor.constraint(equalTo: periodContainerView.topAnchor),
            periodLabel.leadingAnchor.constraint(equalTo: periodContainerView.leadingAnchor, constant: 3),

            informationStackView.topAnchor.constraint(equalTo: popupImageView.topAnchor, constant: 23),
            informationStackView.leadingAnchor.constraint(equalTo: popupImageView.trailingAnchor, constant: 30),
            informationStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            informationStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            arrowImageView.topAnchor.constraint(equalTo: popupImageView.topAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
}
