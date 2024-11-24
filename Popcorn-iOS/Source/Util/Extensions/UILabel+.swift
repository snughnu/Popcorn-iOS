//
//  UILabel+.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/24/24.
//

import UIKit

extension UILabel {
    static let letterSpacing: CGFloat = 0
    static let smallLetterSpacing: CGFloat = -1

    static func applyCustomFont(
        text: String,
        fontName: String,
        fontSize: CGFloat,
        isSmallLetterSpacing: Bool = false
    ) -> NSAttributedString {
        let font = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        let letterSpacing = isSmallLetterSpacing ? smallLetterSpacing : letterSpacing

        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes(
            [.font: font, .kern: letterSpacing],
            range: NSRange(location: 0, length: attributedString.length)
        )
        return attributedString
    }

    func popcornMedium(text: String, size: CGFloat) {
        self.attributedText = UILabel.applyCustomFont(text: text, fontName: RobotoFontName.robotoMedium, fontSize: size)
    }
    
    /// UILabel의 RobotoFlex-SemiBold Font를 적용시키는 함수.
    /// - Parameters:
    ///   - text: 폰트를 적용할 텍스트
    ///   - size: 폰트 크기
    ///   - isSmallLetterSpacing: 아이디/비밀번호 찾기 화면의 네비게이션 타이틀에서 자간이 -1이므로 true값을 주면, -1 자간 적용됨.
    func popcornSemiBold(text: String, size: CGFloat, isSmallLetterSpacing: Bool = false) {
        self.attributedText = UILabel.applyCustomFont(
            text: text,
            fontName: RobotoFontName.robotoSemiBold,
            fontSize: size,
            isSmallLetterSpacing: isSmallLetterSpacing
        )
    }
}
