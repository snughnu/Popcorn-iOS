//
//  SearchView.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 4/14/25.
//

import UIKit

class SearchView: UIView {
    private let searchTextField: UITextField = {
        let textField = UITextField()
        guard let baseFont = UIFont(name: RobotoFontName.robotoMedium, size: 17) else { return textField }
        let scaleFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: baseFont)
        let fontSize = scaleFont.pointSize

        textField.font = scaleFont
        textField.adjustsFontForContentSizeCategory = true
        textField.textColor = UIColor(.black)
        textField.attributedPlaceholder = NSAttributedString(
            string: "팝업스토어 검색",
            attributes: [
                .foregroundColor: UIColor(resource: .popcornDarkGrayOpacity3),
                .font: scaleFont
            ]
        )
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.backgroundColor = UIColor(.white)
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0
        textField.clipsToBounds = true

        let icon = UIImageView(image: UIImage(resource: .searchIcon))
        let iconWidth = fontSize * 19 / 17
        let containerHeight = fontSize * 19 / 17
        let leftPadding: CGFloat = 8
        let rightPadding: CGFloat = 6
        let containerWidth = leftPadding + iconWidth + rightPadding
        let container = UIView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: containerHeight))
        icon.contentMode = .scaleAspectFit
        icon.frame = CGRect(x: leftPadding, y: 0, width: iconWidth, height: containerHeight)
        container.addSubview(icon)

        textField.leftView = container
        textField.leftViewMode = .always

        return textField
    }()

    private let micButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .clear
        config.image = UIImage(resource: .mic)
        button.configuration = config
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureInitialSetting()
        configureSubviews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure Initial Setting
extension SearchView {
    private func configureInitialSetting() {
        backgroundColor = .brown
    }
}

// MARK: - Configure AutoLayout
extension SearchView {
    private func configureSubviews() {
        [
            searchTextField,
            micButton
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        let searchTextFieldHeight: CGFloat = (searchTextField.font?.pointSize ?? 17) * 50 / 17
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 9),
            searchTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: searchTextFieldHeight),

            micButton.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: -5),
            micButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor)
        ])
    }
}
