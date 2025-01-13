//
//  PopcornOrangeButton.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 1/12/25.
//

import UIKit

final class PopcornOrangeButton: UIButton {
    init(text: String) {
        super.init(frame: .zero)
        configureButton(text: text)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure Initial Setting
extension PopcornOrangeButton {
    private func configureButton(text: String) {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(resource: .popcornOrange)
        config.background.cornerRadius = 10
        config.attributedTitle = AttributedString(
            text,
            attributes: AttributeContainer([
                .font: UIFont(name: RobotoFontName.robotoSemiBold, size: 15)!,
                .foregroundColor: UIColor(.white)
            ])
        )
        configuration = config
    }
}
