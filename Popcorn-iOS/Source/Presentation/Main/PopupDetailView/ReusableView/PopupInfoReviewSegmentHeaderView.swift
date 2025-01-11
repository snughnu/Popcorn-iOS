//
//  PopupInfoDescriptionCollectionReusableView.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 12/30/24.
//

import UIKit

protocol PopupInfoReviewSegmentHeaderViewDelegate: AnyObject {
    func didChangedSegment(to index: Int)
}

final class PopupInfoReviewSegmentHeaderView: UICollectionReusableView {
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
        return view
    }()

    private let segmentedGrayUnderLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .popcornGray2)
        return view
    }()

    private var segmentedUnderlineLeadingConstraint: NSLayoutConstraint!

    weak var delegate: PopupInfoReviewSegmentHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureLayout()
        configureActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure Action
extension PopupInfoReviewSegmentHeaderView {
    private func configureActions() {
        segmentedControl.addTarget(self, action: #selector(changeSegmentedLinePosition), for: .valueChanged)
    }

    @objc private func changeSegmentedLinePosition(_ segment: UISegmentedControl) {
        let leadingOffset: CGFloat = CGFloat(segmentedControl.selectedSegmentIndex)
        * bounds.width
        / CGFloat(segmentedControl.numberOfSegments)

        segmentedUnderlineLeadingConstraint.constant = leadingOffset

        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }

        delegate?.didChangedSegment(to: segmentedControl.selectedSegmentIndex)
    }
}

// MARK: - Configure UI
extension PopupInfoReviewSegmentHeaderView {
    private func configureSubviews() {
        [segmentedControl, segmentedGrayUnderLineView, segmentedUnderLineView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        segmentedUnderlineLeadingConstraint = segmentedUnderLineView.leadingAnchor.constraint(
            equalTo: segmentedControl.leadingAnchor
        )

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),

            segmentedGrayUnderLineView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            segmentedGrayUnderLineView.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor),
            segmentedGrayUnderLineView.trailingAnchor.constraint(equalTo: segmentedControl.trailingAnchor),
            segmentedGrayUnderLineView.heightAnchor.constraint(equalToConstant: 3),

            segmentedUnderLineView.topAnchor.constraint(equalTo: segmentedGrayUnderLineView.topAnchor),
            segmentedUnderLineView.widthAnchor.constraint(
                equalTo: segmentedGrayUnderLineView.widthAnchor, multiplier: 0.5
            ),
            segmentedUnderLineView.heightAnchor.constraint(equalToConstant: 3),

            segmentedUnderlineLeadingConstraint
        ])
    }
}
