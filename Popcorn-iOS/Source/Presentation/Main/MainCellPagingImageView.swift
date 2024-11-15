//
//  MainCellPagingImageView.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/16/24.
//

import UIKit

final class MainCellPagingImageView: UIView {
    private let pagingImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    init() {
        super.init(frame: .zero)
        configureSubviews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure UI
extension MainCellPagingImageView {
    private func configureSubviews() {
        [pagingImageCollectionView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            pagingImageCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            pagingImageCollectionView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            pagingImageCollectionView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            pagingImageCollectionView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
