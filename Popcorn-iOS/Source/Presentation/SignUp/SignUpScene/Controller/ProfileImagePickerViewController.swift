//
//  ProfileImagePickerViewController.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/5/25.
//

import UIKit

class ProfileImagePickerViewController: UIViewController {
    var selectedImageHandler: ((UIImage?, UIColor?) -> Void)?
    private let profileImagePickerView = ProfileImagePickerView()
    private let cellSize = (UIScreen.main.bounds.width - (29 * 2 + 18 * 2)) / 3

    private var selectedImageIndex: Int?

    private let images: [UIImage] = [
        UIImage(resource: .popcornProfile1),
        UIImage(resource: .popcornProfile2),
        UIImage(resource: .popcornProfile3),
        UIImage(resource: .popcornProfile4),
        UIImage(resource: .popcornProfile5)
    ]

    private let colors: [UIColor] = [
        UIColor(resource: .popcornProfile1),
        UIColor(resource: .popcornProfile2),
        UIColor(resource: .popcornProfile3),
        UIColor(resource: .popcornProfile4),
        UIColor(resource: .popcornProfile5)
    ]

    override func loadView() {
        view = profileImagePickerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureProfileImagePickerView()
        configureCollectionView()
        configureActions()
    }
}

// MARK: - Configure View
extension ProfileImagePickerViewController {
    private func configureProfileImagePickerView() {
        guard let sheet = self.sheetPresentationController else { return }
        let customDetent = UISheetPresentationController.Detent.custom { _ in self.cellSize * 4.6 }
        sheet.detents = [customDetent]
        sheet.prefersGrabberVisible = false
        isModalInPresentation = false
    }

    private func configureCollectionView() {
        let collectionView = profileImagePickerView.collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            ProfileImageCell.self,
            forCellWithReuseIdentifier: ProfileImageCell.reuseIdentifier
        )
    }

    private func configureActions() {
        profileImagePickerView.closeButton.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }, for: .touchUpInside)

        profileImagePickerView.completeButton.addAction(UIAction { [weak self] _ in
            self?.completeButtonTapped()
        }, for: .touchUpInside)
    }

    private func completeButtonTapped() {
        guard let selectedIndex = selectedImageIndex else { return }
        let selectedImage = images[selectedIndex]
        let selectedColor = colors[selectedIndex]
        selectedImageHandler?(selectedImage, selectedColor)
        dismiss(animated: true)
    }

}

// MARK: - UICollectionView DataSource & Delegate
extension ProfileImagePickerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 2
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileImageCell.reuseIdentifier,
            for: indexPath
        ) as? ProfileImageCell else {
            return UICollectionViewCell()
        }

        let globalIndex = (indexPath.section == 0) ? indexPath.item : 3 + indexPath.item
        let image = images[globalIndex]
        let color = colors[globalIndex]

        let isSelected = selectedImageIndex == globalIndex
        cell.configureContents(image: image, color: color, isSelected: isSelected)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let globalIndex = (indexPath.section == 0) ? indexPath.item : 3 + indexPath.item

        let previousIndex = selectedImageIndex

        if selectedImageIndex == globalIndex {
            selectedImageIndex = nil
        } else {
            selectedImageIndex = globalIndex
        }

        if let previousIndex = previousIndex {
            let previousIndexPath = IndexPath(
                item: (previousIndex < 3) ? previousIndex : previousIndex - 3,
                section: (previousIndex < 3) ? 0 : 1
            )
            if let previousCell = collectionView.cellForItem(at: previousIndexPath) as? ProfileImageCell {
                let previousImage = images[previousIndex]
                let previousColor = colors[previousIndex]
                previousCell.configureContents(image: previousImage, color: previousColor, isSelected: false)
            }
        }

        if let currentIndex = selectedImageIndex {
            let currentIndexPath = IndexPath(
                item: (currentIndex < 3) ? currentIndex : currentIndex - 3,
                section: (currentIndex < 3) ? 0 : 1
            )
            if let currentCell = collectionView.cellForItem(at: currentIndexPath) as? ProfileImageCell {
                let currentImage = images[currentIndex]
                let currentColor = colors[currentIndex]
                currentCell.configureContents(image: currentImage, color: currentColor, isSelected: true)
            }
        }

        let isButtonEnabled = selectedImageIndex != nil
        profileImagePickerView.completeButton.isEnabled = isButtonEnabled
        var config = profileImagePickerView.completeButton.configuration
        config?.background.backgroundColor = isButtonEnabled
            ? UIColor(resource: .popcornOrange)
            : UIColor(resource: .popcornGray2)
        profileImagePickerView.completeButton.configuration = config
    }
}

// MARK: - Configure Cell Layout
extension ProfileImagePickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 18
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let totalWidth = collectionView.bounds.width
        let cellWidth: CGFloat = cellSize
        let horizontalSpacing: CGFloat = 18

        let totalCellWidthTop = (cellWidth * 3) + (horizontalSpacing * 2)
        let horizontalPaddingTop = (totalWidth - totalCellWidthTop) / 2

        let totalCellWidthBottom = (cellWidth * 2) + horizontalSpacing
        let horizontalPaddingBottom = (totalWidth - totalCellWidthBottom) / 2

        if section == 0 {
            return UIEdgeInsets(top: 0, left: horizontalPaddingTop, bottom: 0, right: horizontalPaddingTop)
        } else {
            return UIEdgeInsets(top: 18, left: horizontalPaddingBottom, bottom: 0, right: horizontalPaddingBottom)
        }
    }
}
