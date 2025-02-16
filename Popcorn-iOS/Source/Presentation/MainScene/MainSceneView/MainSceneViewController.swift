//
//  MainSceneViewController.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/17/24.
//

import UIKit

final class MainSceneViewController: UIViewController {
    private let mainViewModel: MainSceneViewModel

    private lazy var mainCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: generateCollectionViewLayout()
    )

    init(mainViewModel: MainSceneViewModel = MainSceneViewModel()) {
        self.mainViewModel = mainViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureInitialSetting()
        configureSubviews()
        configureLayout()
        bind(to: mainViewModel)
        mainViewModel.fetchMockData()
    }

    func bind(to viewModel: MainSceneViewModel) {
        viewModel.fetchPopupImagesErrorPublisher = { [weak self] in
            guard let self else { return }
            self.mainCollectionView.reloadData()
        }

        viewModel.fetchPopupImagesErrorPublisher = { [weak self] in
            guard let self else { return }
            self.mainCollectionView.reloadData()
        }
    }
}

// MARK: - Configure Initial Setting
extension MainSceneViewController {
    private func configureInitialSetting() {
        view.backgroundColor = UIColor.white
        configureCollectionView()
    }

    private func configureCollectionView() {
        mainCollectionView.dataSource = self

        mainCollectionView.register(
            PickOrInterestCell.self,
            forCellWithReuseIdentifier: PickOrInterestCell.reuseIdentifier
        )
        mainCollectionView.register(
            ClosingSoonPopupCell.self,
            forCellWithReuseIdentifier: ClosingSoonPopupCell.reuseIdentifier
        )
        mainCollectionView.register(
            MainCarouselPickHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MainCarouselPickHeaderView.reuseIdentifier
        )
        mainCollectionView.register(
            MainCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MainCollectionHeaderView.reuseIdentifier
        )
    }

}

