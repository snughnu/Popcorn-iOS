//
//  MainCollectionHeaderView.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/19/24.
//

import UIKit

final class MainCollectionHeaderView: UICollectionReusableView {
    private let header = MainCollectionTitleHeaderView()

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
extension MainCollectionHeaderView {
    func configureContents(headerTitle: String, shouldHiddenShowButton: Bool = false) {
        header.configureContents(headerTitle: headerTitle, shouldHiddenShowButton: shouldHiddenShowButton)
    }
}

// MARK: - Configure UI
extension MainCollectionHeaderView {
    private func configureSubviews() {
        [header].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: topAnchor),
            header.leadingAnchor.constraint(equalTo: leadingAnchor),
            header.bottomAnchor.constraint(equalTo: bottomAnchor),
            header.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
