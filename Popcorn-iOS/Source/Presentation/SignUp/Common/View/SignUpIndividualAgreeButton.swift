//
//  SignUpIndividualAgreeButton.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/27/24.
//

import UIKit

final class SignUpIndividualAgreeButton: UIButton {
    var onStateChange: ((Bool) -> Void)?

    init(title: String) {
        super.init(frame: .zero)
        setupButton(title: title)
        addAction(UIAction { _ in self.buttonTapped() }, for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup ButtonUI
extension SignUpIndividualAgreeButton {
    private func setupButton(
        title: String
    ) {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .clear
        config.image = UIImage(resource: .individualCheckButton)
        config.imagePlacement = .leading
        config.imagePadding = 10
        config.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer([
                .font: UIFont(name: RobotoFontName.robotoMedium, size: 13)!,
                .foregroundColor: UIColor(resource: .popcornGray1),
                .paragraphStyle: {
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineHeightMultiple = 1.27
                    paragraphStyle.alignment = .center
                    return paragraphStyle
                }()
            ])
        )
        config.titleAlignment = .center
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
        self.configuration = config
    }
}

// MARK: - Setup Button Action
extension SignUpIndividualAgreeButton {
    @objc private func buttonTapped() {
        isSelected.toggle()
        setNeedsUpdateConfiguration()
        onStateChange?(isSelected)
    }

    override func updateConfiguration() {
        super.updateConfiguration()
        self.configuration?.image = isSelected ?
        UIImage(resource: .individualCheckButtonSelected) :
        UIImage(resource: .individualCheckButton)
    }
}
