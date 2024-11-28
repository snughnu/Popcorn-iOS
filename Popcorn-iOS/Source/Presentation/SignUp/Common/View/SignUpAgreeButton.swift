//
//  SignUpAgreeButton.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/27/24.
//

import UIKit

final class SignUpAgreeButton: UIButton {
    init(
        title: String,
        color: UIColor = UIColor(resource: .popcornGray1),
        image: UIImage = UIImage(resource: .individualCheckButton),
        fontName: String = RobotoFontName.robotoMedium,
        fontSize: CGFloat = 13
    ) {
        super.init(frame: .zero)
        setupButton(
            title: title,
            color: color,
            image: image,
            fontName: fontName,
            fontSize: fontSize
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup ButtonUI
extension SignUpAgreeButton {
    private func setupButton(
        title: String,
        color: UIColor = UIColor(resource: .popcornGray1),
        image: UIImage = UIImage(resource: .individualCheckButton),
        selectedImage: UIImage = UIImage(resource: .individualCheckButtonSelected),
        fontName: String = RobotoFontName.robotoMedium,
        fontSize: CGFloat = 13
    ) {
        var config = UIButton.Configuration.plain()
        config.baseBackgroundColor = .clear
        config.image = image
        config.imagePlacement = .leading
        config.imagePadding = 10
        config.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer([
                .font: UIFont(name: fontName, size: fontSize)!,
                .foregroundColor: color
            ])
        )
        config.titleAlignment = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
        self.configuration = config
    }
}
