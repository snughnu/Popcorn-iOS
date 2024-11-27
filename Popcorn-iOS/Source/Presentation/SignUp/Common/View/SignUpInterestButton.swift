//
//  SignUpButton.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/26/24.
//

import UIKit

final class SignUpInterestButton: UIButton {
    private static let maxSelectableButton = 3
    private static var selectedButtons: [SignUpInterestButton] = []

    override var isSelected: Bool {
        didSet {
            if isSelected {
                if !Self.selectedButtons.contains(self) {
                    Self.selectedButtons.append(self)
                }
                if Self.selectedButtons.count > Self.maxSelectableButton {
                    let buttonToDeselect = Self.selectedButtons.removeFirst()
                    buttonToDeselect.isSelected = false
                }
            } else {
                if let index = Self.selectedButtons.firstIndex(of: self) {
                    Self.selectedButtons.remove(at: index)
                }
            }
            setNeedsUpdateConfiguration()
        }
    }

    init(title: String) {
        super.init(frame: .zero)
        configureButtonUI(with: title)
        setupConfigurationHandler()
        addAction(UIAction { _ in self.buttonTapped() }, for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure SignUp Interest Button UI
extension SignUpInterestButton {
    private func configureButtonUI(with title: String) {
        var config = UIButton.Configuration.filled()
// TODO: 리소스 색상 변경
        config.baseBackgroundColor = UIColor(resource: .popcornGray2)
        config.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer([
                .font: UIFont(name: RobotoFontName.robotoMedium, size: 15)!,
// TODO: 리소스 색상 변경
                .foregroundColor: UIColor(resource: .popcornGray1)
            ])
        )
        config.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 14, bottom: 7, trailing: 14)
        self.configuration = config
    }

    private func setupConfigurationHandler() {
        configurationUpdateHandler = { [weak self] button in
            guard let self = self, let configuration = button.configuration else { return }
            var updatedConfig = configuration
            updatedConfig.baseBackgroundColor = self.isSelected
                ? UIColor(resource: .popcornOrange)
// TODO: 리소스 색상 변경
                : UIColor(resource: .popcornGray2)
            updatedConfig.attributedTitle = AttributedString(
                button.configuration?.title ?? "",
                attributes: AttributeContainer([
                    .font: UIFont(name: RobotoFontName.robotoMedium, size: 15)!,
                    .foregroundColor: self.isSelected
                        ? UIColor.white
// TODO: 리소스 색상 변경
                        : UIColor(resource: .popcornGray1)
                ])
            )
            button.configuration = updatedConfig
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

// MARK: - Configure SignUp Interest Button Actions
extension SignUpInterestButton {
    @objc private func buttonTapped() {
        isSelected.toggle()
    }
}
