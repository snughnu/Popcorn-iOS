//
//  ReviewSortButtonHeaderView.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 1/5/25.
//

import UIKit

final class ReviewSortButtonHeaderView: UICollectionReusableView {
    private lazy var sortButtons: [UIButton] = [recommendButton, latestButton]

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .popcornGray4)
        view.heightAnchor.constraint(equalToConstant: 9).isActive = true
        return view
    }()

    private let recommendButton: UIButton = {
        var container = AttributeContainer()
        container.font = UIFont(name: RobotoFontName.robotoMedium, size: 11)

        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("추천순", attributes: container)
        config.baseForegroundColor = UIColor.black
        config.baseBackgroundColor = UIColor.clear

        config.image = UIImage(resource: .selectedButton)
        config.imagePlacement = .leading
        config.imagePadding = 6
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let button = UIButton(configuration: config)
        button.isSelected = true
        return button
    }()

    private let latestButton: UIButton = {
        var container = AttributeContainer()
        container.font = UIFont(name: RobotoFontName.robotoMedium, size: 11)

        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("최신순", attributes: container)
        config.baseForegroundColor = UIColor.black
        config.baseBackgroundColor = UIColor.clear

        config.image = UIImage(resource: .deselectedButton)
        config.imagePlacement = .leading
        config.imagePadding = 6
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let button = UIButton(configuration: config)
        button.isSelected = false
        return button
    }()

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [recommendButton, latestButton])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()

    private let bottomBorder = CALayer()

    private let buttonConfigurationHandler: UIButton.ConfigurationUpdateHandler = { button in
        var config = button.configuration
        config?.image = button.isSelected
        ? UIImage(resource: .selectedButton)
        : UIImage(resource: .deselectedButton)
        button.configuration = config
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureLayout()
        configureUI()
        configureButtons()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
}

// MARK: - Configure Buttons
extension ReviewSortButtonHeaderView {
    private func configureButtons() {
        sortButtons.forEach {
            $0.addTarget(self, action: #selector(didTapSortButtons), for: .touchUpInside)
            $0.configurationUpdateHandler = buttonConfigurationHandler
        }
    }

    @objc private func didTapSortButtons(_ sender: UIButton) {
        sortButtons.forEach {
            $0.isSelected = ($0 === sender)
            $0.setNeedsUpdateConfiguration()
        }
    }
}

// MARK: - Configure UI
extension ReviewSortButtonHeaderView {
    private func configureUI() {
        bottomBorder.backgroundColor = UIColor(resource: .popcornGray2).cgColor
        bottomBorder.frame = CGRect(x: 0, y: bounds.height - 1, width: bounds.width, height: 1)

        layer.addSublayer(bottomBorder)
    }

    private func configureSubviews() {
        [separatorView, buttonStackView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),

            buttonStackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 22),
            buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25)
        ])
    }
}
