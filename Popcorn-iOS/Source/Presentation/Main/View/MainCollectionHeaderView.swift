//
//  MainCollectionHeaderView.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/19/24.
//

import UIKit

class MainCollectionHeaderView: UICollectionReusableView {
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        // MARK: - ToDo 폰트 변경
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()

    private let showAllButton: UIButton = {
        var container = AttributeContainer()
        // MARK: - ToDo 폰트 변경, 이미지 변경
        container.font = .systemFont(ofSize: 16, weight: .semibold)
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("전체 보기", attributes: container)
        config.baseForegroundColor = UIColor(red: 0.514, green: 0.568, blue: 0.631, alpha: 1)
        config.image = UIImage(systemName: "arrowtriangle.right")
        config.imagePlacement = .trailing
        config.imagePadding = 10

        let button = UIButton(configuration: config)
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
extension MainCollectionHeaderView {
    func configureContents(headerTitle: String, shouldHiddenShowButton: Bool = false) {
        headerLabel.text = headerTitle
        showAllButton.isHidden = shouldHiddenShowButton
    }
}

// MARK: - Configure UI
extension MainCollectionHeaderView {
    private func configureUI() {
        layer.borderWidth = 0
        layer.borderColor = nil

        bottomBorder.backgroundColor = UIColor(red: 0.514, green: 0.568, blue: 0.631, alpha: 1).cgColor
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
        headerLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            headerLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            headerLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),

            showAllButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            showAllButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
