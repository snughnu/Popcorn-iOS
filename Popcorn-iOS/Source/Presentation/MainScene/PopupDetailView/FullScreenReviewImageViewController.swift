//
//  FullScreenReviewImageViewController.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 1/12/25.
//

import UIKit

final class FullScreenReviewImageViewController: UIViewController {
    private var reviewImages: [UIImage]
    private var selectedIndex: Int = 0

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .closeButton), for: .normal)
        return button
    }()

    private let previousPageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .leftArrowWhite), for: .normal)
        button.tag = -1
        return button
    }()

    private let nextPageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .rightArrowWhite), for: .normal)
        button.tag = 1
        return button
    }()

    init(reviewImages: [UIImage], selectedIndex: Int) {
        self.reviewImages = reviewImages
        self.selectedIndex = selectedIndex
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureInitialSetting()
        configureActions()
        configureSubviews()
        configureLayout()
        showSelectedImage()
    }
}

// MARK: - Initial Setting
extension FullScreenReviewImageViewController {
    private func configureInitialSetting() {
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            MainCarouselCollectionViewCell.self,
            forCellWithReuseIdentifier: MainCarouselCollectionViewCell.reuseIdentifier
        )

        if reviewImages.count == 1 {
            previousPageButton.isHidden = true
            nextPageButton.isHidden = true
        }
    }

    private func showSelectedImage() {
        DispatchQueue.main.async { [weak self] in
            let indexPath = IndexPath(item: self?.selectedIndex ?? 0, section: 0)
            self?.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            self?.updateButtonVisibility(currentIndex: self?.selectedIndex ?? 0)
        }
    }

    private func updateButtonVisibility(currentIndex: Int) {
        previousPageButton.isHidden = currentIndex == 0
        nextPageButton.isHidden = currentIndex == reviewImages.count - 1
    }
}

// MARK: - Configure Actions
extension FullScreenReviewImageViewController {
    private func configureActions() {
        nextPageButton.addTarget(self, action: #selector(handlePageChange(_:)), for: .touchUpInside)
        previousPageButton.addTarget(self, action: #selector(handlePageChange(_:)), for: .touchUpInside)

        closeButton.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }, for: .touchUpInside)
    }

    @objc private func handlePageChange(_ sender: UIButton) {
        let visibleItems = collectionView.indexPathsForVisibleItems
        guard let currentIndexPath = visibleItems.first else { return }

        let nextItem = currentIndexPath.item + sender.tag

        guard nextItem >= 0 && nextItem < reviewImages.count else { return }

        let nextIndexPath = IndexPath(item: nextItem, section: 0)
        collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)

        updateButtonVisibility(currentIndex: nextItem)
    }
}

// MARK: - Implement UICollectionView DataSource
extension FullScreenReviewImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewImages.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MainCarouselCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? MainCarouselCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.configureContents(image: reviewImages[indexPath.item])

        return cell
    }
}

// MARK: - Implement UICollectionView Delegate
extension FullScreenReviewImageViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        updateButtonVisibility(currentIndex: page)
    }
}

// MARK: - Implement UICollectionView DelegateFlowLayout
extension FullScreenReviewImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.bounds.width
        let height = width

        return CGSize(width: width, height: height)
    }
}

// MARK: - Configure UI
extension FullScreenReviewImageViewController {
    private func configureSubviews() {
        [collectionView, closeButton, previousPageButton, nextPageButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor),

            closeButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 23),
            closeButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 26),

            previousPageButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            previousPageButton.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),

            nextPageButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            nextPageButton.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
    }
}
