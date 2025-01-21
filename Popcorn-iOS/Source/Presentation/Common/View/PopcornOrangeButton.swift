//
//  PopcornOrangeButton.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 1/12/25.
//

import UIKit

final class PopcornOrangeButton: UIButton {
    init(text: String, isEnabled: Bool) {
        super.init(frame: .zero)
        configureInitialSetting(isEnabled: isEnabled)
        configureButtonUI(text: text)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure Initial Setting
extension PopcornOrangeButton {
    private func configureInitialSetting(isEnabled: Bool) {
        self.isEnabled = isEnabled
        self.cornerRadius(radius: 10)
    }

    private func configureButtonUI(text: String) {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = isEnabled == true
        ? UIColor(resource: .popcornOrange)
        : UIColor(resource: .popcornGray2)
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
