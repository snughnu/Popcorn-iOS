//
//  MainSceneViewController.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/17/24.
//

import UIKit

final class MainSceneViewController: UIViewController {
    private let mainViewModel = MainSceneViewModel()
    private let mainCellPagingImageView: MainCellPagingImageView
    private lazy var mainCollectionView = UICollectionView()

    init() {
        mainCellPagingImageView = MainCellPagingImageView(mainCellPagingViewModel: mainViewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureInitialSetting()
        configureSubviews()
        configureLayout()
    }
}

// MARK: - Configure Initial Setting
extension MainSceneViewController {
    private func configureInitialSetting() {
        view.backgroundColor = .white
        configureCollectionView()
    }

    private func configureCollectionView() {
        mainCollectionView.dataSource = self
//        mainCollectionView.delegate = self

        mainCollectionView.register(
            PickOrInterestCell.self,
            forCellWithReuseIdentifier: PickOrInterestCell.reuseIdentifier
        )
        mainCollectionView.register(
            ClosingSoonPopupCell.self,
            forCellWithReuseIdentifier: ClosingSoonPopupCell.reuseIdentifier
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
        return 2 + mainViewModel.numbersOfInterest()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfInterest = mainViewModel.numbersOfInterest()

        switch section {
        case 0:
            return mainViewModel.numbersOfPopup(of: .userPick)
        case 1..<(1 + numberOfInterest):
            return mainViewModel.numbersOfPopup(of: .userInterest, at: section - 1)
        case (1 + numberOfInterest):
            let count = mainViewModel.numbersOfPopup(of: .closingSoon)
            return count
        default:
            return 0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let numberOfInterest = mainViewModel.numbersOfInterest()
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PickOrInterestCell.reuseIdentifier,
                for: indexPath
            ) as? PickOrInterestCell else {
                return UICollectionViewCell()
            }

            if let popupData = mainViewModel.providePopupPreviewData(of: .userPick, at: indexPath.row),
               let popupTitle = popupData.popupTitle,
               let popupDDay = popupData.popupDDay {
                cell.configureContents(
                    popupImage: popupData.popupImage,
                    popupTitle: popupTitle,
                    dDay: popupDDay
                )
            }
            return cell

        case (1..<(1 + numberOfInterest)):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PickOrInterestCell.reuseIdentifier,
                for: indexPath
            ) as? PickOrInterestCell else {
                return UICollectionViewCell()
            }

            if let popupData = mainViewModel.providePopupPreviewData(
                of: .userInterest,
                at: indexPath.row,
                sectionOfInterest: indexPath.section - 1
            ),
               let popupTitle = popupData.popupTitle,
               let popupDDay = popupData.popupDDay {
                cell.configureContents(
                    popupImage: popupData.popupImage,
                    popupTitle: popupTitle,
                    dDay: popupDDay
                )
            }
            return cell

        case (1 + numberOfInterest):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ClosingSoonPopupCell.reuseIdentifier,
                for: indexPath
            ) as? ClosingSoonPopupCell else {
                return UICollectionViewCell()
            }

            if let popupData = mainViewModel.providePopupPreviewData(of: .closingSoon, at: indexPath.row),
               let popupTitle = popupData.popupTitle,
               let popupStartDate = popupData.popupStartDate,
               let popupDueDate = popupData.popupDueDate,
               let popupLocation = popupData.popupLocation {
                cell.configureContents(
                    popupImage: popupData.popupImage,
                    popupTitle: popupTitle,
                    period: "\(popupStartDate)~\(popupDueDate)",
                    location: popupLocation
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
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MainCollectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as? MainCollectionHeaderView else {
            return UICollectionReusableView()
        }
        switch indexPath.section {
        case 0:
            header.configureContents(headerTitle: "찜 목록")
        case 1..<(1 + mainViewModel.numbersOfPopup(of: .userInterest)):
            if let popupData = mainViewModel.providePopupPreviewData(
                of: .userInterest,
                at: indexPath.row,
                sectionOfInterest: indexPath.section - 1
            ),
               let userInterestTitle = popupData.popupTitle {
                header.configureContents(headerTitle: userInterestTitle)
            }
        case 1 + mainViewModel.numbersOfInterest():
            header.configureContents(headerTitle: "지금 놓치면 안 될 팝업스토어")
        default:
            break
        }
        return header
    }
}

    }
}

// MARK: - Configure UI
extension MainSceneViewController {
    private func configureSubviews() {
        [mainCellPagingImageView, mainCollectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mainCellPagingImageView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            mainCellPagingImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mainCellPagingImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            mainCellPagingImageView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.37),
            
            mainCellPagingImageView.topAnchor.constraint(equalTo: mainCellPagingImageView.bottomAnchor),
            mainCellPagingImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mainCellPagingImageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            mainCellPagingImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
    }
}
