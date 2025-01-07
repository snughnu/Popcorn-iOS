//
//  CompleteResetPwViewController.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/5/25.
//

import UIKit

class CompleteResetPwViewController: UIViewController {
    private let completeResetPwView = CompleteResetPwView()
    private let screenHeight = UIScreen.main.bounds.height

    override func loadView() {
        view = completeResetPwView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupAddActions()
    }
}

// MARK: - Setup NavigationBar
extension CompleteResetPwViewController {
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "아이디/비밀번호 찾기"
        let size = screenHeight * 21/852
        titleLabel.font = UIFont(name: RobotoFontName.robotoSemiBold, size: size)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
        navigationItem.hidesBackButton = true
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(resource: .naviBackButton), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 20
        navigationItem.leftBarButtonItems = [spacer, leftBarButtonItem]
    }

    @objc private func backButtonTapped() {
       navigationController?.popViewController(animated: true)
    }
}

// MARK: - Setup AddActions
extension CompleteResetPwViewController {
    private func setupAddActions() {
        completeResetPwView.goToLoginViewButton.addAction(UIAction { _ in
            self.goToLoginViewButtonTapped()
        }, for: .touchUpInside)
    }

    private func goToLoginViewButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
