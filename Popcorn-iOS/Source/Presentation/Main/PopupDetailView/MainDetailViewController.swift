//
//  MainDetailViewController.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/25/24.
//

import UIKit

final class MainDetailViewController: UIViewController {
//    private let detailViewModel = MainSceneViewModel()

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
extension MainDetailViewController {
    private func configureInitialSetting() {
        view.backgroundColor = .white
    }
}

// MARK: - Configure UI
extension MainDetailViewController {
    private func configureSubviews() {

    }

    private func configureLayout() {

    }
}
