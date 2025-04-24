//
//  SearchBottomSheetView.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 4/14/25.
//

import UIKit

class SearchBottomSheetView: UIView {
    private lazy var locationButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "내 위치는 여기"
        config.image = UIImage(resource: .location)
        config.baseBackgroundColor = .white
        config.baseForegroundColor = UIColor(.black)
        config.imagePadding = 4
        config.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 14, bottom: 7, trailing: 14)
        config.cornerStyle = .capsule

        let button = UIButton(configuration: config, primaryAction: nil)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(resource: .popcornGray1).cgColor
        button.clipsToBounds = true
        let height = button.intrinsicContentSize.height
        button.layer.cornerRadius = height / 2

        if let baseFont = UIFont(name: RobotoFontName.robotoMedium, size: 15) {
            let scaledFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: baseFont)
            button.titleLabel?.font = scaledFont
            button.titleLabel?.adjustsFontForContentSizeCategory = true
        }
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
            locationButton
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            locationButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            locationButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 43)
        ])
    }
}
