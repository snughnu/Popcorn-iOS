//
//  SignUpInterestButton.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/26/24.
//

import UIKit

final class SignUpInterestButton: UIButton {
    private static let maxSelectableButton = 3
    static var selectedButtons: [SignUpInterestButton] = []

    static var selectedTitles: [String] {
        selectedButtons.compactMap { $0.currentTitle }
    }

    override var isSelected: Bool {
        didSet {
            updateSelectionState()
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

// MARK: - Configure Button UI
extension SignUpInterestButton {
    private func configureButtonUI(with title: String) {
        let screenHeight = UIScreen.main.bounds.height
        let fontSize = screenHeight * 15/852

        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(resource: .popcornLightGrayOpacity1)
        config.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer([
                .font: UIFont(name: RobotoFontName.robotoMedium, size: fontSize)!,
                .foregroundColor: UIColor(resource: .popcornDarkGrayOpacity3)
            ])
        )
        config.cornerStyle = .capsule
        self.configuration = config

        setTitle(title, for: .normal)
        setTitleColor(UIColor(resource: .popcornDarkGrayOpacity3), for: .normal)
        titleLabel?.font = UIFont(name: RobotoFontName.robotoMedium, size: fontSize)
    }

    private func setupConfigurationHandler() {
        configurationUpdateHandler = { [weak self] button in
            guard let self = self, let configuration = button.configuration else { return }
            var updatedConfig = configuration
            updatedConfig.baseBackgroundColor = self.isSelected
                ? UIColor(resource: .popcornOrange)
                : UIColor(resource: .popcornLightGrayOpacity1)
            updatedConfig.attributedTitle = AttributedString(
                button.configuration?.title ?? "",
                attributes: AttributeContainer([
                    .font: UIFont(name: RobotoFontName.robotoMedium, size: 15)!,
                    .foregroundColor: self.isSelected
                        ? UIColor.white
                        : UIColor(resource: .popcornDarkGrayOpacity3)
                ])
            )
            button.configuration = updatedConfig
        }
    }
}

// MARK: - Handle Button Actions
extension SignUpInterestButton {
    @objc private func buttonTapped() {
        isSelected.toggle()
    }

    private func updateSelectionState() {
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
