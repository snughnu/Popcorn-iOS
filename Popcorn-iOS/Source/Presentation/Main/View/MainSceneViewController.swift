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
