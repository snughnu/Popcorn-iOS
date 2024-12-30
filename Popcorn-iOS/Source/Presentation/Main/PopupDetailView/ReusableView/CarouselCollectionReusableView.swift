//
//  CarouselCollectionReusableView.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 12/30/24.
//

import UIKit

final class CarouselCollectionReusableView: UICollectionReusableView {
    private let detailViewModel = MainSceneViewModel()
    private let detailCarouselView: MainCarouselView

    override init(frame: CGRect) {
        detailCarouselView = MainCarouselView(viewModel: detailViewModel)
        super.init(frame: frame)
        configureSubviews()
        configureLayout()
        detailViewModel.fetchPopupImages()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure UI
extension CarouselCollectionReusableView {
    private func configureSubviews() {
        [detailCarouselView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            detailCarouselView.topAnchor.constraint(equalTo: topAnchor),
            detailCarouselView.leadingAnchor.constraint(equalTo: leadingAnchor),
            detailCarouselView.centerXAnchor.constraint(equalTo: centerXAnchor),
            detailCarouselView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
