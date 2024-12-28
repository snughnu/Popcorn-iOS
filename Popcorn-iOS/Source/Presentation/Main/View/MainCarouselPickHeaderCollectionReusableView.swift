//
//  CarouselCollectionReusableView.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 12/23/24.
//

import UIKit

final class MainCarouselPickHeaderCollectionReusableView: UICollectionReusableView {
    private let carouselView = MainCarouselView(viewModel: nil)

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
extension MainCarouselPickHeaderCollectionReusableView {
    func configureContents(headerTitle: String, viewModel: MainSceneViewModel) {
        headerLabel.text = headerTitle
        carouselView.updateViewModel(viewModel: viewModel)
        layoutSubviews()
    }
}

// MARK: - Configure UI
extension MainCarouselPickHeaderCollectionReusableView {
    private func configureUI() {
        bottomBorder.backgroundColor = UIColor(resource: .popcornGray2).cgColor
        bottomBorder.frame = CGRect(x: 0, y: bounds.height - 1, width: bounds.width, height: 1)

        layer.addSublayer(bottomBorder)
    }

    private func configureSubviews() {
        [carouselView, headerLabel, showAllButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            carouselView.topAnchor.constraint(equalTo: topAnchor),
            carouselView.leadingAnchor.constraint(equalTo: leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: trailingAnchor),

            headerLabel.topAnchor.constraint(equalTo: carouselView.bottomAnchor, constant: 31),
            headerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            showAllButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            showAllButton.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor)
        ])
    }
}
