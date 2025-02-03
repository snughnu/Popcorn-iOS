//
//  PopupTitleCollectionViewCell.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 12/30/24.
//

import UIKit

final class PopupTitleCollectionViewCell: UICollectionViewCell {
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

    // MARK: - StackView
    private lazy var popupTitlePeriodStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [popupTitleLabel, popupPeriodLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 7
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var sharePickButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [shareButton, pickButton])
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Interface
extension PopupTitleCollectionViewCell {
    func configureContents(title: String, period: String, isUserPick: Bool, hashTags: [String]) {
        popupTitleLabel.text = title
        popupPeriodLabel.text = period
        pickButton.isSelected = isUserPick
        addTagsToHashtagStackView(tags: hashTags)
    }
}

// MARK: - Configure UI
extension PopupTitleCollectionViewCell {
    private func configureSubviews() {
        [popupTitlePeriodStackView, sharePickButtonStackView, hashTagStackView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            popupTitlePeriodStackView.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            popupTitlePeriodStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 27
            ),

            sharePickButtonStackView.topAnchor.constraint(equalTo: topAnchor, constant: 29),
            sharePickButtonStackView.leadingAnchor.constraint(
                greaterThanOrEqualTo: popupTitlePeriodStackView.trailingAnchor,
                constant: 10
            ),
            sharePickButtonStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -37
            ),

            hashTagStackView.topAnchor.constraint(equalTo: popupTitlePeriodStackView.bottomAnchor, constant: 18),
            hashTagStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 27),
            hashTagStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -13),
            hashTagStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

// MARK: - Configure PopupTitleCollectionViewCell
extension PopupTitleCollectionViewCell {
    private func addTagsToHashtagStackView(tags: [String]) {
        hashTagStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        var currentHorizontalStackView = createHorizontalStackView()
        hashTagStackView.addArrangedSubview(currentHorizontalStackView)

        var currentRowWidth: CGFloat = 0
        let stackViewLeftSpacing: CGFloat = 27
        let tagInterSpacing: CGFloat = 10
        let tagHorizontalInset: CGFloat = 10
        let maxWidth = bounds.width - (stackViewLeftSpacing * 2)

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
