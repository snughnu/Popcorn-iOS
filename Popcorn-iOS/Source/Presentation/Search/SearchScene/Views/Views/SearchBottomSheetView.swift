//
//  SearchBottomSheetView.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 4/14/25.
//

import UIKit

class SearchBottomSheetView: UIView {
    private let grabber: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .grabber)
        return imageView
    }()

    private let myLocationButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "내 위치는 여기"
        config.image = UIImage(resource: .location)
        config.baseBackgroundColor = UIColor(.white)
        config.baseForegroundColor = UIColor(.black)
        config.imagePadding = 4
        config.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 14, bottom: 7, trailing: 14)

        if let baseFont = UIFont(name: RobotoFontName.robotoMedium, size: 15) {
            let scaledFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: baseFont)

            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { _ in
                var attr = AttributeContainer()
                attr.font = scaledFont
                return attr
            }
        }

        let button = UIButton(configuration: config)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(resource: .popcornGray1).cgColor
        button.isEnabled = true

        let height = button.intrinsicContentSize.height
        button.cornerRadius(radius: height / 2)

        return button
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 340
        return tableView
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
extension SearchBottomSheetView {
    private func configureInitialSetting() {
        backgroundColor = UIColor(.white)
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
}

// MARK: - Configure AutoLayout
extension SearchBottomSheetView {
    private func configureSubviews() {
        [
            grabber,
            myLocationButton,
            tableView
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            grabber.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            grabber.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 22),

            myLocationButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            myLocationButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 43),

            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: myLocationButton.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
