//
//  PopupDetailViewController.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/25/24.
//

import UIKit

final class PopupDetailViewController: UIViewController {
    private let viewModel = PopupDetailViewModel()

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: generateCollectionViewLayout()
    )

    private var segmentIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        configureInitialSetting()
        configureSubviews()
        configureLayout()
        bind(to: viewModel)
        mockingData()
    }

    private func bind(to viewModel: PopupDetailViewModel) {
        viewModel.popupMainInformationPublisher = { [weak self] in
            guard let self else { return }
            if self.collectionView.numberOfItems(inSection: 0) == 0 {
                DispatchQueue.main.async {
                    self.collectionView.reloadSections(IndexSet(0...0))
                }
            }
        }

        viewModel.popupDetailInformationPublisher = { [weak self] in
            guard let self else { return }
            if segmentIndex == 0 {
                DispatchQueue.main.async {
                    self.collectionView.reloadSections(IndexSet(1...1))
                }
            }
        }

        viewModel.popupRatingPublisher = { [weak self] in
            guard let self else { return }
            if segmentIndex == 1 {
                DispatchQueue.main.async {
                    self.collectionView.reloadSections(IndexSet(1...1))
                }
            }
        }

        viewModel.popupReviewsDataPublisher = { [weak self] in
            guard let self else { return }
            if segmentIndex == 1 {
                DispatchQueue.main.async {
                    self.collectionView.reloadSections(IndexSet(2...2))
                }
            }
        }
    }
}

// MARK: - Configure Initial Setting
extension PopupDetailViewController {
    private func configureInitialSetting() {
        view.backgroundColor = .white
        configureCollectionView()
    }

    private func configureCollectionView() {
        collectionView.dataSource = self

        collectionView.register(
            PopupTitleCollectionViewCell.self,
            forCellWithReuseIdentifier: PopupTitleCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            PopupDetailInfoCollectionViewCell.self,
            forCellWithReuseIdentifier: PopupDetailInfoCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            PopupRatingCollectionViewCell.self,
            forCellWithReuseIdentifier: PopupRatingCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            ReviewCollectionViewCell.self,
            forCellWithReuseIdentifier: ReviewCollectionViewCell.reuseIdentifier
        )

        collectionView.register(
            CarouselHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CarouselHeaderView.reuseIdentifier
        )
        collectionView.register(
            PopupInfoReviewSegmentHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PopupInfoReviewSegmentHeaderView.reuseIdentifier
        )
        collectionView.register(
            ReviewSortButtonHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ReviewSortButtonHeaderView.reuseIdentifier
        )
    }
}

// MARK: - Implement CollectionView DataSource
extension PopupDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return segmentIndex == 0 ? 2 : 3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch (section, segmentIndex) {
        case (0, _):
            return 1
        case (1, _):
            return 1
        case (2, 1):
            return viewModel.numbersOfReviews()
        default:
            return 0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch (indexPath.section, segmentIndex) {
        case (0, _):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PopupTitleCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? PopupTitleCollectionViewCell else {
                return UICollectionViewCell()
            }

            let data = viewModel.provideMainInformationData()
            cell.configureContents(
                title: data.popupTitle,
                period: data.popupPeriod,
                isUserPick: data.isUserPick,
                hashTags: data.hashTags
            )

            return cell
        case (1, 0):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PopupDetailInfoCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? PopupDetailInfoCollectionViewCell else {
                return UICollectionViewCell()
            }

            let data = viewModel.provideDetailInformationData()
            cell.configureContents(
                address: data.address,
                officialLink: data.officialLink,
                businessHourInfo: data.buisinessHours,
                popupIntroduce: data.introduce
            )

            return cell
        case (1, 1):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PopupRatingCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? PopupRatingCollectionViewCell else {
                return UICollectionViewCell()
            }

            let (data, maximumIndex) = viewModel.provideRatingData()
            cell.configureContents(
                totalRatingCount: data.totalRatingCount,
                averageRating: data.averageRating,
                ratingDistribution: data.starBreakDown,
                maximumIndex: maximumIndex
            )

            return cell
        case (2, 1):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ReviewCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? ReviewCollectionViewCell else {
                return UICollectionViewCell()
            }

            let data = viewModel.provideReviewData(at: indexPath.item)

            cell.configureContents(
                profileImage: data.profileImage,
                nickName: data.nickname,
                starRating: data.rating,
                reviewDate: data.reviewDate,
                reviewImages: data.images,
                reviewText: data.reviewText
            )

            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch (indexPath.section, segmentIndex) {
        case (0, _):
            guard let carouselHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: CarouselHeaderView.reuseIdentifier,
                for: indexPath
            ) as? CarouselHeaderView else {
                return UICollectionReusableView()
            }

            carouselHeader.configureContents(viewModel: viewModel)
            return carouselHeader
        case (1, _):
            guard let segmentHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: PopupInfoReviewSegmentHeaderView.reuseIdentifier,
                for: indexPath
            ) as? PopupInfoReviewSegmentHeaderView else {
                return UICollectionReusableView()
            }

            segmentHeader.delegate = self

            return segmentHeader
        case (2, 1):
            guard let reviewSortHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: ReviewSortButtonHeaderView.reuseIdentifier,
                for: indexPath
            ) as? ReviewSortButtonHeaderView else {
                return UICollectionReusableView()
            }

            return reviewSortHeader
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - Configure CollectionView Compositional Layout
extension PopupDetailViewController {
    private func generateCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self else { return nil }

            switch (sectionIndex, segmentIndex) {
            case (0, _):
                return generateMainInfoLayout()
            case (1, 0):
                return generateDetailInfoLayout()
            case (1, 1):
                return generateRatingLayout()
            case (2, 1):
                return generateReviewLayout()
            default:
                return generateDetailInfoLayout()
            }
        }
    }

    private func generateMainInfoLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let headersize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(359/394)
        )
        let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headersize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        section.boundarySupplementaryItems = [headerSupplementary]
        section.supplementaryContentInsetsReference = .none

        return section
    }

    private func generateDetailInfoLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(250))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(250))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(37/394)
        )
        let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        section.boundarySupplementaryItems = [headerSupplementary]
        section.supplementaryContentInsetsReference = .none

        return section
    }

    private func generateRatingLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(347)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(347)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(37/394)
        )
        let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        section.boundarySupplementaryItems = [headerSupplementary]
        section.supplementaryContentInsetsReference = .none

        return section
    }

    private func generateReviewLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(60/394)
        )
        let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)

        section.boundarySupplementaryItems = [headerSupplementary]
        section.supplementaryContentInsetsReference = .none

        return section
    }
}

// MARK: - Implement PopupInfoReviewSegmentHeaderView Delegate
extension PopupDetailViewController: PopupInfoReviewSegmentHeaderViewDelegate {
    func didChangedSegment(to index: Int) {
        segmentIndex = index
        collectionView.reloadData()
    }
}

// MARK: - Configure UI
extension PopupDetailViewController {
    private func configureSubviews() {
        [collectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

// MARK: - Mocking
extension PopupDetailViewController {
    private func mockingData() {
        viewModel.generateMockData()
    }
}