// MARK: - Configure CollectionView DataSource
extension MainSceneViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 + mainViewModel.getDataSource().numbersOfInterest()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfInterest = mainViewModel.getDataSource().numbersOfInterest()

        switch section {
        case 0:
            return mainViewModel.getDataSource().numbersOfPopup(of: .userPick)
        case 1..<(1 + numberOfInterest):
            return mainViewModel.getDataSource().numbersOfPopup(of: .userInterest, at: section - 1)
        case (1 + numberOfInterest):
            return mainViewModel.getDataSource().numbersOfPopup(of: .closingSoon)
        default:
            return 0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let numbersOfInterest = mainViewModel.getDataSource().numbersOfInterest()
        let popupData = mainViewModel.getDataSource().item(at: indexPath)

        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PickOrInterestCell.reuseIdentifier,
                for: indexPath
            ) as? PickOrInterestCell else {
                return UICollectionViewCell()
            }

            if let popupDDay = popupData.popupDDay {
                mainViewModel.fetchImage(url: popupData.popupImageUrl) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let imageData):
                            if let image = UIImage(data: imageData) {
                                cell.configureContents(
                                    popupImage: image,
                                    popupTitle: popupData.popupTitle,
                                    dDay: popupDDay
                                )
                            }
                        case .failure:
                            cell.configureContents(
                                popupImage: UIImage(resource: .popupPreviewPlaceHolder),
                                popupTitle: popupData.popupTitle,
                                dDay: popupDDay
                            )
                        }
                    }
                }
            } else {
                cell.configureContents(
                    popupImage: UIImage(resource: .popupPreviewPlaceHolder),
                    popupTitle: PopupPreviewViewData.placeholder.popupTitle,
                    dDay: PopupPreviewViewData.placeholder.popupDDay!
                )
            }
            return cell

        case (1..<(1 + numbersOfInterest)):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PickOrInterestCell.reuseIdentifier,
                for: indexPath
            ) as? PickOrInterestCell else {
                return UICollectionViewCell()
            }

            if let popupDDay = popupData.popupDDay {
                mainViewModel.fetchImage(url: popupData.popupImageUrl) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let imageData):
                            if let image = UIImage(data: imageData) {
                                cell.configureContents(
                                    popupImage: image,
                                    popupTitle: popupData.popupTitle,
                                    dDay: popupDDay
                                )
                            }
                        case .failure:
                            cell.configureContents(
                                popupImage: UIImage(resource: .popupPreviewPlaceHolder),
                                popupTitle: popupData.popupTitle,
                                dDay: popupDDay
                            )
                        }
                    }
                }
            } else {
                cell.configureContents(
                    popupImage: UIImage(resource: .popupPreviewPlaceHolder),
                    popupTitle: PopupPreviewViewData.placeholder.popupTitle,
                    dDay: PopupPreviewViewData.placeholder.popupDDay!
                )
            }
            return cell

        case (1 + numbersOfInterest):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ClosingSoonPopupCell.reuseIdentifier,
                for: indexPath
            ) as? ClosingSoonPopupCell else {
                return UICollectionViewCell()
            }

            if let popupPeriod = popupData.popupPeriod,
               let popupLocation = popupData.popupLocation {
                mainViewModel.fetchImage(url: popupData.popupImageUrl) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let imageData):
                            DispatchQueue.main.async {
                                if let image = UIImage(data: imageData) {
                                    cell.configureContents(
                                        popupImage: image,
                                        popupTitle: popupData.popupTitle,
                                        period: popupPeriod,
                                        location: popupLocation
                                    )
                                }
                            }
                        case .failure:
                            cell.configureContents(
                                popupImage: UIImage(resource: .popupPreviewPlaceHolder),
                                popupTitle: popupData.popupTitle,
                                period: popupPeriod,
                                location: popupLocation
                            )
                        }
                    }
                }
            } else {
                cell.configureContents(
                    popupImage: UIImage(resource: .popupPreviewPlaceHolder),
                    popupTitle: PopupPreviewViewData.placeholder.popupTitle,
                    period: PopupPreviewViewData.placeholder.popupPeriod!,
                    location: PopupPreviewViewData.placeholder.popupLocation!
                )
            }

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
        switch indexPath.section {
        case 0:
            guard let carouselHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: MainCarouselPickHeaderView.reuseIdentifier,
                for: indexPath
            ) as? MainCarouselPickHeaderView else {
                return UICollectionReusableView()
            }

            carouselHeader.configureContents(headerTitle: "찜 목록", viewModel: mainViewModel)
            return carouselHeader
        case 1..<(1 + mainViewModel.getDataSource().numbersOfInterest()):
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: MainCollectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as? MainCollectionHeaderView else {
                return UICollectionReusableView()
            }

            let headerTitle = mainViewModel
                .getDataSource()
                .provideUserInterestTitle(sectionOfInterest: indexPath.section - 1)

            header.configureContents(headerTitle: headerTitle)
            return header
        case (1 + mainViewModel.getDataSource().numbersOfInterest()):
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: MainCollectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as? MainCollectionHeaderView else {
                return UICollectionReusableView()
            }

            header.configureContents(headerTitle: "지금 놓치면 안 될 팝업스토어", shouldHiddenShowButton: true)
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - Configure CollectionView Compositional Layout
extension MainSceneViewController {
    private func generateCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self else { return nil }

            switch sectionIndex {
            case 0:
                return generateHorizontalLayout(isPickSection: true)
            case 1..<(1 + self.mainViewModel.getDataSource().numbersOfInterest()):
                return generateHorizontalLayout()
            case self.mainViewModel.getDataSource().numbersOfInterest() + 1:
                return generateVerticalGridLayout()
            default:
                return generateHorizontalLayout()
            }
        }
    }

    private func generateHorizontalLayout(isPickSection: Bool = false) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: isPickSection ? .estimated(160) : .estimated(180)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: isPickSection ? .fractionalWidth(140/393) : .fractionalWidth(160/393),
            heightDimension: isPickSection ? .estimated(160) : .estimated(180)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 35, leading: 26, bottom: 25, trailing: 0)
        section.interGroupSpacing = 10

        section.orthogonalScrollingBehavior = .continuous

        let headerSize: NSCollectionLayoutSize

        if isPickSection {
            headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(446/393))
        } else {
            headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        }

        let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [headerSupplementary]
        section.supplementaryContentInsetsReference = .none

        return section
    }

    private func generateVerticalGridLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(260)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(260))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(9)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 35
        section.contentInsets = NSDirectionalEdgeInsets(top: 35, leading: 25, bottom: 0, trailing: 25)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [headerSupplementary]
        section.supplementaryContentInsetsReference = .none

        return section
    }
}

// MARK: - Configure UI
extension MainSceneViewController {
    private func configureSubviews() {
        [mainCollectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),
            mainCollectionView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
    }
}

// MARK: - Mocking
extension MainSceneViewController {
    private func mockingData() {
        mainViewModel.fetchMockData()
    }
}
