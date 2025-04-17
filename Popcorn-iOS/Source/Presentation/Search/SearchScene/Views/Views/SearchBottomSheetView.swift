//
//  SearchBottomSheetView.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 4/14/25.
//

import UIKit

class SearchBottomSheetView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureInitialSetting()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure Initial Setting
extension SearchBottomSheetView {
    private func configureInitialSetting() {
        backgroundColor = .green
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
}
