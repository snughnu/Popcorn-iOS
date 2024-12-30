//
//  MainDetailViewController.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/25/24.
//

import UIKit

final class MainDetailViewController: UIViewController {
    private let detailViewModel = MainSceneViewModel()
    private let detailScrollView = UIScrollView()
    private let detailContentView = UIView()
    private let detailCarouselView: MainCarouselView

    init() {
        detailCarouselView = MainCarouselView(viewModel: detailViewModel)
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
        detailViewModel.fetchPopupImages()
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
        [detailScrollView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [detailContentView].forEach {
            detailScrollView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [detailCarouselView].forEach {
            detailContentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            detailScrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            detailScrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            detailScrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            detailScrollView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            detailScrollView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),

            detailContentView.topAnchor.constraint(equalTo: detailScrollView.contentLayoutGuide.topAnchor),
            detailContentView.leadingAnchor.constraint(equalTo: detailScrollView.contentLayoutGuide.leadingAnchor),
            detailContentView.bottomAnchor.constraint(equalTo: detailScrollView.contentLayoutGuide.bottomAnchor),
            detailContentView.centerXAnchor.constraint(equalTo: detailScrollView.contentLayoutGuide.centerXAnchor),
            detailContentView.widthAnchor.constraint(equalTo: detailScrollView.widthAnchor),

            detailCarouselView.topAnchor.constraint(equalTo: detailContentView.topAnchor),
            detailCarouselView.leadingAnchor.constraint(equalTo: detailContentView.leadingAnchor),
            detailCarouselView.centerXAnchor.constraint(equalTo: detailContentView.centerXAnchor),
        ])
    }
}
