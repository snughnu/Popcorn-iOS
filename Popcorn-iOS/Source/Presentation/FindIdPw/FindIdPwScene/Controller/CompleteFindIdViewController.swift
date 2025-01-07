//
//  FindIdViewController.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 12/30/24.
//

import UIKit

class CompleteFindIdViewController: UIViewController {
    private let completeFindIdView = CompleteFindIdView()
    private let screenHeight = UIScreen.main.bounds.height

    override func loadView() {
        view = completeFindIdView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupAddActions()
    }
}

// MARK: - Setup NavigationBar
extension CompleteFindIdViewController {
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
extension CompleteFindIdViewController {
    private func setupAddActions() {
        completeFindIdView.completeButton.addAction(UIAction { _ in
            self.completeButtonTapped()
        }, for: .touchUpInside)
    }
}

// MARK: - selector 함수
extension CompleteFindIdViewController {
    @objc private func completeButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
