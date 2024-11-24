//
//  UIButton+.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/24/24.
//

import UIKit

extension UIButton {
    func applyPopcornFont(
        text: String,
        fontName: String,
        fontSize: CGFloat,
        isSmallLetterSpacing: Bool = false
    ) {
        let attributedTitle = UILabel.applyCustomFont(
            text: text,
            fontName: fontName,
            fontSize: fontSize,
            isSmallLetterSpacing: isSmallLetterSpacing
        )
        self.setAttributedTitle(attributedTitle, for: .normal)
    }

    func popcornMedium(text: String, size: CGFloat) {
        let attributedTitle = UILabel.applyCustomFont(text: text, fontName: RobotoFontName.robotoMedium, fontSize: size)
        self.setAttributedTitle(attributedTitle, for: .normal)
    }

    func popcornSemiBold(text: String, size: CGFloat, isSmallLetterSpacing: Bool = false) {
        let attributedTitle = UILabel.applyCustomFont(
            text: text,
            fontName: RobotoFontName.robotoSemiBold,
            fontSize: size
        )
        self.setAttributedTitle(attributedTitle, for: .normal)
    }
}
