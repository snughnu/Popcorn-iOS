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

    private let popupTitleLabel: UILabel = {
        let label = UILabel()
        label.popcornSemiBold(text: "팝업 제목", size: 24)
        label.numberOfLines = 0
        return label
    }()

    private let popupPeriodLabel: UILabel = {
        let label = UILabel()
        label.popcornMedium(text: "00.00.00~00.00.00", size: 15)
        return label
    }()

    private let shareButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(resource: .shareButton), for: .normal)
        return button
    }()

    private let pickButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(resource: .pickButton), for: .normal)
        button.setImage(UIImage(resource: .pickButtonSelected), for: .selected)
        return button
    }()

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

    // MARK: - StackView
    private let popupTitlePriodStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 7
        stackView.alignment = .leading
        return stackView
    }()

    private let sharePickButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 18
        stackView.alignment = .center
        return stackView
    }()

    private let hashTagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()

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
        addTagsToHashtagStackView(tags: ["핑구", "캐릭터", "펭귄", "D-5", "굿즈", "이벤트", "여의도", "더현대서울"])
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

        [popupTitleLabel, popupPeriodLabel].forEach {
            popupTitlePriodStackView.addArrangedSubview($0)
        }

        [shareButton, pickButton].forEach {
            sharePickButtonStackView.addArrangedSubview($0)
        }

        [
            detailCarouselView,
            popupTitlePriodStackView,
            sharePickButtonStackView,
            hashTagStackView,
            segmentedControl,
            segmentedGrayUnderLineView,
            segmentedUnderLineView
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
            detailScrollView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            detailScrollView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),

            detailContentView.topAnchor.constraint(equalTo: detailScrollView.contentLayoutGuide.topAnchor),
            detailContentView.leadingAnchor.constraint(equalTo: detailScrollView.contentLayoutGuide.leadingAnchor),
            detailContentView.centerXAnchor.constraint(equalTo: detailScrollView.contentLayoutGuide.centerXAnchor),
            detailContentView.centerYAnchor.constraint(equalTo: detailScrollView.contentLayoutGuide.centerYAnchor),
            detailContentView.widthAnchor.constraint(equalTo: detailScrollView.widthAnchor),

            detailCarouselView.topAnchor.constraint(equalTo: detailContentView.topAnchor),
            detailCarouselView.leadingAnchor.constraint(equalTo: detailContentView.leadingAnchor),
            detailCarouselView.centerXAnchor.constraint(equalTo: detailContentView.centerXAnchor),

            popupTitlePriodStackView.topAnchor.constraint(equalTo: detailCarouselView.bottomAnchor, constant: 25),
            popupTitlePriodStackView.leadingAnchor.constraint(equalTo: detailContentView.leadingAnchor, constant: 27),

            sharePickButtonStackView.topAnchor.constraint(equalTo: detailCarouselView.bottomAnchor, constant: 29),
            sharePickButtonStackView.leadingAnchor.constraint(
                greaterThanOrEqualTo: popupTitlePriodStackView.trailingAnchor,
                constant: 10
            ),
            sharePickButtonStackView.trailingAnchor.constraint(
                equalTo: detailContentView.trailingAnchor,
                constant: -37
            ),

            hashTagStackView.topAnchor.constraint(equalTo: popupTitlePriodStackView.bottomAnchor, constant: 18),
            hashTagStackView.leadingAnchor.constraint(equalTo: detailContentView.leadingAnchor, constant: 27),
            hashTagStackView.centerXAnchor.constraint(equalTo: detailContentView.centerXAnchor),

            segmentedControl.topAnchor.constraint(equalTo: hashTagStackView.bottomAnchor, constant: 13),
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
            segmentedUnderLineView.bottomAnchor.constraint(equalTo: detailContentView.bottomAnchor)
        ])
    }
}

// MARK: - Configure HashTagStackView
extension MainDetailViewController {
    private func addTagsToHashtagStackView(tags: [String]) {
        var currentHorizontalStackView = createHorizontalStackView()
        hashTagStackView.addArrangedSubview(currentHorizontalStackView)

        var currentRowWidth: CGFloat = 0
        let stackViewLeftSpacing: CGFloat = 27
        let tagInterSpacing: CGFloat = 10
        let tagHorizontalInset: CGFloat = 10
        let maxWidth = view.bounds.width - (stackViewLeftSpacing * 2)

        for tag in tags {
            let tagLabel = createTagLabel(text: tag, tagHorizontalInset: tagHorizontalInset)
            let tagWidth = tagLabel.intrinsicContentSize.width + (tagInterSpacing * 2)

            if currentRowWidth + tagWidth > maxWidth {
                currentHorizontalStackView = createHorizontalStackView()
                hashTagStackView.addArrangedSubview(currentHorizontalStackView)
                currentRowWidth = 0
            }

            currentHorizontalStackView.addArrangedSubview(tagLabel)
            currentRowWidth += tagWidth + tagInterSpacing
        }
    }

    private func createHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }

    private func createTagLabel(text: String, tagHorizontalInset: CGFloat) -> UILabel {
        let label: UILabel = {
            let label = UILabel()
            label.popcornMedium(text: text, size: 13)
            label.textAlignment = .center
            label.backgroundColor = UIColor(resource: .popcornGray4)
            label.cornerRadius(radius: 15)
            return label
        }()
        let font = UIFont(name: RobotoFontName.robotoMedium, size: 13) ?? UIFont.systemFont(ofSize: 13)
        let labelWidth = text.size(withAttributes: [.font: font]).width + (tagHorizontalInset * 2)
        configureTagLabelLayout(label, labelWidth: labelWidth)

        return label
    }

    private func configureTagLabelLayout(_ label: UILabel, labelWidth: CGFloat) {
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 30),
            label.widthAnchor.constraint(equalToConstant: labelWidth)
        ])
    }
}
