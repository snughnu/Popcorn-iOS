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

    private var selectedImageIndex: Int? {
        didSet {
            profileImagePickerView.collectionView.reloadData()
        }
    }

    private let imageColors: [ImageColor] = [
        ImageColor(image: UIImage(resource: .popcornProfile1), color: UIColor(resource: .popcornProfile1)),
        ImageColor(image: UIImage(resource: .popcornProfile2), color: UIColor(resource: .popcornProfile2)),
        ImageColor(image: UIImage(resource: .popcornProfile3), color: UIColor(resource: .popcornProfile3)),
        ImageColor(image: UIImage(resource: .popcornProfile4), color: UIColor(resource: .popcornProfile4)),
        ImageColor(image: UIImage(resource: .popcornProfile5), color: UIColor(resource: .popcornProfile5))
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
        let selectedImageColor = imageColors[selectedIndex]
        selectedImageHandler?(selectedImageColor.image, selectedImageColor.color)
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
        let imageColor = imageColors[globalIndex] // 모델에서 데이터 가져오기

        let isSelected = selectedImageIndex == globalIndex
        cell.configureContents(image: imageColor.image, color: imageColor.color, isSelected: isSelected)
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let globalIndex = (indexPath.section == 0) ? indexPath.item : 3 + indexPath.item

        if selectedImageIndex == globalIndex {
            selectedImageIndex = nil
        } else {
            selectedImageIndex = globalIndex
        }

        let isButtonEnabled = selectedImageIndex != nil
        profileImagePickerView.completeButton.isEnabled = isButtonEnabled
        var config = profileImagePickerView.completeButton.configuration
        config?.background.backgroundColor = isButtonEnabled
            ? UIColor(resource: .popcornOrange)
            : UIColor(resource: .popcornGray2)
        profileImagePickerView.completeButton.configuration = config

        collectionView.reloadData()
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
