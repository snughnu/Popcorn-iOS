//
//  MainCollectionTitleHeaderView.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 12/28/24.
//

import UIKit

final class MainCollectionTitleHeaderView: UIView {
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.popcornSemiBold(text: "제목", size: 21)
        return label
    }()

    private let showAllButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = UIColor(resource: .popcornGray1)
        config.image = UIImage(resource: .mainRightArrow)
        config.imagePlacement = .trailing
        config.imagePadding = 3
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let button = UIButton(configuration: config)
        button.popcornMedium(text: "전체 보기", size: 15)
        return button
    }()

    private let bottomBorder = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureLayout()
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
}

// MARK: - Public Interface
extension MainCollectionTitleHeaderView {
    func configureContents(headerTitle: String, shouldHiddenShowButton: Bool = false) {
        headerLabel.text = headerTitle
        showAllButton.isHidden = shouldHiddenShowButton
    }
}

// MARK: - Configure UI
extension MainCollectionTitleHeaderView {
    private func configureUI() {
        bottomBorder.backgroundColor = UIColor(resource: .popcornGray2).cgColor
        bottomBorder.frame = CGRect(x: 0, y: bounds.height - 1, width: bounds.width, height: 1)

        layer.addSublayer(bottomBorder)
    }

    private func configureSubviews() {
        [headerLabel, showAllButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        headerLabel.setContentHuggingPriority(.required, for: .vertical)

        NSLayoutConstraint.activate([
            headerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            showAllButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            showAllButton.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor)
        ])
    }
}
