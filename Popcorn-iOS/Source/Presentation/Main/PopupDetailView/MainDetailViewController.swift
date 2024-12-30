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

    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "정보", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "후기", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 0

        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: RobotoFontName.robotoSemiBold, size: 21)!
        ], for: .selected)

        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: RobotoFontName.robotoMedium, size: 21)!
        ], for: .normal)

        segmentedControl.selectedSegmentTintColor = .clear
        segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentedControl.setDividerImage(
            UIImage(),
            forLeftSegmentState: .normal,
            rightSegmentState: .normal,
            barMetrics: .default
        )

        return segmentedControl
    }()

    private let segmentedUnderLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 3).isActive = true
        return view
    }()

    private let segmentedGrayUnderLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .popcornGray2)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 3).isActive = true
        return view
    }()

    private var segmentedUnderlineLeadingConstraint: NSLayoutConstraint!

    private let popupDetailInfoView = PopupDetailInfoView()

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
        configureActions()
        detailViewModel.fetchPopupImages()
    }
}

// MARK: - Configure Initial Setting
extension MainDetailViewController {
    private func configureInitialSetting() {
        view.backgroundColor = .white
    }
}

// MARK: - Configure Action
extension MainDetailViewController {
    private func configureActions() {
        segmentedControl.addTarget(self, action: #selector(changeSegmentedLinePosition), for: .valueChanged)
    }

    @objc private func changeSegmentedLinePosition(_ segment: UISegmentedControl) {
        let leadingOffset: CGFloat = CGFloat(segmentedControl.selectedSegmentIndex)
        * view.bounds.width
        / CGFloat(segmentedControl.numberOfSegments)

        segmentedUnderlineLeadingConstraint.constant = leadingOffset

        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
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

        [
            detailCarouselView,
            segmentedControl,
            segmentedGrayUnderLineView,
            segmentedUnderLineView,
            popupDetailInfoView
        ].forEach {
            detailContentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        segmentedUnderlineLeadingConstraint = segmentedUnderLineView.leadingAnchor.constraint(
            equalTo: segmentedControl.leadingAnchor
        )

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

            segmentedControl.topAnchor.constraint(equalTo: detailCarouselView.bottomAnchor, constant: 13),
            segmentedControl.leadingAnchor.constraint(equalTo: detailContentView.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: detailContentView.trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),

            segmentedGrayUnderLineView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            segmentedGrayUnderLineView.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor),
            segmentedGrayUnderLineView.trailingAnchor.constraint(equalTo: segmentedControl.trailingAnchor),

            segmentedUnderLineView.topAnchor.constraint(equalTo: segmentedGrayUnderLineView.topAnchor),
            segmentedUnderLineView.widthAnchor.constraint(
                equalTo: segmentedGrayUnderLineView.widthAnchor, multiplier: 0.5
            ),

            segmentedUnderlineLeadingConstraint,

            popupDetailInfoView.topAnchor.constraint(equalTo: segmentedGrayUnderLineView.bottomAnchor),
            popupDetailInfoView.leadingAnchor.constraint(equalTo: detailContentView.leadingAnchor),
            popupDetailInfoView.centerXAnchor.constraint(equalTo: detailContentView.centerXAnchor),
            popupDetailInfoView.bottomAnchor.constraint(equalTo: detailContentView.bottomAnchor)
        ])
    }
}
