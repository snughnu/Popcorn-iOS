//
//  SearchView.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 4/14/25.
//

import MapKit
import UIKit

class SearchView: UIView {
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()

    private let searchTextField: UITextField = {
        let textField = UITextField()
        guard let baseFont = UIFont(name: RobotoFontName.robotoMedium, size: 17) else { return textField }
        let scaleFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: baseFont)
        let fontSize = scaleFont.pointSize

        textField.font = scaleFont
        textField.adjustsFontForContentSizeCategory = true
        textField.textColor = UIColor(.black)
        textField.attributedPlaceholder = NSAttributedString(
            string: "팝업스토어 검색",
            attributes: [
                .foregroundColor: UIColor(resource: .popcornDarkGrayOpacity3),
                .font: scaleFont
            ]
        )
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.backgroundColor = UIColor(.white)
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0
        textField.clipsToBounds = true

        let icon = UIImageView(image: UIImage(resource: .searchIcon))
        let iconWidth = fontSize * 19 / 17
        let containerHeight = fontSize * 19 / 17
        let leftPadding: CGFloat = 8
        let rightPadding: CGFloat = 6
        let containerWidth = leftPadding + iconWidth + rightPadding
        let container = UIView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: containerHeight))
        icon.contentMode = .scaleAspectFit
        icon.frame = CGRect(x: leftPadding, y: 0, width: iconWidth, height: containerHeight)
        container.addSubview(icon)

        textField.leftView = container
        textField.leftViewMode = .always

        return textField
    }()

    private let micButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .clear
        config.image = UIImage(resource: .mic)
        button.configuration = config
        return button
    }()

    private let filterButtons: [SearchFilterButton] = [
        SearchFilterButton(title: "거리순", image: UIImage(resource: .bottomArrow)),
        SearchFilterButton(title: "지역"),
        SearchFilterButton(title: "기간"),
        SearchFilterButton(title: "위치"),
        SearchFilterButton(title: "카테고리")
    ]

    private let filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let filterScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        return scrollView
    }()

    private let locationButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .clear
        config.image = UIImage(resource: .myLocation)
        config.contentInsets = .zero
        button.configuration = config
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureInitialSetting()
        configureSubviews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure Initial Setting
extension SearchView {
    private func configureInitialSetting() {
        backgroundColor = .brown
    }
}

// MARK: - Configure AutoLayout
extension SearchView {
    private func configureSubviews() {
        [   mapView,
            searchTextField,
            micButton,
            filterScrollView,
            locationButton
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        filterScrollView.addSubview(filterStackView)
        filterButtons.forEach {
            filterStackView.addArrangedSubview($0)
        }
    }

    private func configureLayout() {
        let searchTextFieldHeight: CGFloat = (searchTextField.font?.pointSize ?? 17) * 50 / 17
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: self.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            searchTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 63),
            searchTextField.heightAnchor.constraint(equalToConstant: searchTextFieldHeight),

            micButton.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: -5),
            micButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),

            filterScrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            filterScrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            filterScrollView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 18),

            filterStackView.leadingAnchor.constraint(equalTo: filterScrollView.leadingAnchor, constant: 23),
            filterStackView.trailingAnchor.constraint(equalTo: filterScrollView.trailingAnchor, constant: -23),
            filterStackView.topAnchor.constraint(equalTo: filterScrollView.topAnchor),
            filterStackView.bottomAnchor.constraint(equalTo: filterScrollView.bottomAnchor),
            filterStackView.heightAnchor.constraint(equalTo: filterScrollView.heightAnchor),

            locationButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -26),
            locationButton.topAnchor.constraint(equalTo: filterScrollView.bottomAnchor, constant: 31)
        ])
    }
}
