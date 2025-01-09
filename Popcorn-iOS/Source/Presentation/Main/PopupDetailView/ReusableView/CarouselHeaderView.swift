//
//  CarouselCollectionReusableView.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 12/30/24.
//

import UIKit

final class CarouselHeaderView: UICollectionReusableView {
    private let detailCarouselView = MainCarouselView(viewModel: nil)

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
extension CarouselHeaderView {
    func configureContents(viewModel: PopupDetailViewModel) {
        detailCarouselView.updateViewModel(viewModel: viewModel)
    }
}

// MARK: - Configure UI
extension CarouselHeaderView {
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
