//
//  SignUpLabel.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/24/24.
//

import UIKit

final class SignUpLabel: UILabel {
    private let leftPadding: CGFloat = 20

    init(text: String? = nil) {
        super.init(frame: .zero)
        self.text = text
        configureLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: 0))
        super.drawText(in: insetRect)
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftPadding, height: size.height)
    }
}

// MARK: - Configure Label
extension SignUpLabel {
    private func configureLabel() {
        font = UILabel.popcornMediumFont(size: 15)
        textColor = UIColor(resource: PopcornDarkBlueGray)
        textAlignment = .left
    }
}
