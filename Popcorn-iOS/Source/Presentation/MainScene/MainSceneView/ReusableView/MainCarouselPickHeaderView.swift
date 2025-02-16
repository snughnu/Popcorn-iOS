//
//  CarouselCollectionReusableView.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 12/23/24.
//

import UIKit

final class MainCarouselPickHeaderView: UICollectionReusableView {
    private let carouselView = MainCarouselView(viewModel: nil)
    private let titleHeader = MainCollectionTitleHeaderView()

    private let mainTextLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.logoText
        imageView.contentMode = .scaleAspectFit
        return imageView
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
extension MainCarouselPickHeaderView {
    func configureContents(headerTitle: String, viewModel: MainCarouselViewModelProtocol) {
        titleHeader.configureContents(headerTitle: headerTitle)
        carouselView.updateViewModel(viewModel: viewModel)
        layoutSubviews()
    }
}

// MARK: - Configure UI
extension MainCarouselPickHeaderView {
    private func configureSubviews() {
        [mainTextLogoImageView, carouselView, titleHeader].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            mainTextLogoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            mainTextLogoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainTextLogoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainTextLogoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 35/393),

            carouselView.topAnchor.constraint(equalTo: mainTextLogoImageView.bottomAnchor, constant: 17),
            carouselView.leadingAnchor.constraint(equalTo: leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: trailingAnchor),
            carouselView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 317/393),

            titleHeader.topAnchor.constraint(equalTo: carouselView.bottomAnchor, constant: 31),
            titleHeader.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleHeader.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleHeader.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
