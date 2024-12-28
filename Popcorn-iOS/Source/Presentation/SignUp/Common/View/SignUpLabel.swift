//
//  SignUpLabel.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/24/24.
//

import UIKit

final class SignUpLabel: UILabel {
    init(text: String? = nil) {
        super.init(frame: .zero)
        self.text = text
        configureLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure Label
extension SignUpLabel {
    private func configureLabel() {
        let screenHeight = UIScreen.main.bounds.height
        let size = screenHeight * 10/852
        font = UIFont(name: RobotoFontName.robotoMedium, size: size)
        textColor = UIColor(.white)
        textAlignment = .left
    }
}
