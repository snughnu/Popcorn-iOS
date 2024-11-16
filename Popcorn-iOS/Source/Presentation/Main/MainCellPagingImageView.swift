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
        configureInitialSetting()
        configureSubviews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure Initial Setting
extension MainCellPagingImageView {
    private func configureInitialSetting() {
        pagingImageCollectionView.dataSource = self
        pagingImageCollectionView.delegate = self
    }
}

// MARK: - Configure CollectionView DataSource
extension MainCellPagingImageView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 10
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

// MARK: - Configure UICollectionViewDelegateFlowLayout
extension MainCellPagingImageView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width: CGFloat = collectionView.bounds.width
        let height: CGFloat = collectionView.bounds.height

        return CGSize(width: width, height: height)
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
            pagingImageCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            pagingImageCollectionView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            pagingImageCollectionView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
