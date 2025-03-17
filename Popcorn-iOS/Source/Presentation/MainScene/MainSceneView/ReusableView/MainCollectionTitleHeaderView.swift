//
//  MainCollectionTitleHeaderView.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 12/28/24.
//

import UIKit

final class MainCollectionTitleHeaderView: UIView {
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.popcornSemiBold(text: "제목", size: 21)
        return label
    }()

    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.popcornMedium(text: "전체 보기", size: 15)
        label.textColor = UIColor(resource: .popcornGray1)
        return label
    }()

    private let overviewArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(resource: .mainRightArrow)
        return imageView
    }()

    private lazy var overviewStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [overviewLabel, overviewArrowImageView])
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    private let bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .popcornGray2)
        return view
    }()

    weak var delegate: MainTitleHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureLayout()
        configureGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Interface
extension MainCollectionTitleHeaderView {
    func configureContents(headerTitle: String, shouldHiddenShowButton: Bool = false) {
        headerLabel.text = headerTitle
        overviewStackView.isHidden = shouldHiddenShowButton
    }
}

// MARK: - Configure Gesture
extension MainCollectionTitleHeaderView {
    private func configureGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        self.addGestureRecognizer(tapGesture)
    }

    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        guard let title = headerLabel.text else { return }
        delegate?.didTapHeader(title)
    }
}

// MARK: - Configure UI
extension MainCollectionTitleHeaderView {
    private func configureSubviews() {
        [headerLabel, overviewStackView, bottomBorder].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        headerLabel.setContentHuggingPriority(.required, for: .vertical)

        NSLayoutConstraint.activate([
            headerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            overviewStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            overviewStackView.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor),

            bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1),
            bottomBorder.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBorder.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBorder.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
