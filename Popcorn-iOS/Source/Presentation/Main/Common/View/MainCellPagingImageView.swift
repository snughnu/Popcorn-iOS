//
//  MainCellPagingImageView.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/16/24.
//

import UIKit

final class MainCellPagingImageView: UIView {
    private let viewModel: MainSceneViewModel

    private let pagingImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true

        return collectionView
    }()

    private let imagePageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = UIColor(red: 0.3, green: 1, blue: 1, alpha: 1)
        pageControl.pageIndicatorTintColor = .white

        return pageControl
    }()

    init(mainCellPagingViewModel: MainSceneViewModel) {
        viewModel = mainCellPagingViewModel
        super.init(frame: .zero)
        configureInitialSetting()
        configureSubviews()
        configureLayout()
        bind(to: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind(to viewModel: MainSceneViewModel) {
        viewModel.todayRecommendedPopupPublisher = { [weak self] in
            guard let self else { return }
            self.imagePageControl.numberOfPages = self.viewModel.numbersOfPopup(of: .todayRecommended)
            self.pagingImageCollectionView.reloadData()
        }

        viewModel.currentPagePublisher = { [weak self] currentPage in
            self?.imagePageControl.currentPage = currentPage
        }
    }
}

// MARK: - Configure Initial Setting
extension MainCellPagingImageView {
    private func configureInitialSetting() {
        pagingImageCollectionView.dataSource = self
        pagingImageCollectionView.delegate = self

        pagingImageCollectionView.register(
            MainCellPagingCollectionViewCell.self,
            forCellWithReuseIdentifier: MainCellPagingCollectionViewCell.reuseIdentifier
        )
    }
}

// MARK: - Configure CollectionView DataSource
extension MainCellPagingImageView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.numbersOfPopup(of: .todayRecommended)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MainCellPagingCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? MainCellPagingCollectionViewCell else {
            return UICollectionViewCell()
        }

        let imageData = viewModel.popupPreview(at: indexPath.row, of: .todayRecommended).popupImage

        if let image = UIImage(data: imageData) {
            cell.configureContents(image: image)
        }

        return cell
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

// MARK: - Configure ScrollView Delegate
extension MainCellPagingImageView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width

        if width != 0 {
            let currentPosition = Int(scrollView.contentOffset.x / width)
            viewModel.updateCurrentPage(at: currentPosition)
        }
    }
}

// MARK: - Configure UI
extension MainCellPagingImageView {
    private func configureSubviews() {
        [pagingImageCollectionView, imagePageControl].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            pagingImageCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            pagingImageCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            pagingImageCollectionView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            pagingImageCollectionView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),

            imagePageControl.bottomAnchor.constraint(equalTo: pagingImageCollectionView.bottomAnchor),
            imagePageControl.centerXAnchor.constraint(equalTo: pagingImageCollectionView.centerXAnchor)
        ])
    }
}
