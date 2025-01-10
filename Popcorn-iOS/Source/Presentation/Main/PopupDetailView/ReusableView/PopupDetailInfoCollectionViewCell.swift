//
//  PopupDetailInfoCollectionViewCell.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 12/29/24.
//

import UIKit

final class PopupDetailInfoCollectionViewCell: UICollectionViewCell {
    private let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .location)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.popcornMedium(text: "주소", size: 15)
        label.numberOfLines = 0
        return label
    }()

    private let officialLinkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .link)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let officialLinkLabel: UILabel = {
        let label = UILabel()
        label.popcornMedium(text: "공식 사이트 주소", size: 15)
        label.numberOfLines = 0
        return label
    }()

    private let businessHourTitleLabel: UILabel = {
        let label = UILabel()
        label.popcornSemiBold(text: "운영시간", size: 15)
        return label
    }()

    private let businessHourInfoLabel: UILabel = {
        let label = UILabel()
        label.popcornMedium(text: "O요일~O요일 : OO:OO - OO:OO", size: 15)
        return label
    }()

    private let popupIntroduceTitleLabel: UILabel = {
        let label = UILabel()
        label.popcornSemiBold(text: "팝업 스토어 소개", size: 15)
        return label
    }()

    private let popupIntroduceLabel: UILabel = {
        let label = UILabel()
        label.popcornMedium(text: "팝콘 팝업스토어입니다.", size: 15)
        label.numberOfLines = 0
        return label
    }()

    private let reservationButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(resource: .popcornOrange)
        config.background.cornerRadius = 10
        config.attributedTitle = AttributedString(
            "예약하기",
            attributes: AttributeContainer([
                .font: UIFont(name: RobotoFontName.robotoSemiBold, size: 15)!,
                .foregroundColor: UIColor(.white)
            ])
        )
        button.configuration = config
        return button
    }()

    private let startChatButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(resource: .popcornOrange)
        config.background.cornerRadius = 10
        config.attributedTitle = AttributedString(
            "채팅하기",
            attributes: AttributeContainer([
                .font: UIFont(name: RobotoFontName.robotoSemiBold, size: 15)!,
                .foregroundColor: UIColor(.white)
            ])
        )
        button.configuration = config
        return button
    }()

    // MARK: - StackView
    private lazy var locationInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [locationImageView, locationLabel])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var officialLinkInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [officialLinkImageView, officialLinkLabel])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var locationOfficialLinkInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [locationInfoStackView, officialLinkInfoStackView])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var businessHourInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [businessHourTitleLabel, businessHourInfoLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private lazy var popupIntroduceInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [popupIntroduceTitleLabel, popupIntroduceLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private lazy var popupInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            locationOfficialLinkInfoStackView,
            businessHourInfoStackView,
            popupIntroduceInfoStackView
        ])

        stackView.axis = .vertical
        stackView.spacing = 25
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var reservationStartChatButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [reservationButton, startChatButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
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
extension PopupDetailInfoCollectionViewCell {
    func configureContents(address: String, officialLink: String, businessHourInfo: String, popupIntroduce: String) {
        locationLabel.text = address
        officialLinkLabel.text = officialLink
        businessHourInfoLabel.text = businessHourInfo
        popupIntroduceLabel.text = popupIntroduce
    }
}

// MARK: - Configure UI
extension PopupDetailInfoCollectionViewCell {
    private func configureSubviews() {
        [locationImageView, officialLinkImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [popupInfoStackView, reservationStartChatButtonStackView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            locationImageView.widthAnchor.constraint(equalToConstant: 14),
            locationImageView.heightAnchor.constraint(equalTo: locationImageView.widthAnchor),

            officialLinkImageView.widthAnchor.constraint(equalToConstant: 14),
            officialLinkImageView.heightAnchor.constraint(equalTo: officialLinkImageView.widthAnchor),

            locationLabel.trailingAnchor.constraint(equalTo: popupInfoStackView.trailingAnchor),
            officialLinkLabel.trailingAnchor.constraint(equalTo: popupInfoStackView.trailingAnchor),
            businessHourInfoLabel.trailingAnchor.constraint(equalTo: popupInfoStackView.trailingAnchor),
            popupIntroduceLabel.trailingAnchor.constraint(equalTo: popupInfoStackView.trailingAnchor),

            popupInfoStackView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            popupInfoStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26),
            popupInfoStackView.centerXAnchor.constraint(equalTo: centerXAnchor),

            reservationStartChatButtonStackView.topAnchor.constraint(
                equalTo: popupInfoStackView.bottomAnchor,
                constant: 30
            ),
            reservationStartChatButtonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23),
            reservationStartChatButtonStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            reservationStartChatButtonStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            reservationStartChatButtonStackView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 55/393)
        ])
    }
}
